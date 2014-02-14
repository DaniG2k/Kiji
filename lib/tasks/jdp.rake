namespace :scrape do
  desc "Scrape news from Japan Daily Press' website"
  task :jdp => :environment do
    regexes = [/(^.*japandailypress.com.*)/]
    visited = fetch_rss_data("http://japandailypress.com/feed", regexes)
    add_to_db(visited)
  end
end