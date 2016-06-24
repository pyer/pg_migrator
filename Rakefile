# Rakefile
require 'rake'

rakefiles = Rake::FileList["tasks/*.rake"]
rakefiles.each do |file|
  load "#{file}"
end

task default: :config
