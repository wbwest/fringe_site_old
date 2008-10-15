class ApplicationController < ActionController::Base
  session :session_key => '_Fringe_session_id'
  
  private
  
  def authorize
    unless User.find_by_id(session[:user_id])
      redirect("Please log in")
    end
  end

  def check_admin
    msg = "Please log in with an administrator account too access this resource"
    begin  
      redirect(msg) unless User.find_by_id(session[:user_id]).is_admin
    rescue 
      redirect(msg)
    end
  end

  def redirect(msg)
    session[:original_url] = request.request_uri  
    flash[:notice] = msg 
    redirect_to(:controller => "profile", :action => "login")
  end
  
  def log_me(project_id, description)
    project = Project.find_by_id project_id
    log = Log.new
    log.project_id = project_id
    log.description = description
    log.save! if project.published?
  end
  
  def build_host
    host = "http://" + request.host 
    host = host + ":" + request.port.to_s if request.port!=80 
    return host
  end
  
end
