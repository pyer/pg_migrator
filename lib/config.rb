# coding: utf-8
require 'pyer/properties'

# Read configuration file
class Config
  attr_reader :env, :host, :port, :username, :password, :database, :pattern, :verbose

  def initialize
    @env = ENV['env']
    @env = 'dev' if @env.nil?
    config = Pyer::Properties.new("config/#{@env}")
    @host     = config.host
    @port     = config.port
    @username = config.username
    @password = config.password
    @database = config.database
    @pattern  = config.pattern
    @verbose  = ENV['verbose'] == 'true'
  end
end
