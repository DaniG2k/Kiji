#!/usr/bin/ruby
module Kiji
  class Socializer
    attr_accessor :tw_url, :fb_urls
    def initialize(params={})
      @tw_url = params.fetch(:tw_url, '')
      @fb_urls = params.fetch(:fb_urls, [])
    end
    
    def get_tweets
      begin
        twreq = URI.escape "http://urls.api.twitter.com/1/urls/count.json?url=#{@tw_url}"
        tweets = JSON.parse(open(twreq).read)['count']
        puts "\tTweets: #{tweets}"
        tweets
      rescue
        puts "Error occurred at get_tweets method."
        puts "Twitter request: #{twreq}"
      end
    end
    
    def get_likes
      begin
        puts "Getting Facebook likes"
        q = "select url, total_count from link_stat where url in ('#{@fb_urls.join("','")}')"
        fbreq = URI.escape "https://graph.facebook.com/fql?q=#{q}"
        likes = JSON.parse(open(fbreq).read)
        likes['data']
      rescue
        puts "Error occurred at get_likes method."
      end
    end
  end # end Socializer
end # end Kiji module