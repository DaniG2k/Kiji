namespace :scrape do
  desc "Get article body"
  task :get_body => :environment do
    require 'json'
    # Needed for url encoding
    require 'erb'
    include ERB::Util
    
    # Only get body content for urls that don't already have body data
    # and limit to 10 for this API call.
    urls = Article.order('created_at DESC, val DESC')
                  .where("body IS NULL")
                  .limit(10)
                  .collect {|a| url_encode(a.url)}
                  .join ','
    
    # Only make request if we have urls to process.
    if urls.present?
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
      unless article['content'].nil? && article['original_url'].nil?
        puts "\tTitle: #{article['title']}"
        puts "\tSanitizing body"
        sanitized_body = ActionView::Base.full_sanitizer.sanitize(article['content'])
        puts "\tStripping unwanted characters"
        sanitized_body = sanitized_body.gsub(/\.\n/,'. ').gsub(/\n/, '')
        puts "\tAdding to db\n"
        Article.find_by(url: article['original_url']).update(body: sanitized_body)
      end
    end
  rescue NoMethodError => e
    puts "There was an error in adding the article body to db."
    p e.message
    p e.backtrace
    puts "\nContinuing..."
  end
end