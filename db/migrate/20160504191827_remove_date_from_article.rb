class RemoveDateFromArticle < ActiveRecord::Migration
  def change
    remove_column :articles, :date, :time
  end
end
