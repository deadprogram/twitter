require File.dirname(__FILE__) + '/../test_helper'

class TrendsTest < Test::Unit::TestCase
  context "fetching" do
    setup do
      stub_get('http://search.twitter.com:80/trends.json', 'trends.json')
      @trends = Twitter::Trends.new
      @response = @trends.fetch
    end
  
    should "should return results" do
      @response.trends.size.should == 10
    end
  
    should "should be able to iterate over results" do
      @trends.respond_to?(:each).should be(true)
    end
  
  end
  
end