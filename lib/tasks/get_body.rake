namespace :scrape do
  desc "Get article body"
  task :get_body => :environment do
    # We need this for url escaping
    require 'erb'
    include ERB::Util
    
    # Get top ten articles
    today_range = Time.zone.now.beginning_of_day.utc..Time.zone.now.end_of_day.utc
    yesterday_range = 1.day.ago.beginning_of_day.utc..1.day.ago.end_of_day.utc
    today_articles = Article.where(:created_at => today_range)
    yesterday_articles = Article.where(:created_at => yesterday_range)
    today_articles = today_articles.empty? ? yesterday_articles : today_articles
    
    top_ten_urls = today_articles.order('val DESC').limit(10).map {|article| url_encode(article.url)}.join(',')
    
    key = YAML.load_file(Rails.root.join('config/secrets.yml'))['embedly_key']
    # Make Embedly request
    # Embedly can process a max of 10 urls at a time with a batch request.
    embedly_req = "http://api.embed.ly/1/extract?key=#{key}&urls=#{top_ten_urls}&maxwidth=10&maxheight=10&format=json"
    # Parse content
    response = JSON.parse(open(embedly_req).read)
    
    response.each do |article|
      sanitized_body = ActionView::Base.full_sanitizer.sanitize(article['content'])
      Article.find_by(url: article['original_url']).update(body: sanitized_body)
    end
    
  end
end