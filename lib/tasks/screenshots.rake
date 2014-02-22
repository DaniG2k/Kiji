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
    
    @dir = File.join(Rails.root, 'app', 'assets', 'images', 'screenshots')
    #path = File.join(Rails.root, 'app', 'assets', 'images', 'screenshots')
    #Capybara.save_and_open_page_path = path
    
    rm_screenshots
    
    #Keep trying to get the screenshots until they're all there.
    #Back off on each iteration.
    delay = (0..30).map {|i| 1.8*i}
    iteration = 1
    until all_exist?
      rm_screenshots
      get_screenshots
      sleep delay.shift.minutes if delay.present?
      unless iteration == 1
        puts 'Not all screenshots gathered. Restarting...'
      end
      iteration += 1
    end
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
  
  def all_exist?
    (0..2).all? {|n| File.exist?("#{@dir}/screenshot-#{n}.png")}
  end
  
end