# coding: utf-8
require 'db'

desc 'Retrieves the current database version number'
task version: [:load_config] do
  puts "Environment : #{@config.env}"
  puts "Database    : #{@config.database}"
  puts "Version     : #{DB.version(@config)}"
end

desc 'Lists the current database migrations'
task migrations: [:load_config] do
  DB.migrations(@config).each do |row|
    puts row['version'] + '  ' + row['updated_on']
  end
end

desc 'Lists the databases'
task databases: [:load_config] do
  DB.databases(@config).each do |row|
    puts row['datname']
  end
end

namespace :db do
  desc 'Creates the current database'
  task create: [:load_config] do
    DB.create(@config)
  end

  desc 'Drops the current database'
  task drop: [:load_config] do
    DB.drop(@config)
  end

  desc 'Migrate the current database to the last version'
  task migrate: [:load_config] do
    DB.migrate(@config)
  end

  desc 'Rolls the current database back to the previous version'
  task rollback: [:environment, :load_config] do
    DB.rollback(@config)
  end

  desc 'Pushes the current database to the next version'
  task forward: [:environment, :load_config] do
    DB.forward(@config)
  end
end
