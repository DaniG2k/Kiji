class Article < ActiveRecord::Base
  self.per_page = 50

  searchable do
    text :title, :body
  end
end
