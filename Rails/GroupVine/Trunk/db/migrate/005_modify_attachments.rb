class ModifyAttachments < ActiveRecord::Migration
  def self.up
    remove_column :attachments, :attachable_id
    remove_column :attachments, :attachable_type
  end

  def self.down
    add_column :attachments, :attachable_id, :integer
    add_column :attachments, :attachable_type, :string
  end
end
