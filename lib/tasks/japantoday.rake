namespace :scrape do
  desc "Scrape news from JapanToday's website"
  task :japantoday => :environment do
    regexes = [/(^.*japantoday.*$)/]
    visited = fetch_rss_data "http://www.japantoday.com/feed", regexes
    add_to_db(visited)
  end
end