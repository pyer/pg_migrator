# coding: utf-8
require 'config'
require 'postgres'

# Database managment
class DB
  def self.create(config)
    pg = Postgres.new(config, 'postgres')
    pg.execute("CREATE DATABASE #{config.database} OWNER #{config.username};")
    pg.finish
    DB.version(config) # create migrations table
    pg.ok?
  end

  def self.drop(config)
    pg = Postgres.new(config, 'postgres')
    pg.execute("DROP DATABASE #{config.database};")
    pg.finish
    pg.ok?
  end

  def self.version(config)
    pg = Postgres.new(config)
    ver = pg.value('SELECT version FROM migrations ORDER BY updated_on DESC LIMIT 1;')
    if ver.empty? && pg.connected?
      ver = config.version0
      pg.execute("CREATE TABLE migrations (
                    version character varying NOT NULL,
                    updated_on timestamp without time zone);")
      pg.execute("INSERT INTO migrations VALUES('#{ver}', now());")
    end
    pg.finish
    ver
  end

  def self.migrations(config)
    mig = []
    pg = Postgres.new(config)
    mig = pg.execute('SELECT * FROM migrations ORDER BY updated_on;') if pg.ok?
    pg.finish
    mig
  end

  def self.databases(config)
    dbs = []
    pg = Postgres.new(config, 'postgres')
    dbs = pg.execute('SELECT * FROM pg_database ORDER BY datname;') if pg_ok?
    pg.finish
    dbs
  end

  def self.migrate(config)
    db_version = DB.version(config)
    return nil if db_version.empty?
    Dir[config.upgrade].sort.each do |file|
      next unless config.version(file) > db_version
      pg = Postgres.new(config)
      pg.update(file)
      pg.finish
    end
  end

  def self.forward(config)
    db_version = DB.version(config)
    return nil if db_version.empty?
    db_version.next!
    Dir[config.upgrade].sort.each do |file|
      next unless config.version(file) == db_version
      pg = Postgres.new(config)
      pg.update(file)
      pg.finish
    end
  end

  def self.rollback(config)
    db_version = DB.version(config)
    return nil if db_version.empty?
    Dir[config.downgrade].sort.each do |file|
      next unless config.version(file) == db_version
      pg = Postgres.new(config)
      pg.update(file)
      pg.execute("DELETE FROM migrations WHERE version='#{db_version}';")
      pg.finish
    end
  end
end
