class CreateUser < ActiveRecord::Migration
  def self.up
  create_table :users do |t|
  t.column :login, :string, :default => nil
  t.column :password, :string, :default => nil
  end
  end

  def self.down
  drop_table :users
  end
end