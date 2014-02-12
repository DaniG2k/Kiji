namespace :scrape do
  
  desc "Run all Guardian scrape tasks"
  task :guardian_all => [:guardian_asia, :guardian_china, :guardian_japan]
  
  desc "Scrape news from The Guardian's Asia section"
  task :guardian_asia => :environment do
    regexes = [/(^http.*)/]
    visited = fetch_rss_data "http://www.theguardian.com/world/asiapacific/roundup/rss", regexes
    add_to_db visited
  end
  
  desc "Scrape news from The Guardian's China section"
  task :guardian_china => :environment do
    regexes = [/(^http.*)/]
    visited = fetch_rss_data "http://feeds.theguardian.com/theguardian/world/china/rss", regexes
    add_to_db visited
  end
  
  desc "Scrape news from The Guardian's Japan section"
  task :guardian_japan => :environment do
    regexes = [/(^http.*)/]
    visited = fetch_rss_data "http://feeds.theguardian.com/theguardian/world/china/rss", regexes
    add_to_db visited
  end
end