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
                :guardian_all]
  
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
    feed.entries.each do |entry|
      begin
        next unless entry.published.today?
        url = get_matching_url(entry, regexes)
        puts "Querying #{url}"
        visited[url] = {}
        visited[url][:source] = format_source(feed.title)
        visited[url][:title] = entry.title
        visited[url][:likes] = get_likes(url)
        visited[url][:tweets] = get_tweets(url)
      rescue NoMethodError
        puts "\nNo matchdata found for #{entry.url}"
        #unvisited << entry.url
        next
      end
    end
    sleep 5 # Give Twitter and Facebook a break! :D
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
  
  def get_likes(url)
    begin
      q = "select total_count from link_stat where url='#{url}'"
      fbreq = URI.escape("https://api.facebook.com/method/fql.query?query=#{q}&format=json")
      #puts "\nFacebook query: #{fbreq}"
      JSON.parse(open(fbreq).read).first['total_count']
    rescue
      puts "Error occurred at get_likes"
      puts "Twitter request: #{fbreq}"
    end
  end
  
  def get_tweets(url)
    begin
      twreq = URI.escape("http://urls.api.twitter.com/1/urls/count.json?url=#{url}")
      #puts "\nTwitter query: #{twreq}"
      JSON.parse(open(twreq).read)['count']
    rescue
      puts "Error occurred at get_tweets"
      puts "Twitter request: #{twreq}"
    end
  end
  
  def add_to_db(visited)
    puts "Adding data to the database"
    visited.each do |key, val|
      #puts "#{key} #{val}"
      article = Article.find_or_initialize_by(:url => key)
      article.update(
        source: val[:source],
        title: val[:title],
        likes: val[:likes],
        tweets: val[:tweets],
        rank: val[:likes] + val[:tweets])
      article.save
    end
  end
end