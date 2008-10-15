class ProjectPublished < ActiveRecord::Migration
  def self.up
    add_column :projects, :published, :boolean, :default=>false
  end

  def self.down
    remove_column :projects, :published
  end
end
