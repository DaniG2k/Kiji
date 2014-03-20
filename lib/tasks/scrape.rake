namespace :scrape do
  #require 'mechanize'
  require 'json'
  require 'open-uri'
  require 'feedjira'
  
  desc "Run all scrape tasks"
  task :all => [:bbc,
                :chosun,
                :cnn,
                :economist,
                :guardian,
                :jdp,
                :jt,
                :nippon,
                :nyt,
                :tokyoreporter,               
                :wsj]
  
  # Gather RSS feed and run FQL and Twitter queries on those urls
  # Returns a visited hash
  # { 'url' => {
  #  :likes => '',
  #  :title => '',
  #  :source => '',
  #  :tweets => ''}
  # }
  def fetch_rss_data(rss, regexes)
    feed = Feedjira::Feed.fetch_and_parse(rss)
    visited = {}
    #unvisited = []
    
    # We need this for a batch request to Facebook
    urls = Array.new
    
    feed.entries.each do |entry|
      begin
        if entry.published.nil?
          puts "There is no published data for this feed entry.\nSkipping..."
          next
        end
        next unless entry.published.today?
        url = get_matching_url(entry, regexes)
        puts "Querying #{url}"
        visited[url] = {}
        visited[url][:source] = format_source(feed.title)
        visited[url][:title] = entry.title
        visited[url][:tweets] = get_tweets(url)
        urls << url
      rescue NoMethodError
        puts "\nNo matchdata found for #{entry.url}"
        #unvisited << entry.url
        next
      end
    end
    
    # Process Facebook likes in batch only if we have
    # a list of urls.
    if urls.present?
      likes = get_likes(urls)
      likes.each {|fb| visited["#{fb['url']}"][:likes] = fb['total_count']}
    end
    # Return the visited hash
    visited
  end
  
  def format_source(src)
    src.strip!
    case src.downcase
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
    when /nippon\.com/
      "Nippon.com"
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
  
  def get_matching_url(entry, regexes)
    # This method is needed because a Regexp match will contain nil results
    # if there is more than one regexp in the passed in array.
    # Ignore the first entry (full url), compact nil results and return the match.
    matches = entry.url.match(Regexp.union(regexes)).to_a
    matches[1..-1].compact.shift
  end
  
  def get_likes(urls)
    begin
      puts "Getting Facebook likes"
      urls_str = urls.join("','")
      q = "select url, total_count from link_stat where url in ('#{urls_str}')"
      fbreq = URI.escape("https://graph.facebook.com/fql?q=#{q}")
      likes = JSON.parse(open(fbreq).read)
      likes['data']
    rescue
      puts "Error occurred at get_likes method."
    end
  end
  
  def get_tweets(url)
    begin
      twreq = URI.escape("http://urls.api.twitter.com/1/urls/count.json?url=#{url}")
      #puts "\nTwitter query: #{twreq}"
      tweets = JSON.parse(open(twreq).read)['count']
      puts "\tTweets: #{tweets}"
      tweets
    rescue
      puts "Error occurred at get_tweets method."
      puts "Twitter request: #{twreq}"
    end
  end
  
  def add_to_db(visited)
    # Only add to database if links were visited.
    if visited.present?
      puts "Adding data to the database"
      visited.each do |key, val|
        #puts "#{key}\n\t#{val}"
        article = Article.find_or_initialize_by(:url => key)
        article.update(
          source: val[:source],
          title: val[:title],
          likes: val[:likes],
          tweets: val[:tweets],
          raw_score: val[:likes] + val[:tweets])
        article.save
      end
    end
  end
end