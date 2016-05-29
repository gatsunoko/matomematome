class ArticleurlController < ApplicationController
# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'

	def article_model
		@tetugaku = Nokogiri::HTML.parse(url_set("http://blog.livedoor.jp/nwknews/"), nil, 'utf-8')

		@tetugaku.css('div.article-header').each do |doc|
			article_link(@tetugaku.title, 'div.article-title-outer > h2 > a', 'div.article-date-outer > abbr.updated', doc)
		end
	end

	def article_link(hpname, article, date, doc)
		@article = Article.new
		@article.hpname = hpname
		@article.title = doc.css(article).text
		@article.url = doc.css(article)[0][:href]
		@article.date = DateTime.parse(doc.css(date)[0][:title])

		@article.save
	end

	def url_set(url)
		charset = nil
		html = open(url) do |f|
			charset = f.charset # 文字種別を取得
			f.read # htmlを読み込んで変数htmlに渡す
		end
		return html
	end
end
