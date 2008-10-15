class User < ActiveRecord::Base
  has_many :projects, :conditions=>{:published=>true}
  has_many :drafts, :class_name=>"Project", :conditions=>{:published=>false}
  has_many :votes
  has_many :project_comments
  has_many :voted_projects, :through => :votes, :source => :project

  attr_accessor :password_confirmation
  
  validates_confirmation_of :password  
  validates_presence_of   :email, :first_name, :last_name 
  validates_uniqueness_of :email
  validates_format_of	:email,
    :with => %r{\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b}i,
    :message => "address invalid"
				
  #acts_as_ferret :remote => true
    
  def full_name
    self.first_name + " " + self.last_name
  end
	
  def validate 
    errors.add_to_base("Missing Password") if hashed_password.blank?
  end
  	
  def password
    @password
  end
	
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end
    
  def self.authenticate(email, password)
    user=self.find_by_email(email)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end

  def formatted_profile
    rc = RedCloth.new profile
    rc.to_html
  end
	
  private
	
  def self.encrypted_password(password, salt)
    string_to_hash = password + "monkey" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end
	
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
		
end