module Twitter
  class Search
    include HTTParty
    include Enumerable
    
    headers 'Accept' => 'text/json'
    
    attr_reader :result, :query
    
    def initialize(q=nil, o={})
      clear
      @user_agent = o[:user_agent] ? o[:user_agent] : "Twitter Ruby Gem"
      containing(q) if q && q.strip != ''
    end
    
    def from(user)
      @query[:q] << "from:#{user}"
      self
    end
    
    def to(user)
      @query[:q] << "to:#{user}"
      self
    end
    
    def referencing(user)
      @query[:q] << "@#{user}"
      self
    end
    alias :references :referencing
    alias :ref :referencing
    
    def containing(word)
      @query[:q] << "#{word}"
      self
    end
    alias :contains :containing
    
    # adds filtering based on hash tag ie: #twitter
    def hashed(tag)
      @query[:q] << "##{tag}"
      self
    end
    
    # lang must be ISO 639-1 code ie: en, fr, de, ja, etc.
    #
    # when I tried en it limited my results a lot and took 
    # out several tweets that were english so i'd avoid 
    # this unless you really want it
    def lang(lang)
      @query[:lang] = lang
      self
    end
    
    # Limits the number of results per page
    def per_page(num)
      @query[:rpp] = num
      self
    end
    
    # Which page of results to fetch
    def page(num)
      @query[:page] = num
      self
    end
    
    # Only searches tweets since a given id. 
    # Recommended to use this when possible.
    def since(since_id)
      @query[:since_id] = since_id
      self
    end
    
    # Search tweets by longitude, latitude and a given range.
    # Ranges like 25km and 50mi work.
    def geocode(long, lat, range)
      @query[:geocode] = [long, lat, range].join(',')
      self
    end
    
    def max(id)
      @query[:max_id] = id
      self
    end
    
    # Clears all the query filters to make a new search
    def clear
      @fetch = nil
      @query = {}
      @query[:q] = []
      self
    end
    
    def fetch(force=false)
      if @fetch.nil? || force
        query = @query.dup
        query[:q] = query[:q].join(' ')
        response = self.class.get('http://search.twitter.com/search.json', {:query => query, :format => :json, :headers => {'user-agent' => @user_agent}})
        @fetch = Mash.new(response)
      end
      
      @fetch
    end
    
    def each
      fetch()['results'].each { |r| yield r }
    end
    
    def user_agent(agent=nil)
      if agent.nil?
        @user_agent
      else
        @user_agent = agent
        self
      end
    end
  end
end