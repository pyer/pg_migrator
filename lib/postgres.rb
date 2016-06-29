# coding: utf-8
require 'pg'

# Postgres database API
class Postgres
  attr_reader :config, :connection, :status

  def initialize(conf, user = nil)
    @status = true
    @config = conf

    begin
      if user.nil?
        @connection = PG::Connection.new(dbname: @config.database, user: @config.username, password: @config.password,
                                         host: @config.host, port: @config.port)
      else
        # assuming user is postgres, dbname is also postgres
        @connection = PG::Connection.new(dbname: user, user: user,
                                         host: config.host, port: config.port)
      end
    rescue PG::Error => e
      puts e.message if @config.verbose
      @connection = nil
      @status = false
    end
  end

  def connected?
    ! @connection.nil?
  end

  def ok?
    @status
  end

  def finish
    @connection.finish unless @connection.nil?
    @status
  end

  def execute(query)
    begin
      result = @connection.query(query)
    rescue PG::Error => e
      puts e.message if @config.verbose
      # puts "ERROR: failed query [#{query}]" if @config.verbose
      @status = false
      result = nil
    end
    result
  end

  def value(query)
    return '' unless @status
    begin
      result = @connection.query(query)
      return result.getvalue(0, 0).to_s
    rescue PG::Error => e
      puts e.message if @config.verbose
      @status = false
      return ''
    end
  end

  def update(file, update)
    puts "  execute #{file}" if @config.verbose
    eval(File.read("./#{file}"))
    ver = file.gsub(/\D/, '')[0, 3]
    begin
      @connection.query('BEGIN;')
      if update
        query = @up
      else
        query = @down
        ver = format('%03d', ver.to_i - 1)
      end
      @connection.query(query)
      @connection.query("INSERT INTO migrations VALUES('#{ver}', now());")
      @connection.query('COMMIT;')
    rescue PG::Error => e
      puts e.message if @config.verbose
      @connection.query('ROLLBACK;')
    end
  end
end
