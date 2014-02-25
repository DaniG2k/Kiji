namespace :scrape do
  
  desc "Run all Guardian scrape tasks"
  task :wsj_all => [:wsj_asia, :wsj_china, :wsj_hk]
  
  r = [/(^.*wsj\.com.*)\?/]
  
  desc "Scrape news from Wall Street Journal, Asia section"
  task :wsj_asia => :environment do
    regexes = r
    visited = fetch_rss_data "http://online.wsj.com/xml/rss/3_7480.xml", regexes
    add_to_db visited
  end
  
  desc "Scrape news from Wall Street Journal, China section"
  task :wsj_china => :environment do
    regexes = r
    visited = fetch_rss_data "http://online.wsj.com/xml/rss/3_7441.xml", regexes
    add_to_db visited
  end
  
  desc "Scrape news from Wall Street Journal, Hong Kong section"
  task :wsj_hk => :environment do
    regexes = r
    visited = fetch_rss_data "http://online.wsj.com/xml/rss/3_8070.xml", regexes
    add_to_db visited
  end
end