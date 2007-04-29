class CreateLogEntry < ActiveRecord::Migration
  def self.up
    create_table :log_entries do |t|
      t.column :running_log_id, :integer, :default => 0
      t.column :date, :date, :default => nil
      t.column :miles, :integer, :default => 0
      t.column :time, :integer, :default => 0
      t.column :comments, :text, :default => nil
    end
  end

  def self.down
    drop :log_entries
  end
end
