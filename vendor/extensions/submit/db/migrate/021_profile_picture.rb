class ProfilePicture < ActiveRecord::Migration
  def self.up
    rename_column :users, :profile_picture, :picture
  end

  def self.down
    rename_column :users, :picture, :profile_picture
  end
end
