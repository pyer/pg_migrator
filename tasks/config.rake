# coding: utf-8
require 'rake'
require 'config'

@config  = nil

task :load_config do
  @config = Config.new
end

desc 'Show configuration'
task config: :load_config do
  puts "Environment : #{@config.env}"
  if @config.database.nil?
    @config.create
    puts 'ERROR: empty config file'
  else
    puts "Host        : #{@config.host}"
    puts "Port        : #{@config.port}"
    puts "User        : #{@config.username}"
    puts "Database    : #{@config.database}"
  end
end

# Environment is defined by the ENV variable
# For example:
#   rake migrate env=dev
desc 'Show environments'
task environments: :load_config do
  Rake::FileList['config/*'].each do |file|
    puts file.split('/')[1]
  end
end

task default: :config
