class RenameScoreCol < ActiveRecord::Migration
  def change
    rename_column :articles, :zscore, :val
  end
end
