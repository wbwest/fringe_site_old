class FilterNews < ActiveRecord::Migration
  def self.up
    add_column :users, :filter_news, :bool, :default=>false
  end

  def self.down
    remove_column :users, :filter_news
  end
end
