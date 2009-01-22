module PerformerTags
  include Radiant::Taggable

  tag 'performers' do |tag|
    tag.expand
  end

  tag 'performers:each' do |tag|
    result = []
    i=1
    performers = Performer.find(:all, :conditions => { :headliner => 0 }, :order => 'company ASC')
    performers.each do |performer|      
      tag.locals.performer = performer
      result << tag.expand 
      result << "&nbsp;&#149;" unless i==performers.length 
      i=i+1
    end
    result
  end

  tag 'performers:each:performer' do |tag|
    result = ""
    performer = tag.locals.performer
    %{<a href="/performer/view/#{performer.id}" company="#{performer.company}">#{performer.company}</a>}
  end
  
  tag 'headliners' do |tag|
    tag.expand
  end
  
  tag 'headliners:each' do |tag|
    result = []
    i=1
    headliners = Performer.find(:all, :conditions => { :headliner => 1 }, :order => 'company ASC')
    headliners.each do |performer|
      tag.locals.performer = performer
      result << tag.expand
      result << "&nbsp;&#149;" unless i==headliners.length
      i=i+1
    end
    result
  end
  
  tag 'headliners:each:headliner' do |tag|
    performer = tag.locals.performer
    %{<a href="/performer/view/#{performer.id}" company="#{performer.company}">#{performer.company}</a> }
  end
  
end