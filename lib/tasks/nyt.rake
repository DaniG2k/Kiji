namespace :scrape do
  desc "Scrape news from New York Times' website"
  task :nyt => :environment do
    regexes = [/(^.*world\/asia.*\.html)/, /(^.*)\?/]
    visited = fetch_rss_data("http://www.nytimes.com/services/xml/rss/nyt/AsiaPacific.xml", regexes)
    add_to_db(visited)
  end
end