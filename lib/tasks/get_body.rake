namespace :scrape do
  desc "Get article body"
  task :get_body => :environment do
    require 'json'
    # Needed for url encoding
    require 'erb'
    include ERB::Util
    
    # Only get body content for urls that don't already have body data
    # and limit to 10 for this API call.
    urls = get_n_bodyless_articles(10).collect {|article| url_encode(article.url)}.join(',')
    
    # Only make request if we have urls to process.
    if urls.present?
      response = embedly_req(urls)
      add_bodies_to_db(response)
    end
  end
  
  def get_n_bodyless_articles(n)
    today_range = Time.zone.now.beginning_of_day.utc..Time.zone.now.end_of_day.utc
    yesterday_range = 1.day.ago.beginning_of_day.utc..1.day.ago.end_of_day.utc
    articles = Article.where(:created_at => today_range)
    yesterday_articles = Article.where(:created_at => yesterday_range)
    
    articles = articles.empty? ? yesterday_articles : articles
    
    if articles.count < n
      # Last resort. Return an array of any 10 bodyless articles.
      Article.where("body IS NULL").limit(n)
    else
      articles.where('body IS NULL').order('val DESC').limit(n)
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
      if !article['content'].nil? && !article['original_url'].nil?
        puts "\tTitle: #{article['title']}"
        puts "\tSanitizing body"
        sanitized_body = ActionView::Base.full_sanitizer.sanitize(article['content'])
        puts "\tStripping unwanted characters"
        sanitized_body = sanitized_body.strip.gsub(/\.\n/,'. ').gsub(/\n/, '')
        puts "\tAdding to db\n"
        Article.find_by(url: article['original_url']).update(body: sanitized_body)
      end
    end
  end
end