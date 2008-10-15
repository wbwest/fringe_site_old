class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
    	t.column :user_id,      :integer
    	t.column :title,        :string
    	t.column :description,  :string
    end
    
    execute "alter table projects add constraint fk_orders_users foreign key (user_id) references users(id)"
  end

  def self.down
    drop_table :projects
  end
end
