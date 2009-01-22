class AddPerfEventConnector < ActiveRecord::Migration
  def self.up
    create_table "events_performers", :id => false do |t|
      t.column "event_id", :integer, :null => false
      t.column "performer_id",  :integer, :null => false
    end
    remove_column :performers, :event_id
  end
  
  def self.down
    drop_table "events_performers"
  end
end