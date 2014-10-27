module Kiji  
  class Cleaner
    attr_accessor :page, :source
    def initialize(params={})
      @page = params.fetch(:page, '')
      @source = params.fetch(:source, '')
    end
    
    # Returns the cleaned out page. This removes entire nodes
    # whereas clean_article_body cleans out the gathered article content.
    def remove_unwanted_nodes!
      # Search for and remove all unwanted nodes
      unwanted_nodes = {
        "WSJ"                       => ['span.article-chiclet'],
        "BBC"                       => ['p.media-message', 'p.date', 'p.disclaimer', 'div.comment-introduction', 'noscript'],
        "Japan Today"               => ['div#article_content p.article_smalltext'],
        "South China Morning Post"  => ['div.subtitle', 'div.subline-ticks', 'div.subscribe-wrapper']
      }
      # Only remove unwanted nodes if they're present in the hash.
      if unwanted_nodes[@source].present?
        unwanted_nodes[@source].each {|node| @page.search(node).remove}
      end
    end
    
    # Returns the cleaned out body as a string.
    def clean_article_body
      get_source_selectors.each do |selector|
        if @page.search(selector).present?
          @page = page.search(selector)
          break
        end
      end
      # Strip unwanted spaces and newlines.
      @page.collect {|elt| elt.content.strip.gsub(/\n|\r/, '').gsub(/\ +/, ' ')}.join(' ')
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
        ['div[itemprop="articleBody"] p', 'div.flexible-content-body p']
      when "The Japan Times"
        ['div#jtarticle p']
      when "The Japan Daily Press"
        ["div.post p"]
      when "Japan Today"
        ['div#article_content p']
      when "South China Morning Post"
        ['[property="content:encoded"] p']
      when "Tokyo Reporter"
        ["div.post p"]
      when "WSJ"
        ["div.articleBody p", "article.articleBody p"]
      else
        []
      end
    end
  end
end
