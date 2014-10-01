namespace :scrape do
  desc "Scrape news from Chosun Ilbo's website"
  task :chosun => :environment do
    worker = Kiji::Worker.new(
      :rss => "http://english.chosun.com/site/data/rss/rss.xml",
      :regexes => [/(^.*chosun\.com.*html)/])
    worker.fetch_rss_data
    worker.add_to_db
  end
end