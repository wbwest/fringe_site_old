class AdminController < ApplicationController
  
  layout "master"
  before_filter :check_admin

  def list_users
    @users = User.paginate :page => params[:page], :order => :last_name, :per_page => 23
    @last_logins = User.all.sort_by{|user| - user.last_login.to_i}[0,10]
    session[:original_url] = request.request_uri
  end

  def list_projects
    @projects = Project.all.sort_by{|a| a.title.downcase}
    session[:original_url] = request.request_uri
  end

  def add_category
    @category = Cat.new(params[:category])
    if request.post? and @category.save
      flash[:notice] = "Category Created"      
      redirect_to :action => :list_categories
    end
  end

  def edit_category
    @category = Cat.find_by_id(params[:id])
    if request.post? && @category.update_attributes(params[:category])
      flash[:notice] = "Category Updated"
      redirect_to :action => :list_categories
    end
  end

end
