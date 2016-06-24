require 'rake/testtask'

Rake::TestTask.new do |t|
#  t.test_files = FileList['test/test*.rb']
  if Rake.verbose
    t.verbose = true
    ENV['verbose'] = 'true'
  else
    t.verbose = false
    ENV['verbose'] = 'false'
  end
end
