class CreateAttachmentBinaries < ActiveRecord::Migration
  def self.up
    create_table :attachment_binaries do |t|
      t.column :attachment_id, :integer, :null=>false
      t.column :data, :longblob, :null=>false
    end
  end

  def self.down
    drop_table :attachment_binaries
  end
end
