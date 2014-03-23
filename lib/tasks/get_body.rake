namespace :scrape do
  desc "Get article body"
  task :get_body => :environment do
    require 'json'
    # Needed for url escaping
    require 'erb'
    include ERB::Util
    
    # Get top ten articles
    today_range = Time.zone.now.beginning_of_day.utc..Time.zone.now.end_of_day.utc
    yesterday_range = 1.day.ago.beginning_of_day.utc..1.day.ago.end_of_day.utc
    today_articles = Article.where(:created_at => today_range)
    yesterday_articles = Article.where(:created_at => yesterday_range)
    today_articles = today_articles.empty? ? yesterday_articles.order('val DESC') : today_articles.order('val DESC')
    
    # Only get body content for urls that don't already have body data in our db
    urls = []
    if today_articles.present?
      while urls.size < 10
        art = today_articles.shift
        urls << url_encode(art.url) if art.body.nil?
      end
    end
    
    # Only make request if we have urls to process.
    if urls.present?
      # Compact in case there were fewer articles than the desired size,
      # in which case there would be nil values.
      urls = urls.compact.join(',')
      response = embedly_req(urls)
      add_bodies_to_db(response)
    end
  end
  
  def embedly_req(urls)
    # Make Embedly request
    # Embedly can process a max of 10 urls at a time with a batch request.
    key = YAML.load_file(Rails.root.join('config/secrets.yml'))['embedly_key']
    req = "http://api.embed.ly/1/extract?key=#{key}&urls=#{urls}&maxwidth=10&maxheight=10&format=json"
    JSON.parse(open(req).read)
  end
  
  def add_bodies_to_db(response)
    puts "Processing:"
    response.each do |article|
      puts "\tTitle: #{article['title']}"
      sanitized_body = ActionView::Base.full_sanitizer.sanitize(article['content'])
      puts "\tBody sanitized. Adding to db.\n"
      Article.find_by(url: article['original_url']).update(body: sanitized_body)
    end
  end
end