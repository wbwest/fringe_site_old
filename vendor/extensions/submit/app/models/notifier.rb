class Notifier < ActionMailer::Base
  INFO = "Hollywood Fringe Festival<info@hollywoodfringe.org>"
  def user_signup(user)
    recipients user.email
    from    INFO
    subject "thanks for joining fringe"
    body :user => user
  end
  
  def project_create(user_id, project_url)
    user = User.find_by_id(user_id)
    recipients user.email
    from    INFO
    subject "your project has been created"
    body :user => user, :project_url => project_url
  end
  
  def project_supported_owner(project_id, voter_id, voter_url)
    voter = User.find_by_id(voter_id)
    project = Project.find(project_id)
    recipients project.user.email
    from    INFO
    subject "your project has a new supporter"
    body :project => project, :voter => voter, :voter_url => voter_url
  end

  def project_supported_voter(project_id, voter_id, project_url)
    voter = User.find_by_id(voter_id)
    project = Project.find(project_id)
    recipients voter.email
    from    INFO
    subject "you now support a fringe project" 
    body :project => project, :voter => voter, :project_url => project_url
  end
  
  def forgot_password(user, new_password, login_url)
    recipients user.email
    from    INFO
    subject "Your New Password"
    body :user => user, :new_password => new_password, :login_url => login_url
  end

  def comment_added(project_id, project_url)
    project = Project.find_by_id(project_id)
    recipients project.user.email
    from    INFO
    subject "New Project Comment"
    body :user => project.user, :project => project, :project_url => project_url
  end#comment added
end
