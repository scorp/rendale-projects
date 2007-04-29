class CreateRunningLogs < ActiveRecord::Migration
  def self.up
    create_table :running_logs do |t|
      t.column :user_id, :integer, :default => 0
      t.column :schedule_id, :integer, :default => 0
      t.column :description, :string, :default => nil      
    end
  end

  def self.down
    drop :running_logs
  end
end
