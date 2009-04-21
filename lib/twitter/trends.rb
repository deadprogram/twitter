module Twitter
  class Trends
    include HTTParty
    include Enumerable
    
    attr_reader :result
    
    def fetch
      response = self.class.get('http://search.twitter.com/trends.json', :format => :json)
      @fetch = Mash.new(response)
      @fetch
    end
    
    def each
      fetch()['trends'].each { |r| yield r }
    end
    
  end
end