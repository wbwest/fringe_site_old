class Admin::EventManagerController < ApplicationController
    def index 
      @events = Event.find :all, :order=>:name      
    end
    
    def view
      @event = Event.find_by_id params[:id]
      @event_description = (RedCloth.new @event.description).to_html
      @performers = @event.performers
    end
    
    def new
      @event = Event.new(params[:event])
      if request.post? && @event.save!
        flash[:notice] = "Event Added"
        redirect_to :action => :index
      end
    end
    
    def edit
      @event = Event.find_by_id params[:id]
      if request.post? && @event.update_attributes(params[:event])
        flash[:notice] = "Event Updated"
        redirect_to :action => :index
      end
    end

    def delete
      Event.delete params[:id]
      flash[:notice] = "Event Deleted"
      redirect_to :action => :index
    end
    
    def select_performer
      @performers = Performer.find :all, :order => :company
      @event = Event.find_by_id params[:id]
      render :partial => "admin/event_manager/select_performer"
    end  
    
    def attach_performer
      @event = Event.find_by_id params[:event_id]
      performer = Performer.find_by_id params[:performer_id]
      performer.events << @event
      performer.save!
      render :partial => "admin/event_manager/event_performers"
    end
    
    def cancel_select
      @event = Event.find_by_id params[:event_id]
      render :partial => "admin/event_manager/event_performers"
    end
    
    def detach_performer
      @event = Event.find_by_id params[:event_id]
      performer = Performer.find params[:performer_id]
      @event.performers.delete(performer)
      @event.save!
      render :partial => "admin/event_manager/event_performers"
      
    end
end