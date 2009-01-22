class AddHeadliners < ActiveRecord::Migration
  def self.up
    add_column :performers, :headliner, :boolean
  end

  def self.down
    remove_column :performers, :headliner
  end
end
