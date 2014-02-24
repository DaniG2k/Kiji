namespace :scrape do
  desc "Take a screenshot of top three articles"
  task :screeny => :environment do
    @dir = File.join(Rails.root, 'app', 'assets', 'images', 'screenshots')
    rm_screenshots
    get_screenshots
  end
  
  def rm_screenshots
    puts 'Removing old screenshots'
    `rm ./app/assets/images/screenshots/*.png`
  end
  
  def get_screenshots
    today_range = Time.zone.now.beginning_of_day.utc..Time.zone.now.end_of_day.utc
    yesterday_range = 1.day.ago.beginning_of_day.utc..1.day.ago.end_of_day.utc
    today_articles = Article.where(:created_at => today_range).order('val DESC')
    yesterday_articles = Article.where(:created_at => yesterday_range).order('val DESC')
    articles = today_articles.empty? ? yesterday_articles.limit(3) : today_articles.limit(3)

    puts 'Getting new screenshots'
    articles.each do |article|
      `webkit2png\
      --clipped \
      --scale 0.69 \
      --clipwidth 700.0 \
      --clipheight 500.0 \
      --dir ./app/assets/images/screenshots \
      #{article.url}`
      sleep 3
    end
  end  
end