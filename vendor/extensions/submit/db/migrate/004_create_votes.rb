class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes, :primary_key => [:user_id, :project_id] do |t|
      t.column :user_id,    :integer, :null => false
      t.column :project_id, :integer, :null => false
    end

    execute  "alter table votes add constraint fk_votes_users 
             foreign key (user_id) references users(id)"

    execute  "alter table votes add constraint fk_votes_projects
             foreign key (project_id) references projects(id)
             on delete cascade"
  end

  def self.down
    drop_table :votes
  end
end
