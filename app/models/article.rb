class Article < ActiveRecord::Base
	validates_presence_of :title, :url, :source, :body
	
  self.per_page = 50

  searchable do
    text :title, :body
  end
end
