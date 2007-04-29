class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.column :user_id, :integer
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :birth_date, :date
      t.column :bio, :text
    end
  end

  def self.down
    drop_table :profiles
  end
end
