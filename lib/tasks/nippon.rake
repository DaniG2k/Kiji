namespace :scrape do
  desc "Scrape news from Nippon.com's website"
  task :nippon => :environment do
    regexes = [/(^.*nippon\.com.*)/]
    visited = fetch_rss_data("http://www.nippon.com/en/feed/", regexes)
    add_to_db(visited)
  end
end