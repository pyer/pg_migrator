require 'rake'
require 'config'

@config  = nil

def create_config
  Dir.mkdir 'migrations' unless File.exists?('migrations')
  Dir.mkdir 'config'     unless File.exists?('config')
  File.open("config/#{@config.env}", 'w') do |f|
    f.write("database = \n")
    f.write("host     = localhost\n")
    f.write("port     = 5432\n")
    f.write("username = \n")
    f.write("password = \n")
    f.write("encoding = utf8\n")
    f.write("pattern  = migrations/*.rb\n")
  end  unless File.exists?("config/#{@config.env}")
end

task :load_config do
  @config = Config.new
end

desc 'Show configuration'
task config: :load_config do
  puts "Environment : #{@config.env}"
  if @config.database.nil?
    create_config
    puts "ERROR: empty config file"
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
desc "Show environments"
task environments: :load_config do
  Rake::FileList["config/*"].each do |file|
    puts file.split('/')[1]
  end
end

task default: :config
