module ProjectHelper
  def format_comment_datetime(dt)
    # comment.date_posted.strftime("%l:%M%p on %B %d, %Y") 
    s = dt.strftime("%l:%M%p ").swapcase
    t = Time.new
    if dt.day == t.day
      return s+"today"
    end
    day = t.day
    t = t - 3600 until t.day!=day
    if t.day==dt.day
      return s+"yesterday"
    end
    s = s + dt.strftime("%B %d")
    case dt.day
      when 1, 21, 31 then s = s + "st"
      when 2, 22     then s = s + "nd"
      when 3, 23     then s = s + "rd"
      else                s = s + "th"
    end
    s = s + dt.strftime(", %Y")
  end#format_comment_datetime
end
