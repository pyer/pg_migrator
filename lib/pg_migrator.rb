# coding: utf-8

# Load rake tasks
class PGMigrator
  def initialize
    $LOAD_PATH.each do |p|
      Dir["#{p}/*"].each do |d|
        load d if %r{pg_migrator.*/tasks/.*\.rake$}.match(d)
      end
    end
  end
end
