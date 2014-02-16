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
    
    screenshot_dir = File.join(Rails.root, 'app', 'assets', 'images', 'screenshots')
    #path = File.join(Rails.root, 'app', 'assets', 'images', 'screenshots')
    #Capybara.save_and_open_page_path = path
    puts 'Removing old screenshots'
    (0..2).each do |n|
      img = "#{screenshot_dir}/screenshot-#{n}.png"
      File.delete(img) if File.exist?(img)
    end
        
    puts 'Getting new screenshots'
    articles = Article.order('val DESC').limit(3)
    
    articles.each_with_index do |article, i|
      visit(article.url)
      save_screenshot(File.join(screenshot_dir, "screenshot-#{i}.png"))
    end
  end
end