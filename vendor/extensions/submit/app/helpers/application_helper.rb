module ApplicationHelper

  def set_focus(id)
    javascript_tag("$('#{id}').focus()")
  end

  def title(page_title)
    content_for(:title){ " - " + page_title.downcase }
  end

  def nice_date(date)
    date.strftime("%B %d %Y")
  end

  def nice_time(datetime)
    h datetime.strftime("%H:%M %p")
  end

  def try(method)
     send method if respond_to? method
  end
  
  def block_me (title=nil, manage_link = nil, width = "", height = "")
    opening = "<div class='block_thin' style='width:" + width + "'>"
    if title 
      opening = opening + "<div class='block_title'>"
      opening = opening +   "<span style='float:right;padding-top:5px'>" + manage_link +  "</a></span>" if manage_link
      opening = opening +   "<h3>" + title.to_s + "</h3>"
      opening = opening + "</div>"
    end
    opening = opening + "<div class='block_body' style='height:" + height + "'>"
    concat(opening, proc.binding)
    yield
    closing = "</div></div>"
    concat(closing, proc.binding)
  end
    
end
