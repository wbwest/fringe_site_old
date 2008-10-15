class ProjectController < ApplicationController

  before_filter :authorize, :only => [:edit, :add_project, :assign_category]
  layout "master", :except => [:add_comment,:delete_comment,:paginate] 

  COMMENTS_PER_PAGE = 10

  def add_project
    @project = Project.new(params[:project])
    @project.user_id = session[:user_id]    
    if request.post? && @project.save
      Notifier.deliver_project_create(@project.user_id, get_project_url(@project.id))
      flash[:notice] = "Project Created"      
      vote = Vote.new
      vote.user_id    = @project.user_id
      vote.project_id = @project.id
      vote.save!
      redirect_to :controller => :project, :action => :assign_category, :id => @project
    end
  end
  
  def add_comment
    @comment             = ProjectComment.new();
    @comment.project_id  = params[:project_id];
    @comment.user_id     = session[:user_id];
    @comment.comment     = params[:text];
    @comment.date_posted = Time.new();
    if request.post? && @comment.save
      project = Project.find_by_id params[:project_id]
      user    = User.find_by_id session[:user_id]
      log_me params[:project_id],
             "was commented on by <a href='/profile/view/" + 
             session[:user_id].to_s + "'>" + user.full_name + "</a>"
      Notifier.deliver_comment_added(params[:project_id], 
                                     get_project_url(params[:project_id]) + 
                                     "#comment_" + @comment.id.to_s)
      render :partial => "comment_list_contents", :locals => {:project => project}
    end
  end
  
  def delete_comment
    project = Project.find_by_id(params[:project_id])
    ProjectComment.delete(params[:id])
    render :partial => "comment_list_contents", :locals => {:project => project}
  end

  def paginate
    pageNumber = params[:pageNumber]
    pageNumber = 1 unless pageNumber
    pageNumber = pageNumber.to_i
    render  :partial => "comment_list_contents",
            :locals  => {:project    => Project.find_by_id(params[:project_id]),
                         :pageNumber => pageNumber}
  end
  
  def view
    session[:original_url] = nil
    @project    = Project.find_by_id(params[:id])
    @owner      = @project.user
    @all_voters = @project.voters[0..7]
    @history = Log.find(:all, :conditions => ["project_id = ?", @project.id], :limit => 5, :order => "created_at DESC")
  end
  
  def edit
    @project = Project.find_by_id(params[:id])
    @current_user = User.find_by_id(session[:user_id])
    @original_url = session[:original_url]
    @categories = Cat.all
    redirect_to(:controller => :project, :action => :view, :id => @project.id) if @project.user != @current_user && !@current_user.is_admin
    if request.post? and @project.update_attributes(params[:project])
      flash[:notice] = "Project Updated"
      session[:original_url] = nil;      
      redirect_to @original_url || {:action => "view", :id => @project.id }
      log_me @project.id, "updated its information"
    end
  end
  
  def list
    @projects = Project.paginate :page => params[:page], :order => :title, :per_page => 15
  end
  
  def vote
    if(params[:redirect])
      session[:project_to_vote] = params[:project_id]
      redirect_to :controller => :profile, :action => :login

    else
      project = Project.find_by_id(params[:project_id])
      vote = Vote.new
      vote.user_id    = params[:voter_id]
      vote.project_id = params[:project_id]
      
      begin
        vote.save!
        vote_log_message params[:project_id],params[:voter_id]
        flash[:notice] = "project supported"
        Notifier.deliver_project_supported_owner(params[:project_id], vote.user_id, get_profile_url(vote.user_id))
        Notifier.deliver_project_supported_voter(params[:project_id], vote.user_id, get_project_url(params[:project_id]))    
      rescue Exception
      end
      
      if(session[:project_to_vote])
        session[:project_to_vote] = nil
        redirect_to :action => :view, :id => project
      else
        render :partial => "support_project", :voter_id => params[:user_id], :owner_id => project.user.id, :project_id => project.id
      end
      
    end
  end
  
  def vote_log_message project_id, voter_id
    voter = User.find_by_id voter_id
    message = "is now supported by <a href='"  
    message = message + build_host + "/profile/view/" + voter_id + "'>" 
    message = message + voter.full_name + "</a>"
    log_me project_id, message
  end
  
  def unvote
    project = Project.find_by_id(params[:project_id])
    @voter = User.find_by_id(params[:voter_id])
    @voter.votes.each { |vote| vote.destroy if vote.project_id.to_s == params[:project_id] }  
    flash[:notice] = "you have removed your support"
    render :partial => "support_project", :voter_id => params[:user_id], :owner_id => project.user, :project_id => project
  end

  def delete
    @original_url = session[:original_url]
    session[:original_url] = nil
    Project.delete(params[:id])
    flash[:notice] = "project deleted"
    redirect_to(@original_url || {:action => "index"})    
  end

  def assign_category
    @categories = Cat.all    
    if request.post?
      project = Project.find(params[:id])
      project.cat_id = params[:categories]    
      project.save!
      redirect_to :action => :view, :id => project
    end
  end

  def get_cat_description
    begin
      category = Cat.find(params[:category])
      html = category.formatted_description;
      html = html + "<input class='submit' name='commit' type='submit' value='Accept Rules' />"
      html = html + " for " + category.name
      render :text => html
    rescue ActiveRecord::RecordNotFound
      render :text => ""
    end
  end

  def view_category
    @category = Cat.find(params[:id])
    @projects = Project.find(:all, :conditions=>{:cat_id=>params[:id]}).paginate :page => params[:page], :per_page => 20
  end
  
  def manage_videos
    @project = Project.find_by_id params[:id]
    if request.post?
      redirect_to :action => :add_video, :id => params[:id], :criteria => params[:search_videos]
    end
  end

  def add_video
    if params[:criteria] != ""
      @raw_results = Video.find(:all, :params => {:vq => params[:criteria]})[0]
      begin
        @total_results = @raw_results.entry.length
        @results = @raw_results.entry
      rescue Exception
        @total_results = @raw_results.totalResults
        @results = Array.new        
        @results[0] = @raw_results.entry if @total_results.to_i > 0
      end
    end
    
  end
  
  def attach_video
    project = Project.find_by_id(params[:id])
    begin
      project.youtube_videos.push(params[:youtube_id])
    rescue Exception
      project.youtube_videos = Array.new
      project.youtube_videos.push(params[:youtube_id])
    end
    project.save!
    created_attach_video_log params[:youtube_id], params[:id]
    flash[:notice] = "Video added to your project"
    redirect_to :action => :manage_videos, :id => params[:id]
  end
  
  def created_attach_video_log video_id, project_id
    message = "added a <a href='" + build_host
    message = message + "/project/view_video/" + video_id + "?project_id=" +  project_id
    message = message + "'>video</a>"
    log_me project_id, message 
  end
  
  def remove_video
    project = Project.find_by_id(params[:id])
    project.youtube_videos.delete(params[:youtube_id])
    project.save!
    flash[:notice] = "Video Removed"
    redirect_to :action => :manage_videos, :id => params[:id]
  end

  def publish 
    project = Project.find_by_id params[:id]
    project.published = true
    project.save!
    flash[:notice] = "project published"
    log_me project.id, "was added as a fringe project"
    redirect_to :action => :view, :id => params[:id] 
  end
  
  def suspend
    project = Project.find_by_id params[:id]
    project.published = false
    project.save!
    Log.delete_all "project_id=#{params[:id]}"
    flash[:notice] = "project suspended"
    redirect_to :action => :view, :id => params[:id] 
  end

  private 
  
  def get_project_url(id)
    url = build_host    
    url = url + "/project/view/" + id.to_s
  end

  def get_profile_url(id)
    url = "http://" + request.host 
    url = url + ":" + request.port.to_s if request.port!=80 
    url = url + "/profile/view/" + id.to_s
  end

end
