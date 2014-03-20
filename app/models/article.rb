class Article < ActiveRecord::Base
  self.per_page = 50
  
  def self.search(query)
    q = query.downcase
    where("lower(title) LIKE ? OR lower(source) LIKE ?", "%#{q}%", "%#{q}%")
  end
end
