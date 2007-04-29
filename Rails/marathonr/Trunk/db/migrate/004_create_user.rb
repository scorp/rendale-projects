class CreateUser < ActiveRecord::Migration
  def self.up
  create_table :users do |t|
  t.column :login, :string, :default => nil
  t.column :password, :string, :default => nil
  t.column :first_name, :string, :default => nil
  t.column :last_name, :string, :default => nil
  t.column :gender, :string, :date => nil
  t.column :birthday, :integer, :date => nil
  t.column :bio, :text, :date => nil
  end
  end

  def self.down
  drop_table :users
  end
end
