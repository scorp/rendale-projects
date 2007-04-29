class CreateScheduleEntry < ActiveRecord::Migration
  def self.up
    create_table :schedule_entries do |t|
      t.column :schedule_id, :integer, :default => 0
      t.column :date, :date, :default => nil
      t.column :miles, :integer, :default => 0
      t.column :time, :integer, :default => 0
      t.column :comments, :text, :default => nil
    end
  end

  def self.down
    drop :schedule_entries
  end
end
