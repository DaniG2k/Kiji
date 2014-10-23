module Kiji
  class Worker
    # TODO
    # - Build a worker that goes through all articles to assemble data
    # - Add percentage indicator to update process
    attr_accessor :rss, :regexes
    def initialize(params={})
      @rss = params.fetch :rss, ''
      @regexes = params.fetch :regexes, []
    end
    
    def fetch_rss_data
      failure_callback = lambda do |curl, err|
        # Remove the lock file.
        Kiji::Locker.new.unlock
        # Email failure message.
        RakeMailer.failed_rake_task(method: "fetch_rss_data", rss: @rss, curl: curl, error: err).deliver
      end
      feed = Feedjira::Feed.fetch_and_parse(@rss, on_failure: failure_callback)
      @visited = Hash.new
      socializer = Kiji::Socializer.new()
      
      feed.entries.each do |entry|
        begin
          if entry.published.nil?
            puts "There is no published data for this feed entry.\nSkipping..."
            next
          end
          next unless entry.published.today?
          
          url = get_matching_url(entry)
          
          socializer.tw_url = url
          socializer.fb_urls << url
          
          puts "Querying #{url}"
          @visited[url] = {}
          @visited[url][:source] = format_source(feed.title)
          @visited[url][:title] = entry.title.strip
          @visited[url][:tweets] = socializer.get_tweets
        rescue Exception => e
          puts e.message
          #puts "\nNo matchdata found for #{entry.url}"
          next
        end
      end # end feed.entries.each
      
      if socializer.fb_urls.present?
        # Process Facebook likes in batch.
        socializer.get_likes.each {|fb| @visited["#{fb['url']}"][:likes] = fb['total_count']}
      end
    end # end fetch_rss_data 
    
    def add_to_db
      # Only add to database if links were visited.
      if @visited.present?
        puts "Adding data to the database"
        @visited.each do |key, val|
          article = Article.find_or_initialize_by(:url => key)
          article.source = val[:source]
          article.title = val[:title]
          article.likes = val[:likes]
          article.tweets = val[:tweets]
          article.raw_score = (val[:likes] + val[:tweets]) 
          # Only perform this step if we haven't alrady scraped the body
          if article.body.nil?
            article.body = get_body(:url => key, :source => val[:source])
          end
          article.save
        end
      else
        puts "No visited hash present. You might want to run the fetch_rss_data method first."
      end
    end
    
    private
    def get_matching_url(entry)
      outliers = ['nytimes.com', 'bbc.co.uk']
      # This method is needed because a Regexp match will contain nil results
      # if there is more than one regexp in the passed in array.
      # Ignore the first entry (full url), compact nil results and return the match.
      entry = outliers.any? {|outlier| entry.url.include?(outlier)} ? entry.entry_id : entry.url
      entry.match(Regexp.union(@regexes))
      # $+ contains the last match from the previous successful pattern match.
      $+
    end
    
    def format_source(src)
      src.strip!
      case src.downcase
      when /asahi/
        "Asahi Shimbun"
      when /bbc/
        "BBC"
      when /chosun/
        "Chosun Ilbo"
      when /cnn/
        "CNN"
      when /economist|analects/
        "The Economist"
      when /guardian/
        "The Guardian"
      when /japan times/
        "The Japan Times"
      when /japan today/
        "Japan Today"
      when /nippon\.com/
        "Nippon.com"
      when /newschina/
        "NewsChina"
      when /nyt/
        "New York Times"
      when /tokyo reporter/
        "Tokyo Reporter"
      when /wsj/
        "WSJ"
      else
        src
      end
    end
    
    # Provide the page's url and an array of css accessors
    # The content will be either returned inside of an array
    # or nil if no results found.
    def get_body(params)
      url = params[:url]
      source = params[:source]
      page = Mechanize.new.get url
      body = Array.new
      cleaner = Kiji::Cleaner.new(:source => source)
      
      puts "\nGetting body for #{url}:"

      cleaner.get_source_selectors.each do |selector|
        if page.search(selector).any?
          body = page.search(selector)
          break
        end
      end

      if body.any?
        cleaner.page = body
        # Attempt to remove unwanted nodes and spaces
        # before returning.
        body = cleaner.clean_article_body
        puts "\n#{body}"
        # Let's be polite :)
        sleep 5
        # Return this value last.
        body.join(' ')
      else
        # Otherwise return nil, so we can query the DB for
        # null body entries.
        nil
      end
    rescue Exception => e
      RakeMailer.failed_rake_task(:method => "get_body", :url => url, :error => e).deliver
      puts "An exception occurred while attempting to get an article's body :("
      puts "\tUrl: #{url}"
      puts "\tSource: #{source}"
      puts "\t#{e}"
    end
    
  end # end Worker
end # end Kiji module