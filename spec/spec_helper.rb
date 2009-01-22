require 'pathname'
require 'rubygems'
require 'activerecord'
require 'active_record/fixtures'

gem 'rspec', '~>1.1.11'
require 'spec'

SPEC_ROOT = Pathname(__FILE__).dirname.expand_path
require SPEC_ROOT.parent + 'lib/pagination_scope'

# setup mock adapters
def make_connection(clazz, db_file)
  FileUtils.rm(db_file) if File.exist?(db_file)
  ActiveRecord::Base.configurations = { clazz.name => { :adapter => 'sqlite3', :database => db_file, :timeout => 5000 } }
  unless File.exist?(db_file)
    puts "Building SQLite3 database at #{db_file}."
    sqlite_command = %Q{sqlite3 "#{db_file}" "create table a (a integer); drop table a;"}
    puts "Executing '#{sqlite_command}'"
    raise SqliteError.new("Seems that there is no sqlite3 executable available") unless system(sqlite_command)
  end
  clazz.establish_connection(clazz.name)
end

sqlite_test_db  = "#{SPEC_ROOT}/test.sqlite3"
make_connection(ActiveRecord::Base, sqlite_test_db)

# ----------------------------------------------------------------------
# --- Migration      ---
# ----------------------------------------------------------------------

Dir.glob(SPEC_ROOT + 'migrations' + '*.rb').sort.each do |migration|
  require migration
end

# TODO: should resolv class names automatically
CreateUsers.up
CreateGroups.up

Dir.glob(SPEC_ROOT + 'models' + '*.rb').each do |model|
  require model
end

Dir.glob(SPEC_ROOT + 'fixtures' + '*.{yml,csv}').each do |fixture_file|
  Fixtures.create_fixtures('fixtures', File.basename(fixture_file, '.*'))
end

Spec::Runner.configure do |config|
  config.before(:each) do
#    Item.delete_all
  end
end


