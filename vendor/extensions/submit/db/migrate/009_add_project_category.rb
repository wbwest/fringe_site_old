class AddProjectCategory < ActiveRecord::Migration
  def self.up
    add_column :projects, :cat_id, :integer
    execute "alter table projects add constraint fk_projects_categories foreign key (cat_id) references cats(id)"
    execute "update projects set cat_id = 1"  
  end

  def self.down
    execute "alter table projects drop foreign key fk_projects_categories" 
    remove_column :projects, :cat_id
  end
end
