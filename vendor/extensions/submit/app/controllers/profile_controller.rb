class ProfileController < ApplicationController

  before_filter :authorize, :only => [:edit]
  layout "master"
  
  def index
    redirect_to :action => :view, :id => session[:user_id]
  end

  def add_user
    session[:user_id] = nil
    @user = User.new(params[:user])
    @user.last_login = Time.now
    if request.post? and @user.save
      logger.info "Adding user " + @user.email
      flash[:notice] = "User #{@user.email} created"
      session[:user_id] = @user.id
      Notifier.deliver_user_signup(@user)
      @user = User.new            
      redirect_to(:action => :choose_picture, :id => session[:user_id])
    end
  end

  def login
    session[:user_id] = nil
    process_login if request.post?
  end
  
  def list
    @all_users = User.find :all
    @project = Project.find_by_id params[:id]
    @users = Array.new
    @all_users.each do |user|
      @users << user if user.voted_projects.include?(@project)
    end
    @users = @users.paginate :page => params[:page], :order => :last_name, :per_page => 16
  end

  def forgot_password
    if request.post?
      @new_password = generate_password(5)
      begin
        @user = User.find(:first, :conditions => ["email=?", params[:email]] )
        @user.password = @new_password
        @user.change_password = true;
        @user.save!
        Notifier.deliver_forgot_password(@user, @new_password, get_login_url) 
        flash[:notice] = "A new password has been emailed to you"  
      rescue
        flash[:error] = "Sorry, we can't seem to find that email"
      end
      redirect_to :action => :login
    end
  end
  
  def close_welcome_message 
    user = User.find_by_id(params[:id])
    user.new_user = false;
    user.save!
  end
  
  def change_password
    #work needed: move security check to filter, more validation to model
    @user = User.find_by_id(params[:id])
    redirect_to(:controller => :profile) if @user.id != session[:user_id]  && !User.find_by_id(session[:user_id]).is_admin    
    if request.post? 
      if params[:password] == ""
        flash[:error] = "your passwords cannot be blank"       
      elsif params[:password] != params[:password_confirmation]
        flash[:error] = "your passwords do not match"   
      else
        @user.password = params[:password]
        @user.save!
        redirect_to :controller => :dashboard, :action => :index  
      end
    end
  end

  def logout
  	session[:user_id] = nil
  	redirect_to(:action => "login")
  end

  def view
    session[:original_url]    =  nil
    @current_user    =  User.find_by_id(params[:id])
    current_id       =  params[:id] || @current_user.id
    @profile_user    =  User.find_by_id(current_id)
    @active_projects =  @profile_user.projects.sort_by{|a| a.title.downcase}
    @draft_projects  =  @profile_user.drafts
    @voted_projects  =  @profile_user.voted_projects 
  end
  
  def edit 
    @user = User.find_by_id(params[:id])
    redirect_to(:controller => :profile) if @user.id != session[:user_id]  && !User.find_by_id(session[:user_id]).is_admin    
    @original_url = session[:original_url]
    if request.post? and @user.update_attributes(params[:user])
      flash[:notice] = "Your profile has been updated"
      session[:original_url] = nil
      redirect_to(@original_url || {:action => :view, :id => @user})
    end
  end

  def delete
    @original_url = session[:original_url]
    session[:original_url] = nil
    User.delete(params[:id])
    flash[:notice] = "user deleted"
    redirect_to(@original_url || {:action => "index"})
  end

  def choose_picture
    @freak_pictures = Dir.glob("public/images/freaks/*").delete_if{|freak| freak.include? "thumb"}
  end
  
  def upload_image
    @user = User.find_by_id(params[:id])
    if request.post?
      begin
        image = Image.new @user.id
        @user.picture = image.upload params[:picture]
        @user.save!
      rescue
        flash[:error] = "there was an error uploading your image"
      end
      redirect_to :action => :view, :id => params[:id] 
    end
  end 
  
  def create_freak_thumbs
    freak_pictures = Dir.glob("public/images/freaks/*")
    freak_pictures.each do |freak|
      image = Magick::Image::read(freak).first
      thumbnail = image.change_geometry!('70x70>') { |cols, rows, img|
       img.resize!(cols, rows)
       }
      thumbnail.write freak[0,freak.length-4] + "_thumb.jpg"
    end
  end
  
  def associate_image
    user = User.find_by_id(params[:id])
    user.picture = params[:picture]
    user.save!
    redirect_to :action => :view, :id =>  params[:id]
  end

  private

  def generate_password(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

  def get_login_url
    url = "http://" + request.host 
    url = url + ":" + request.port.to_s if request.port!=80 
    url = url + "/profile/login"
  end

  def process_login
    user = User.authenticate(params[:email], params[:password])
    if user
      user.last_login = Time.now
      user.save!
      session[:user_id] = user.id
      if user.change_password?          
        user.change_password = false
        user.save!
        redirect_to :action => :change_password, :id => user.id
      elsif session[:project_to_vote]
        project = Project.find_by_id(session[:project_to_vote])
        redirect_to :controller => :project, :action => :vote, :project_id => project.id, :voter_id => user
      else
        redirect_to :controller => :dashboard, :action => :index
      end
    else
      flash.now[:notice] = "Invalid email/password combination"
    end
  end

end