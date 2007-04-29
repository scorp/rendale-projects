class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.column :attachable_id, :integer
      t.column :attachable_type, :string
      t.column :type, :string
      t.column :name, :string
      t.column :content_type, :string
      t.column :date, :datetime
      t.column :clear_text, :text
      t.column :data, :longblob
    end
  end

  def self.down
    drop_table :attachments
  end
end
