class CreateProjectComment < ActiveRecord::Migration
  TABLE = :project_comments;
  def self.up
    create_table(TABLE) { |table|
        table.column :project_id,  :integer,   :null=>false
        table.column :user_id,     :integer,   :null=>false
        table.column :date_posted, :datetime,  :null=>false
        table.column :comment,     :text,      :null=>false 
    }#create_table
  end#self.up
  def self.down
    drop_table(TABLE);
  end#self.down
end
