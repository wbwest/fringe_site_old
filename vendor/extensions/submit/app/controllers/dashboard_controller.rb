class DashboardController < ApplicationController
  
  layout "master"
  
  def index
    @latest_projects = Project.find(:all, 
     :order => "created_at DESC",
     :limit => 10,
     :conditions => {:published => true})
    @ranked_projects = Project.find(:all, :conditions=>{:published=>true}).sort_by{|v| v.votes.size}.reverse.paginate :page => params[:page], :per_page => 10      
    @user = User.find_by_id session[:user_id].to_i if session[:user_id]
    
  end
  
  def search
    if request.post? && params[:search_terms].length > 0
      redirect_to :action => :search_results, :search_terms => params[:search_terms] 
    end
  end
  
  def search_results
    users = User.find_by_contents params[:search_terms]
    projects = Project.find_by_contents( params[:search_terms], {}, :conditions => ["published=?", 1])
    #result =  Article.find_by_content('ruby', {}, 'visible = 1'
    
    @all_results = users | projects
    @result_count = @all_results.length
    @filtered_results = @all_results.sort_by{ |result| result.created_at }.reverse.paginate :page => params[:page], :per_page => 10
  end
  
  def toggle_news_filter    
    @user = User.find_by_id params[:id]
    @user.toggle :filter_news
    @user.save!
    render :partial => "feed"
  end

end
