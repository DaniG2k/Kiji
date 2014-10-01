namespace :scrape do
  
  desc "Run all scrape tasks"
  task :all => [:create_lock,
                :asahi,
                :bbc,
                :chosun,
                :cnn,
                :economist,
                :guardian,
                :japantimes,
                :japantoday,
                :jdp,
                #:newschina,
                :nippon,
                :nyt,
                :tokyoreporter,
                #:wsj,
                :zscore,
                :clear_lock]
end