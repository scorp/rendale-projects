class CreateGoals < ActiveRecord::Migration
  def self.up
    create_table :goals do |t|
      t.string, :title
      t.text, :description
      t.string :units

      t.timestamps
    end
  end

  def self.down
    drop_table :goals
  end
end
