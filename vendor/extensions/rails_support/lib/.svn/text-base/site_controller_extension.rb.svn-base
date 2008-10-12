# ---------------------------------------------------------------------------------
# Copyright 2007 Hiram Chirino
# 
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.
# ---------------------------------------------------------------------------------
# Author: <a href="http://hiramchirino.com">Hiram Chirino</a>
module SiteControllerExtension
private  
  module RailsPageExtension    
    public
    attr_accessor :rails_parts
  
    def part(name)
      name = name.to_s
      if rails_parts[name]
        part = PagePart.new 
        part.content = rails_parts[name]
        return part
      else
        if new_record? or parts.to_a.any?(&:new_record?)
          parts.to_a.find {|p| p.name == name.to_s }
        else
          parts.find_by_name name.to_s
        end
      end
    end
        
  end

  def rails_parts
    if @rails_parts
      @rails_parts
    else
      @rails_parts = {}
    end
  end
  
  def radiant_render(options = {}, &block)
    layout = options[:layout]
    if layout == false 
      logger.info "doing render without layout"
      render(options, block)         
    else
      layout = "" unless layout
      logger.info "doing render without layout #{layout}"
      @page = Page.find_by_url(layout, live?)
      if !@page || @page.instance_of?(FileNotFoundPage)
        raise(ActionController::MissingTemplate, "Missing Radiant Page: #{layout}")
      else
        @page.extend RailsPageExtension
        options[:layout] = false
        rails_parts["body"] = render_to_string(options, &block)
        @page.rails_parts = rails_parts
        @page.process(request, response)
        @performed_render = true
        if @page.rails_parts["error"] 
          log_error  @page.rails_parts["error"]
        end
      end
    end
  end
  
end