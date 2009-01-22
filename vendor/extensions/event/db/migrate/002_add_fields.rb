class AddFields < ActiveRecord::Migration
  def self.up
    add_column :performers, :image, :string
  end

  def self.down
    remove_column :performers, :image
  end
end
