namespace :scrape do
  desc "Take a screenshot of top three articles"
  task :screenshots => :environment do
    require 'capybara'
    require 'capybara/poltergeist'
    include Capybara::DSL
    Capybara.default_driver = :poltergeist
    Capybara.run_server = false
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, :js_errors => false)
    end
    #path = File.join(Rails.root, 'app', 'assets', 'images', 'screenshots')
    #Capybara.save_and_open_page_path = path
    
    articles = Article.order('zscore DESC').limit(3)
    
    articles.each_with_index do |article, i|
      visit(article.url)
      save_screenshot(File.join(Rails.root, 'app', 'assets', 'images', 'screenshots', "screenshot-#{i}.png"))
    end
  end
end