class RenameRankToRawscore < ActiveRecord::Migration
  def change
    rename_column :articles, :rank, :raw_score
  end
end
