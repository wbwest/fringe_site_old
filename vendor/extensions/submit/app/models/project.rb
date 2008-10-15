class Project < ActiveRecord::Base

  belongs_to    :user
  has_many      :votes
  has_many      :voters,   :through => :votes, :source => :user
  has_many      :comments, :class_name=>"ProjectComment", :order => "date_posted DESC"
  belongs_to    :cat

  validates_presence_of :title, :description
  serialize :youtube_videos
  #acts_as_ferret :remote => true

  def is_supporter(user_id)
    @user = User.find_by_id user_id
    @user.voted_projects.find_by_id self.id
  end

  def formatted_description
    rc = RedCloth.new self.description
    rc.to_html
  end

end
