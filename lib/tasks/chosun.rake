namespace :scrape do
  desc "Scrape news from Chosun Ilbo's website"
  task :chosun => :environment do
    regexes = [/(^.*chosun\.com.*html)/]
    visited = fetch_rss_data("http://english.chosun.com/site/data/rss/rss.xml", regexes)
    add_to_db(visited)
  end
end