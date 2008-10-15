class Image 
  
  @@save_path = ""
  @@file_name = "profile_picture.jpg"
  @@thumbnail_name = "profile_picture_thumb.jpg"
  @@upload_path = ""
  @@user_id = -1
  @@image = nil
  
  def initialize user_id
    @@user_id = user_id
  end
  
  def upload(upload_path)
    @@upload_path = upload_path
    upload_image
    @@image = get_image_object
    check_filesize 
    resize
    make_thumbnail
    @@save_path[14,100] + @@file_name
  end
  
  private 
  
  def make_thumbnail
    @@thumbnail = @@image.change_geometry!('70x70>') { |cols, rows, img|
     img.resize!(cols, rows)
     }
    @@thumbnail.write @@save_path + @@thumbnail_name
  end
  
  def upload_image
    @@save_path = "public/images/users/" + @@user_id.to_s + "/"
    FileUtils.mkdir_p(@@save_path)
    file = File.new(@@save_path + @@file_name, "wb")
    file.write @@upload_path.read
    file.close
  end
  
  def get_image_object
    begin
      image = Magick::Image::read(@@save_path + @@file_name).first
    rescue
      delete
      raise "bad file type"
    end      
  end
  
  def check_filesize
    if @@image.filesize > 1000000
      delete
      raise "file too big" 
    end
  end
  
  def resize
    @@image = @@image.change_geometry!('150x150>') { |cols, rows, img|
     img.resize!(cols, rows)
     }
    @@image.write @@save_path + @@file_name
  end
  
  def delete
    begin
      File.delete(@@save_path + @@file_name)
    rescue
    end
  end
  
end
