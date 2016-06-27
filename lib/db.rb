require 'config'
require 'postgres'

module DB
  def DB::create(config)
    pg = Postgres.new(config, 'postgres')
    pg.execute("CREATE DATABASE #{config.database} OWNER #{config.username};")
    pg.finish
    DB::version(config) # create migrations table
    return pg.ok?
  end

  def DB::drop(config)
    pg = Postgres.new(config, 'postgres')
    pg.execute("DROP DATABASE #{config.database};")
    pg.finish
    return pg.ok?
  end

  def DB::version(config)
    pg = Postgres.new(config)
    ver = pg.value("SELECT version FROM migrations ORDER BY updated_on DESC LIMIT 1;")
    if ver.empty? and pg.connected?
      pg.execute("CREATE TABLE migrations (
                    version character varying NOT NULL,
                    updated_on timestamp without time zone);")
      pg.execute("INSERT INTO migrations VALUES('000', now());")
      ver = '000'
    end
    pg.finish
    return ver
  end

  def DB::migrations(config)
    pg = Postgres.new(config)
    return [] unless pg.ok?
    mig = pg.execute("SELECT * FROM migrations ORDER BY updated_on;")
    pg.finish
    return mig
  end

  def DB::databases(config)
    pg = Postgres.new(config, 'postgres')
    return [] unless pg.ok?
    dbs = pg.execute("SELECT * FROM pg_database ORDER BY datname;")
    pg.finish
    return dbs
  end

  def DB::migrate(config)
    db_version = DB::version(config)
    return nil if db_version.empty?
    Dir[config.pattern].sort.each do |file|
      file_version = file.gsub(/\D/,'')[0,3].to_i
      if file_version > db_version.to_i
        pg = Postgres.new(config)
        pg.update(file, true)
        pg.finish
      end
    end
  end

  def DB::rollback(config)
    db_version = DB::version(config)
    return nil if db_version.empty?
    Dir[config.pattern].sort.each do |file|
      file_version = file.gsub(/\D/,'')[0,3]
      if file_version == db_version
        pg = Postgres.new(config)
        pg.update(file, false)
        pg.finish
      end
    end
  end

  def DB::forward(config)
    db_version = DB::version(config)
    return nil if db_version.empty?
    Dir[config.pattern].sort.each do |file|
      file_version = file.gsub(/\D/,'')[0,3].to_i
      if file_version == (db_version.to_i + 1)
        pg = Postgres.new(config)
        pg.update(file, true)
        pg.finish
      end
    end
  end
end
