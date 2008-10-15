class Cat < ActiveRecord::Base
  has_one :project
  validates_presence_of :name
  
  def formatted_description
    rc = RedCloth.new self.description
    rc.to_html
  end
  
end
