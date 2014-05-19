namespace :scrape do
  desc "Scrape news from NewsChina Magazine's website"
  task :newschina => :environment do
    regexes = [/(^.*newschinamag.com.*$)/]
    visited = fetch_rss_data("http://www.newschinamag.com/rss/magazine_rss", regexes)
    add_to_db(visited)
  end
end