class AddTweetsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :tweets, :integer
  end
end
