class CreateSchedule < ActiveRecord::Migration
  def self.up
  create_table :schedules do |t|
  t.column :description, :string, :default => nil
  end
  end

  def self.down
  drop_table :schedules
  end
end
