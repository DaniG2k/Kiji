desc "Compute the zscore for raw scores"
task :zscore => :environment do
  require 'statistics'
  puts "Computing zscore for"
  sources = Article.pluck(:source).uniq
  sources.each do |src|
    articles = Article.where(:source => src)
    puts "\t#{src}"
    urls = articles.pluck(:url)
    x = articles.pluck(:raw_score)
    
    # Check if there's not enough data to calculate zscore.
    # If there's a single raw score, lower default value and
    # place inside an array. Else, compute the zscore.
    zscores = x.length == 1 ? [-3.0] : x.zscore
    zscores.each_with_index do |zscore, i|
      a = Article.find_by(:url => urls[i])
      a.val = zscore
      a.save
    end
  end
end