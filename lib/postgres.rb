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

  def update(file_name)
    puts "Executing #{file_name}" if @config.verbose
    ver = @config.version(file_name)
    begin
      puts 'BEGIN;' if @config.verbose
      @connection.query('BEGIN;')
      file = File.open(file_name, 'r')
      query = ''
      file.each_line do |line|
        puts line if @config.verbose
        query = query + ' ' + line
        if query.end_with?(';')
          @connection.query(line)
          query = ''
        end
      end
      file.close
      @connection.query("INSERT INTO migrations VALUES('#{ver}', now());")
      puts 'COMMIT;' if @config.verbose
      @connection.query('COMMIT;')
    rescue SystemCallError => e
      puts e.message if @config.verbose
      @connection.query('ROLLBACK;')
    rescue PG::Error => e
      puts e.message if @config.verbose
      @connection.query('ROLLBACK;')
    end
  end
end
