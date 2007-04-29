class AlterRunningLog < ActiveRecord::Migration
    def self.up
      change_column :log_entries, :miles, :float
    end

    def self.down
      change_column :log_entries, :miles, :integer
    end
end
