class AddAdminUser < ActiveRecord::Migration
  def self.up
    User.create!( :email       => "admin@HollywoodFringe.org",
                  :first_name  => "fringe",
                  :last_name   => "admin",
                  :password    => "r1v2l3t45n",
                  :profile     => "the admin guy",
                  :is_admin    => 1
               )
  end

  def self.down
    User.delete( User.find_by_email("admin@HollywoodFringe.org") )
  end
end
