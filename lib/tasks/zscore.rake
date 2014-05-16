desc "Compute the zscore for raw scores"
task :zscore => :environment do
  require 'statistics'
  puts "Computing zscore for"
  start_time = Time.zone.now
  sources = Article.pluck(:source).uniq
  sources.each do |src|
    articles = Article.where(:source => src)
    urls = articles.pluck(:url)
    x = articles.pluck(:raw_score)
    puts "\t#{src} (scoring #{x.size} elements)"
    
    # Check if there's not enough data to calculate zscore.
    # If there's a single raw score, lower default value and
    # place inside an array. Else, compute the zscore.
    zscores = x.one? ? [-3.0] : x.zscore
    zscores.each_with_index do |zscore, i|
      Article.find_by(:url => urls[i]).update(:val => zscore)
    end
  end
  end_time = Time.zone.now
  puts "Zscore time elapsed: #{end_time - start_time} seconds"
end