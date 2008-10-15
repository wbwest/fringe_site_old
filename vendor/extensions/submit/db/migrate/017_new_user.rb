class NewUser < ActiveRecord::Migration
  def self.up
    add_column :users, :new_user, :bool, :default => true
  end

  def self.down
    remove_column :users, :new_user
  end
end
