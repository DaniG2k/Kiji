namespace :scrape do
  namespace :economist do
    
    desc "Run all Economist scrape tasks"
    task :all => [:ecn_asia, :ecn_china, :ecn_analects]
    r = /(^.*economist\.com.*)\?.*$/
    
    desc "Scrape news from Economist Asia's website"
    task :ecn_asia => :environment do
      regexes = [r]
      visited = fetch_rss_data("http://www.economist.com/rss/asia_rss.xml", regexes)
      add_to_db(visited)
    end
    
    desc "Scrape news from Economist China's website"
    task :ecn_china => :environment do
      regexes = [r]
      visited = fetch_rss_data("http://www.economist.com/rss/china_rss.xml", regexes)
      add_to_db(visited)
    end
    
    desc "Scrape news from Economist Analects' website"
    task :ecn_analects => :environment do
      regexes = [r]
      visited = fetch_rss_data("http://www.economist.com/blogs/analects/index.xml", regexes)
      add_to_db(visited)
    end
  end
end