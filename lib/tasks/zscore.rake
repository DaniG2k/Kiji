desc "Compute the zscore for raw values in rank colum"
task :zscore => :environment do
  require 'statistics'
  puts "Computing zscore for"
  sources = Article.select(:source).group(:source)
  sources.each do |article_obj|
    src = article_obj.source
    articles = Article.where(:source => src)
    puts "\t#{src}"
    urls = articles.pluck(:url)
    x = articles.pluck(:rank)
    
    z = x.zscore
    
    z.each_with_index do |z_elt, i|
      a = Article.find_by(:url => urls[i])
      a.val = z_elt
      a.save
    end
  end
end