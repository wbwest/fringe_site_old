class CatsTimestamps < ActiveRecord::Migration
  def self.up
    remove_column :cats, :create_on
    add_column :cats, :created_at, :string
    add_column :cats, :updated_at, :string
  end

  def self.down
    add_column :cats, :create_on, :string
    remove_column :cats, :created_at
    remove_column :cats, :updated_at
  end
end
