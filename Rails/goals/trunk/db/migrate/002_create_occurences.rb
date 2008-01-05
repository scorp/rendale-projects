class CreateOccurences < ActiveRecord::Migration
  def self.up
    create_table :occurences do |t|
      t.integer, :goal_id
      t.integer, :value
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :occurences
  end
end
