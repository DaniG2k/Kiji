namespace :scrape do
  desc "Scrape news from Japan Times' website"
  task :japantimes => :environment do
    regexes = [/(^.*)\?/]
    visited = fetch_rss_data "http://feeds.feedburner.com/japantimes_news", regexes
    add_to_db(visited)
  end
end