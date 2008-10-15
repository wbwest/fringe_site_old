class Log < ActiveRecord::Base
  validates_confirmation_of :project_id
  validates_confirmation_of :description  
end
