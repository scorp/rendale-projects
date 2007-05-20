class AddColorToTags < ActiveRecord::Migration
  def self.up
    drop_table :taggings

    create_table :taggings do |t| 
      t.column :taggable_id, :integer 
      t.column :user_id, :integer
      t.column :tag_id, :integer 
      t.column :taggable_type, :string 
    end  
    
    drop_table :tags
    
    create_table :tags do |t| 
      t.column :user_id, :integer
      t.column :name, :string 
      t.column :color, :string, :default=>"yellow"
    end  
    
  end

  def self.down
  end
end
