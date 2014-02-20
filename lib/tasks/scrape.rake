namespace :scrape do
  #require 'mechanize'
  require 'json'
  require 'open-uri'
  require 'feedzirra'
  
  desc "Run all scrape tasks"
  task :all => [:bbc,
                :nyt,
                :jt,
                :jdp,
                :chosun,
                :guardian_all,
                'south_china_mp:all']
  
  # Gather RSS feed and run FQL and Twitter queries on those urls
  # Returns a visited hash
  # { 'url' => {
  #  :likes => '',
  #  :title => '',
  #  :source => '',
  #  :tweets => ''}
  # }
  def fetch_rss_data(rss, regexes)
    feed = Feedzirra::Feed.fetch_and_parse(rss)
    visited = {}
    #unvisited = []
    
    # We need this for a batch request to Facebook
    urls = Array.new
    
    feed.entries.each do |entry|
      begin
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
    
    # Process Facebook likes in batch
    likes = get_likes(urls)
    likes['data'].each do |fb|
      url = fb['url']
      visited[url][:likes] = fb['total_count']
    end
    
    visited
  end
  
  def format_source(src)
    case src.downcase.strip
    when "nyt > asia pacific"
      "New York Times - Asia Pacific"
    when "the japan times: news & business"
      "The Japan Times"
    when "world news : asia pacific roundup | theguardian.com"
      "The Guardian - Asia Pacific"
    when "world news: china | theguardian.com"
      "The Guardian - China"
    when "asia feed"
      "South China Morning Post - Asia"
    when "hong kong feed"
      "South China Morning Post - HK"
    when "china feed"
      "South China Morning Post"
    when "cnn.com - asia"
      "CNN - Asia"
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
      urls_str = urls.join("','")
      q = "select url, total_count from link_stat where url in ('#{urls_str}')"
      fbreq = URI.escape("https://graph.facebook.com/fql?q=#{q}")
      likes = JSON.parse(open(fbreq).read)
      likes
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
        #puts "#{key} #{val}"
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