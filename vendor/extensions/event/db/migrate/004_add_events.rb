class AddEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :time
      t.string :location
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :events
  end
end
