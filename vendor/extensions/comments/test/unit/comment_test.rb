require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < Test::Unit::TestCase
  def test_valid_comment
    comment = Comment.new do |c| 
      c.author = "Foo Bar"
      c.author_email = "foo@bar.com"
      c.author_url = "http://www.test.com/"
      c.content = "This is a comment"
    end
    
    assert_valid comment
    
    comment.save
    
    comment_stored = Comment.find_by_author("Foo Bar")
    
    assert_not_nil(comment)
    assert_equal(comment.author, comment_stored.author)
    assert_equal(comment.author_email, comment_stored.author_email)
    assert_equal(comment.author_url, comment_stored.author_url)
    assert_equal(comment.content, comment_stored.content)
  end
  
  def test_download_csv_routes
    assert_routing "admin/comments/all",
      {:controller => "admin/comments", :action => "index", :status => "all"}
    assert_routing "admin/comments/all.csv",
      {:controller => "admin/comments", :action => "index", :status => "all", :format => 'csv'}

    assert_routing "admin/pages/6/comments/all.csv",
      {:controller => "admin/comments", :action => "index", :status => "all", :format => 'csv', :page_id => "6"}
    assert_generates "admin/pages/6/comments/all.csv",
      {:controller => "admin/comments", :action => "index", :format => 'csv', :page_id => "6"}
  end
  
end
