class AddYoutubeVideos < ActiveRecord::Migration
  def self.up
    add_column :projects, :youtube_videos, :text
    execute "update projects set youtube_videos = '[]'"
  end

  def self.down
    remove_column :projects, :youtube_videos
  end
end
