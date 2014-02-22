namespace :scrape do
  desc "Take a screenshot of top three articles"
  task :screenshots => :environment do
    require 'capybara'
    require 'capybara/poltergeist'
    include Capybara::DSL
    Capybara.default_driver = :poltergeist
    Capybara.run_server = false
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app,
        :js_errors => false,
        :timeout => 250,
        :debug => true)
    end
    
    @dir = File.join(Rails.root, 'app', 'assets', 'images', 'screenshots')
    #path = File.join(Rails.root, 'app', 'assets', 'images', 'screenshots')
    #Capybara.save_and_open_page_path = path 
    rm_screenshots
    get_screenshots
  end
  
  def rm_screenshots
    puts 'Removing old screenshots'
    (0..2).each do |n|
      img = "#{@dir}/screenshot-#{n}.png"
      File.delete(img) if File.exist?(img)
    end
  end
  
  def get_screenshots
    puts 'Getting new screenshots'
    articles = Article.order('val DESC').limit(3)
    
    articles.each_with_index do |article, i|
      visit(article.url)
      save_screenshot(File.join(@dir, "screenshot-#{i}.png"))
      sleep 5
    end
  end  
end