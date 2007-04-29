class CreateWeeklyComments < ActiveRecord::Migration
  def self.up
    create_table :weekly_comments do |t|
      t.column :log_id, :integer, :default => 0
      t.column :comments, :text, :default => nil
    end
  end

  def self.down
    drop :weekly_comments
  end
end
