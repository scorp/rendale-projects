class AlterSchedule < ActiveRecord::Migration
    def self.up
      add_column :schedules, :running_log_id, :integer
    end

    def self.down
      remove_column :schedules, :running_log_id
    end
end
