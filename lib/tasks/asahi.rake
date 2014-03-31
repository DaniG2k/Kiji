namespace :scrape do
  desc "Scrape news from Asahi Shimbun's English website"
  task :asahi => :environment do
    regexes = [/(^.*asahi\.com.*)/]
    visited = fetch_rss_data("http://ajw.asahi.com/feed/", regexes)
    add_to_db(visited)
  end
end