require File.dirname(__FILE__) + '/../spec_helper'

describe Performers do
  before(:each) do
    @performers = Performers.new
  end

  it "should be valid" do
    @performers.should be_valid
  end
end
