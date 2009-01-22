module EventTags
  include Radiant::Taggable

  tag 'events' do |tag|
    tag.expand
  end

  tag 'events:each' do |tag|
    result = []
    i=1
    events = Event.find(:all, :order => 'name ASC')
    events.each do |event|
      tag.locals.event = event
      result << tag.expand
      result << "&nbsp;&#149;" unless i==events.length
      i = i+1
    end
    result
  end

  tag 'events:each:event' do |tag|
    event = tag.locals.event
    %{<a href="/event/view/#{event.id}" company="#{event.name}">#{event.name}</a>}
  end
    
end