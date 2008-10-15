class Video < Activeyoutube
  self.site = "http://gdata.youtube.com/feeds/api"
  
  ## To search by categories and tags
  def self.search_by_tags (*options)
    from_urls = []
    if options.last.is_a? Hash
      excludes = options.slice!(options.length-1)
      if excludes[:exclude].kind_of? Array
        from_urls << excludes[:exclude].map{|keyword| "-"+keyword}.join("/")
      else
        from_urls << "-"+excludes[:exclude]
      end
    end
    from_urls << options.find_all{|keyword| keyword =~ /^[a-z]/}.join("/")
    from_urls << options.find_all{|category| category =~ /^[A-Z]/}.join("%7C")
    from_urls.delete_if {|x| x.empty?}
    self.find(:all,:from=>"/feeds/api/videos/-/"+from_urls.reverse.join("/"))
  end
  
  def thumbnail_url
    self.group.attributes["thumbnail"][0].attributes["url"] rescue nil
  end
    
  def real_id
    Video.get_id(id)
  end  
  
  def self.get_id(url)
    url.match("([^/]*)$")[0]
  end  
end