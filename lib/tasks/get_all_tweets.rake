namespace :scrape do
  desc "Get all tweets for article urls"
  task :get_all_tweets => :environment do
    Article.find_in_batches(:batch_size => 100) do |group|
      socializer = Kiji::Socializer.new
      group.each do |article|
        # Set the Twitter url
        socializer.tw_url = article.url
        # Update the db
        article.update(:tweets => socializer.get_tweets)
      end
      sleep 60
    end
  end
end