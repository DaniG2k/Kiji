class Article < ActiveRecord::Base
  self.per_page = 50
  
  def self.search(query)
    query.downcase!
    where("lower(title) LIKE ? OR lower(source) LIKE ?", "%#{query}%", "%#{query}%")
  end
end
