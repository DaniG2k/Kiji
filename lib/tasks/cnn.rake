namespace :scrape do
  desc "Scrape news from CNN's website"
  task :cnn => :environment do
    regexes = [/(^.*cnn\.com.*$)/]
    visited = fetch_rss_data("http://rss.cnn.com/rss/edition_asia.rss", regexes)
    add_to_db(visited)
  end
end