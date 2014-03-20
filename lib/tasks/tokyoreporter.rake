namespace :scrape do
  desc "Scrape news from Tokyo Reporter's website"
  task :tokyoreporter => :environment do
    regexes = [/(^https?:\/\/www\.tokyoreporter\.com.*)/]
    visited = fetch_rss_data("http://feeds.feedburner.com/TheTokyoReporter", regexes)
    add_to_db(visited)
  end
end