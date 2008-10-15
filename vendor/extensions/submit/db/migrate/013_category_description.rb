class CategoryDescription < ActiveRecord::Migration
  def self.up
    add_column :cats, :description, :text
    change_column :projects, :description, :text
    execute "insert cats (name, description) VALUES ('new play', 'a new play festival')"
  end

  def self.down
    remove_column :projects, :category_description
  end
end
