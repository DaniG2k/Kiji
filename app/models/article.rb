class Article < ActiveRecord::Base
  self.per_page = 50
  
  def self.search(query)
    where("title LIKE ? OR source LIKE ?", "%#{query}%", "%#{query}%")
  end
end
