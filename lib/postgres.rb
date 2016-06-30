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
      trace e.message
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

  def trace(message)
    puts message if @config.verbose
  end

  def execute(query)
    begin
      trace query
      result = @connection.query(query)
    rescue PG::Error => e
      trace e.message
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
      trace e.message
      @status = false
      return ''
    end
  end

  def script(file)
    query = ''
    file.each_line do |line|
      trace line
      query = query + ' ' + line
      if query.end_with?(';')
        @connection.query(query)
        query = ''
      end
    end
  end

  def update(file_name)
    puts "Executing #{file_name}" if @config.verbose
    ver = @config.version(file_name)
    begin
      trace 'BEGIN;'
      @connection.query('BEGIN;')
      file = File.open(file_name, 'r')
      script(file)
      file.close
      @connection.query("INSERT INTO migrations VALUES('#{ver}', now());")
      trace 'COMMIT;'
      @connection.query('COMMIT;')
    rescue SystemCallError => e
      trace e.message
      @connection.query('ROLLBACK;')
    rescue PG::Error => e
      trace e.message
      @connection.query('ROLLBACK;')
    end
  end
end
