class PerformerController < ApplicationController
  radiant_layout 'Normal'
  no_login_required
  
  def index
    @performers = Performer.find :all, :order => :company
  end
  
  def view
    @performer = Performer.find_by_id params[:id]
    rc = RedCloth.new @performer.description
    @performer_description = rc.to_html
  end
  
end
