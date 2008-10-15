class LogsTable < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.column :project_id, :int
      t.column :description, :string
      t.column :created_at, :datetime
    end
    execute "alter table logs add constraint fk_logs_projects foreign key (project_id) references projects(id)"
  end

  def self.down
    drop_table :logs
  end
end
