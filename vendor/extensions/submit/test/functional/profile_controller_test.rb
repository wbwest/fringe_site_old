require File.dirname(__FILE__) + '/../test_helper'
require 'profile_controller'

# Re-raise errors caught by the controller.
class ProfileController; def rescue_action(e) raise e end; end

class ProfileControllerTest < Test::Unit::TestCase

  fixtures :users

  def setup
    @controller = ProfileController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_add_user
    get:add_user
    assert_response :success
    
    post :add_user, :user => {:email => "benhill@gmail.com", :first_name => "Ben", :last_name => "Hill", :password => "secret", :password_confirmation => "secret", :profile => "I am Ben"}
    assert_not_nil session[:user_id]    
    assert_redirected_to :action => :index    
  end
  
  def test_add_bad_user
    post :add_user, :user => {:email => "benhillgmail.com", :first_name => "Ben", :last_name => "Hill", :password => "secret", :password_confirmation => "secret2", :profile => "I am Ben"}    
    assert_response(200)
  end
  
  def test_login
    user = users(:user_1)
    post :login, :email => user.email, :password => "secret"
    assert_redirected_to :action => "index"
    assert_equal user.id, session[:user_id]
  end
  
  def test_bad_login
    user = users(:user_1)
    post :login, :email => user.email, :password => "wrong!"
    assert_template "profile/login"
    assert_equal nil, session[:user_id]
  end
  
  def test_unauthenticated_access    
    get :index
    assert_redirected_to :action => 'login'
    assert_equal "Please log in", flash[:notice] 
  end
end