class Admin::EventManagerController < ApplicationController
    def index 
      @events = Event.find :all, :order=>:name      
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
    
end