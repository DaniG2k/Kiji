namespace :scrape do
  
  desc "Run all scrape tasks"
  task :all => [:asahi,
                :bbc,
                :chosun,
                :cnn,
                :economist,
                :guardian,
                :jdp,
                :japantimes,
                :japantoday,
                #:newschina,
                :nippon,
                :nyt,
                :tokyoreporter]
                #:wsj]
end