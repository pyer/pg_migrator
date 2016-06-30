# coding: utf-8
require 'pyer/properties'

# Read configuration file
class Config
  attr_reader :env, :host, :port, :username, :password, :database, :version0, :upgrade, :downgrade, :verbose

  def initialize
    @env = ENV['env']
    @env = 'dev' if @env.nil?
    config = Pyer::Properties.new("config/#{@env}")
    @host      = config.host
    @port      = config.port
    @username  = config.username
    @password  = config.password
    @database  = config.database
    @version0  = config.version0
    @upgrade   = config.upgrade
    @downgrade = config.downgrade
    @verbose   = ENV['verbose'] == 'true'
  end

  def create
    Dir.mkdir 'config' unless File.exist?('config')
    File.open("config/#{@env}", 'w') do |f|
      f.write("database  = \n")
      f.write("host      = localhost\n")
      f.write("port      = 5432\n")
      f.write("username  = \n")
      f.write("password  = \n")
      f.write("encoding  = utf8\n")
      f.write("version0  = 0.00\n")
      f.write("upgrade   = migrations/*_up_*.sql\n")
      f.write("downgrade = migrations/*_down_*.sql\n")
    end unless File.exist?("config/#{@env}")
  end

  # Extract version number from the SQL script path name
  # Version is text between last '/' and '_'
  # File path must end with '.sql'
  def version(path)
     path.gsub(/.*\//,'').gsub(/_.*\.sql/, '')
   end
end
