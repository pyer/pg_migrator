# coding: utf-8
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rubygems'
require 'rubygems/package'
require 'rubygems/installer'
require './lib/config.rb'
require './lib/db.rb'

spec = Gem::Specification.load('pg_migrator.gemspec')
target = "#{spec.name}-#{spec.version}.gem"

CLEAN.include "#{spec.name}*.gem"

Rake::TestTask.new do |t|
  # Beware: Rake.verbose can be undefined (class Object but not nil)
  if Rake.verbose == true
    t.verbose = true
    ENV['verbose'] = 'true'
  else
    t.verbose = false
    ENV['verbose'] = 'false'
  end
end

desc 'Build gem'
task build: 'clean' do
  Gem::Package.build spec, true
end

desc 'Install gem'
task install: 'build' do
  gi = Gem::Installer.new target
  gi.install
end

rakefiles = Rake::FileList['tasks/*.rake']
rakefiles.each do |file|
  load "#{file}"
end
