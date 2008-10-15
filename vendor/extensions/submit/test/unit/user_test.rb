require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users

  def test_invalid_with_empty_attributes
    user = User.new
    assert !user.valid?
  end
  
  def test_create_bad_email
    user = User.new(:email      =>  "BenHillgmail.com",
                    :first_name =>  "Ben",
                    :last_name  =>  "Hill",
                    :profile    =>  "My name is Ben",
                    :password   =>  "secret")
               
     assert !user.valid?    
     assert user.errors.invalid?(:email);     
  end
  
  def test_create_no_first_name
    user = User.new(:email      =>  "BenHill@gmail.com",
                    :last_name  =>  "Hill",
                    :profile    =>  "My name is Ben",
                    :password   =>  "secret")
    
    assert !user.valid?
    assert user.errors.invalid?(:first_name)
  end
  
  def test_duplicate_email
    user = User.new(:email      =>  "BenJohnson@gmail.com",
                    :first_name =>  "Ben",
                    :last_name  =>  "Hill",
                    :profile    =>  "My name is Ben",
                    :password   =>  "secret")
	              
    assert !user.valid?
    assert user.errors.invalid?(:email);     
  end
  
  def test_login
  	user = User.authenticate("BenJohnson@gmail.com", "secret");
  	assert_equal(user.first_name, "Ben")
  end
end
