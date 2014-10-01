namespace :scrape do
  desc "Compute the zscore for raw scores"
  task :zscore => :environment do
    require 'statistics'
    puts "Computing zscore for"
    start_time = Time.zone.now
    
    begin
      sources = Article.pluck(:source).uniq
      sources.each do |src|
        articles = Article.where(:source => src)
        urls = articles.pluck(:url)
        raw_scores = articles.pluck(:raw_score)
        puts "\t#{src} (scoring #{raw_scores.size} elements)"
        
        # Check if there's not enough data to calculate zscore.
        # If there's a single raw score, lower default value and
        # place inside an array. Else, compute the zscore.
        zscores = raw_scores.one? ? [-3.0] : raw_scores.zscore
        zscores.each_with_index do |zscore, i|
          Article.find_by(:url => urls[i]).update(:val => zscore)
        end
    end
    rescue Exception => e
      RakeMailer.failed_rake_task(method: "zscore", rss: nil, curl: nil, error: e).deliver
    end
    
    end_time = Time.zone.now
    puts "Zscore time elapsed: #{end_time - start_time} seconds"
  end
end