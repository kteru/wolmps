require 'active_record'
require 'sqlite3'


task :default => :migrate

task :migrate do
  ActiveRecord::Base.configurations = YAML.load_file(File.expand_path(File.dirname(__FILE__)) + '/database.yml')
  ActiveRecord::Base.establish_connection('production')
  ActiveRecord::Migration.create_table :macs do |t|
    t.column :addr, :string
    t.column :desc, :string
    t.column :pos,  :integer, :default => 0, :null => false
  end
end

