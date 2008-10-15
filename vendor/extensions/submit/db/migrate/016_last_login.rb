class LastLogin < ActiveRecord::Migration
  def self.up
    add_column :users, :last_login, :datetime
    execute "update users set last_login='2008-01-1 00:00:00'"
  end

  def self.down
    remove_column :users, :last_login
  end
end
