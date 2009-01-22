class Admin::PerformerManagerController < ApplicationController
  def index
    @performers = Performer.find :all, :order=>:company
  end
  
  def new
    @performer = Performer.new(params[:performer])
    if request.post? && @performer.save!
      flash[:notice] = "Performer Added"
      redirect_to :action => :index
    end
  end
  
  def edit
    @performer = Performer.find_by_id params[:id]
    if request.post? && @performer.update_attributes(params[:performer])
      flash[:notice] = "Performer Updated"
      redirect_to :action => :index
    end
  end
  
  def delete
    Performer.delete params[:id]
    flash[:notice] = "Performer Deleted"
    redirect_to :action => :index
  end
  
  def select
    @performers = Performer.find :all, :order => :company
    @event = Event.find_by_id params[:id]
  end
  
  def attach_performer
    event = Event.find_by_id params[:event_id]
    performer = Performer.find_by_id params[:performer_id]
    performer.event = event
    performer.save!
    redirect_to :controller=>"event_manager", :action=>"view", :id=>event.id
  end
  
end
