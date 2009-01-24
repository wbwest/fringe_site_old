# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class EventExtension < Radiant::Extension
  version ".2"
  description "manage fringe events"
  url "www.hollywoodfringe.org"
  
  define_routes do |map|
    map.connect 'admin/events/:action', :controller => 'admin/event_manager'
    map.connect 'admin/performers/:action', :controller => 'admin/performer_manager'
  end
  
  def activate
    admin.tabs.add "Performers", "/admin/performers", :before => "Layouts" 
    admin.tabs.add "Events", "/admin/events", :before => "Layouts" 
    Page.send :include, PerformerTags
    Page.send :include, EventTags
  end
  
  def deactivate
    # admin.tabs.remove "Performers"
  end
  
end