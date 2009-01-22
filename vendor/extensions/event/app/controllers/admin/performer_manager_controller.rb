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
end
