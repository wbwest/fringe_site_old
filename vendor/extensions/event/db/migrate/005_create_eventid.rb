class CreateEventid < ActiveRecord::Migration
  def self.up
    add_column :performers, :event_id, :int
  end

  def self.down
    remove_column :performers, :event_id
  end
end
