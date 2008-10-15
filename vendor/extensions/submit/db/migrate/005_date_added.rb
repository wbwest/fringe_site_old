class DateAdded < ActiveRecord::Migration
  def self.up
    add_column :users,    :created_at, :datetime
    add_column :users,    :updated_at, :datetime
    add_column :users,    :is_admin,   :boolean
      
    add_column :projects, :created_at, :datetime
    add_column :projects, :updated_at, :datetime

    add_column :votes,    :created_at, :datetime 
  end

  def self.down
    remove_column :users,    :created_at
    remove_column :users,    :updated_at
    remove_column :users,    :is_admin  

    remove_column :projects, :created_at
    remove_column :projects, :updated_at

    remove_column :votes, :created_at
  end
end
