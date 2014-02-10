class AddZscoreToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :zscore, :decimal
  end
end
