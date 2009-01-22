class CreatePerformers < ActiveRecord::Migration
  def self.up
    create_table :performers do |t|
      t.string :company
      t.string :url
      t.text :description
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :performers
  end
end
