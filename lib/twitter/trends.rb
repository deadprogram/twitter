module Twitter
  class Trends
    include HTTParty
<<<<<<< HEAD:lib/twitter/trends.rb
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
    
=======
    base_uri 'search.twitter.com/trends'
    format :json
    
    # :exclude => 'hashtags' to exclude hashtags
    def self.current(options={})
      mashup(get('/current.json', :query => options))
    end
    
    # :exclude => 'hashtags' to exclude hashtags
    # :date => yyyy-mm-dd for specific date
    def self.daily(options={})
      mashup(get('/daily.json', :query => options))
    end
    
    # :exclude => 'hashtags' to exclude hashtags
    # :date => yyyy-mm-dd for specific date
    def self.weekly(options={})
      mashup(get('/weekly.json', :query => options))
    end
    
    private
      def self.mashup(response)
        response['trends'].values.flatten.map { |t| Mash.new(t) }
      end
>>>>>>> 74f2160bc0a09d3363d79fd3d35a20f08e648a56:lib/twitter/trends.rb
  end
end