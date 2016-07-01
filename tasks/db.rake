# coding: utf-8

desc 'Show the current database version'
task version: [:load_config] do
  puts "Environment  : #{@config.env}"
  puts "Database     : #{@config.database}"
  puts "Version      : #{DB.version(@config)}"
  puts "Next version : #{DB.version(@config).next}"
end

desc 'List the current database migrations'
task migrations: [:load_config] do
  DB.migrations(@config).each do |row|
    puts row['version'] + '  ' + row['updated_on']
  end
end

desc 'List the databases'
task databases: [:load_config] do
  DB.databases(@config).each do |row|
    puts row['datname']
  end
end

namespace :db do
  desc 'Create the current database'
  task create: [:load_config] do
    DB.create(@config)
  end

  desc 'Drop the current database'
  task drop: [:load_config] do
    DB.drop(@config)
  end

  desc 'Migrate the current database to the last version'
  task migrate: [:load_config] do
    DB.migrate(@config)
  end

  desc 'Roll the current database back to the previous version'
  task rollback: [:environment, :load_config] do
    DB.rollback(@config)
  end

  desc 'Push the current database to the next version'
  task forward: [:environment, :load_config] do
    DB.forward(@config)
  end
end
