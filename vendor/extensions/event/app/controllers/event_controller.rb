class EventController < ApplicationController
  radiant_layout 'Normal'
  no_login_required
  
  def index
    @events = Event.find :all, :order => :name
  end
  
  def view
    @event = Event.find_by_id params[:id]
    rc = RedCloth.new @event.description
    @event_description = rc.to_html
  end
end