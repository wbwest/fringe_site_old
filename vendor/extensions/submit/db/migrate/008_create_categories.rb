class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :cats do |t|
      t.column :name, :string
      t.column :create_on, :string
    end
  end

  def self.down
    drop_table :cats
  end
end
