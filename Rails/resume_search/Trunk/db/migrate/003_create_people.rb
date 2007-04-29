class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.column :user_id, :integer
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :title, :string
      t.column :address1, :string
      t.column :address2, :string
      t.column :city, :string
      t.column :state, :string
      t.column :postal, :string
      t.column :country, :string
    end
  end

  def self.down
    drop_table :people
  end
end
