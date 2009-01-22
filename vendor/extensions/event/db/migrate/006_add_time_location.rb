class AddTimeLocation < ActiveRecord::Migration
  def self.up
    add_column :performers, :time, :string
        add_column :performers, :location, :string
  end

  def self.down
    remove_column :performers, :time
    remove_column :performers, :location
  end
end
