# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class EventExtension < Radiant::Extension
  version ".2"
  description "manage fringe events"
  url "www.hollywoodfringe.org"
  
  define_routes do |map|
    map.with_options(:controller => 'admin/performer_manager') do |link|
      map.connect ':controller/:action/:id.:format'
    end
  end
  
  def activate
    admin.tabs.add "Performers", "/admin/performer_manager", :before => "Layouts" 
    admin.tabs.add "Events", "/admin/event_manager", :before => "Layouts" 
    Page.send :include, PerformerTags
    Page.send :include, EventTags
  end
  
  def deactivate
    # admin.tabs.remove "Performers"
  end
  
end