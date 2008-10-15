class Vote < ActiveRecord::Base
  set_primary_keys  :project_id, :user_id
  belongs_to        :project
  belongs_to        :user
end
