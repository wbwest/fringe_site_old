ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.raise_delivery_errors = false
ActionMailer::Base.smtp_settings = {
  :address  => "smtp.revworks.biz",
  :port  => 25, 
  :domain  => "HollywoodFringe.org",
  :user_name  => "smtp",
  :password  => "monkey",
  :authentication  => :login
}