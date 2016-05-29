class AddArticledateToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :articledate, :datetime
  end
end
