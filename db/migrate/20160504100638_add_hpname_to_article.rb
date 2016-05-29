class AddHpnameToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :hpname, :string
  end
end
