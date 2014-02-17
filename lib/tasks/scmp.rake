namespace :scrape do
  namespace :south_china_mp do
    desc "Run all South China Morning Post scrape tasks"
    task :all => [:asia, :china, :hong_kong]
    
    desc "Scrape news from South China Morning Post - Hong Kong"
    task :hong_kong => :environment do
      regexes = [/(^.*scmp.com.*hong-kong.*$)/]
      visited = fetch_rss_data("http://www.scmp.com/rss/2/feed", regexes)
      add_to_db(visited)
    end

    desc "Scrape news from South China Morning Post - Asia"
    task :asia => :environment do
      regexes = [/(^.*scmp.com.*asia.*$)/]
      visited = fetch_rss_data("http://www.scmp.com/rss/3/feed", regexes)
      add_to_db(visited)
    end
    
    desc "Scrape news from South China Morning Post - China"
    task :china => :environment do
      regexes = [/(^.*scmp.com.*china.*$)/]
      visited = fetch_rss_data("http://www.scmp.com/rss/4/feed", regexes)
      add_to_db(visited)
    end
  end
end