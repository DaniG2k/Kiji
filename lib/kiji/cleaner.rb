module Kiji
  require 'mechanize'
  
  class Cleaner
    attr_accessor :url, :source
    def initialize(params={})
      @url = params[:url]
      @source = params[:source]
    end
    
    # Provide the page's url and an array of css accessors
    # The content will be either returned inside of an array
    # or nil if no results found.
    def get_body
      page = Mechanize.new.get(@url)
      page = clean_page(page)
      @body = Array.new

      puts "\nGetting body for #{@url}:"

      get_source_selectors.each do |src|
        if page.search(src).any?
          @body = page.search(src)
          break
        end
      end

      if @body.any?
        # Attempt to remove unwanted nodes and spaces
        # before returning.
        @body = clean_article_body
        puts "\n#{@body}"
        sleep 5 # Let's be polite :)
        @body.join(' ')
      else
        # Otherwise return nil, so we can query the DB for
        # null body entries.
        nil
      end
    rescue Exception => e
      RakeMailer.failed_rake_task(:method => "get_body", :url => @url, :error => e).deliver
      puts "An exception occurred while attempting to get an article's body :("
      puts "\tUrl: #{@url}"
      puts "\tSource: #{@source}"
      puts "\t#{e}"
    end
  end
  
  private
  # An array of predefined slectors to use for getting the article's body.
  def get_source_selectors
    case @source
    when "Asahi Shimbun"
      ["div.body p"]
    when "BBC"
      ["div.story-body p", "div.map-body p"]
    when "CNN"
      ["div.cnn_strycntntlft p"]
    when "Chosun Ilbo"
      ["div.article p"]
    when "New York Times"
      ["p.story-content", "p.story-body-text"]
    when "Nippon.com"
      ["div#detail_contents"]
    #when "The Economist"
    when "The Guardian"
      ["div.article-body-blocks p"]
    when "The Japan Times"
      ['div#jtarticle p']
    when "The Japan Daily Press"
      ["div.post p"]
    when "Japan Today"
      ['div#article_content p']
    when "Tokyo Reporter"
      ["div.post p"]
    when "WSJ"
      ["div.articleBody p", "article.articleBody p"]
    else
      []
    end
  end
  
  # Returns the cleaned out page. This removes entire nodes
  # whereas clean_article_body cleans out the gathered article content.
  def clean_page(page)
    # Search for and remove all unwanted nodes
    unwanted_nodes = {
      "WSJ" => ["span.article-chiclet"],
      "BBC" => ["p.disclaimer", "div.comment-introduction", "noscript"],
      "Japan Today" => ['div#article_content p.article_smalltext']
      }
    # Only remove unwanted nodes if they're present in the hash.
    unless unwanted_nodes[@source].nil?
      unwanted_nodes[@source].each {|node| page.search(node).remove}
    end
    page
  end
  
  # Returns the cleaned out body as an array of paragraphs.
  def clean_article_body
    # Strip unwanted spaces and newlines.
    @body.collect {|elt| elt.content.strip.gsub(/\n|\r/, '').gsub(/\ +/, ' ')}
  end
end