require 'clockwork'
# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'
#railsモデルにアクセスする為のライブラリ読込
require File.expand_path('../boot', __FILE__)
require File.expand_path('../environment', __FILE__)

	module Clockwork
		handler do |job|
			Article.transaction do
				Article.destroy_all

				#哲学ニュース
				tetugaku = Nokogiri::HTML.parse(url_set("http://blog.livedoor.jp/nwknews/"), nil, 'utf-8')
				tetugaku.css('div.article-header').each do |doc|
					article_link(tetugaku.title, 'div.article-title-outer > h2 > a', 'div.article-date-outer > abbr.updated', doc, 1)
				end

				#IT速報
				itsoku = Nokogiri::HTML.parse(url_set("http://blog.livedoor.jp/itsoku/"), nil, 'utf-8')
				itsoku.css('header.article-header').each do |doc|
					article_link(itsoku.title, 'h1.article-title > a', 'p.article-date > time', doc, 2)
				end

				#ぶるそく
				burusoku = Nokogiri::HTML.parse(url_set("http://burusoku-vip.com/"), nil, 'utf-8')
				burusoku.css('div.top_cnt1-4').each do |doc|
					article_link(burusoku.title, 'h2 > a', 'abbr', doc, 1)
				end
				burusoku.css('div.top_cnt5').each do |doc|
					article_link(burusoku.title, 'h2 > a', 'abbr', doc, 1)
				end

				#viperな俺
				viper = Nokogiri::HTML.parse(url_set("http://blog.livedoor.jp/news23vip/"), nil, 'utf-8')
				viper.css('div.article-header').each do |doc|
					article_link(viper.title, 'div.article-title-outer > h2 > a', 'div.article-date-outer > abbr.updated', doc, 1)
				end

				#稲妻速報
				inazuma = Nokogiri::HTML.parse(url_set("http://inazumanews2.com/"), nil, 'utf-8')
				inazuma.css('div.article-header').each do |doc|
					article_link(inazuma.title, 'div.article-title-outer > h2 > a', 'div.article-date-outer > abbr.updated', doc, 1)
				end

				#ゴシップ速報
				inazuma = Nokogiri::HTML.parse(url_set("http://gossip1.net/"), nil, 'utf-8')
				inazuma.css('header.article-header').each do |doc|
					article_link(inazuma.title, 'p.article-title > a', 'p.article-date > time', doc, 2)
				end

				#ハムスター速報
				hamusoku = Nokogiri::HTML.parse(url_set("http://hamusoku.com/"), nil, 'utf-8')
				hamusoku.css('div.article-inner').each do |doc|
					article_link(hamusoku.title, 'div.article-body-inner span.article-continue > a', 'abbr', doc, 1)
				end

				#痛いニュース
				itainews = Nokogiri::HTML.parse(url_set_binary("http://blog.livedoor.jp/dqnplus/").encode("UTF-8","euc-jp"), nil, 'utf-8')
				itainews.css('div#wrapper div.hentry').each do |doc|
					doc_url = doc.css('div.blogbody > div.titlebody > h3 > a')[0][:href]

					itainews_article = Nokogiri::HTML.parse(url_set_binary(doc_url.to_s), nil, 'euc-jp')
					itai_date = itainews_article.css('div.hentry abbr.updated')[0][:title].encode("UTF-8")

					article_link(itainews.title, 'div.blogbody > div.titlebody > h3 > a', itai_date, doc, 3)
				end

				#スコールちゃんねる
				sukoru = Nokogiri::HTML.parse(url_set("http://squallchannel.com/"), nil, 'utf-8')
				sukoru.css('div.article_inner').each do |doc|
					article_link(sukoru.title, 'div.article-title-outer > h2 > a', 'div.article-date-outer > abbr', doc, 1)
				end
				sukoru.css('div.article_right').each do |doc|
					article_link(sukoru.title, 'div.article-title-outer > h2 > a', 'div.article-date-outer > abbr', doc, 1)
				end

				p 'end!!!!'
			end
		end

		#every(15.seconds, 'frequent.job')
		every(10.minutes, 'less.frequent.job')
	end

	def article_link(hpname, article, date, doc, datecase)
		@article = Article.new
		@article.hpname = hpname
		@article.title = doc.css(article).text
		@article.url = doc.css(article)[0][:href]
		case datecase
		#時刻タグがabbrの場合
		when 1
			#p DateTime.parse(doc.css(date)[0][:title])
			@article.articledate = DateTime.parse(doc.css(date)[0][:title])
		#時刻タグがtimeの場合
		when 2
			#p DateTime.parse(doc.css(date)[0][:datetime])
			@article.articledate = DateTime.parse(doc.css(date)[0][:datetime])
		#時刻を詳細ページから取得した場合
		when 3
			#p DateTime.parse(date)
			@article.articledate = DateTime.parse(date)
		end

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

	def url_set_binary(url)
		charset = nil
		html = open(url, "r:binary") do |f|
			charset = f.charset # 文字種別を取得
			f.read # htmlを読み込んで変数htmlに渡す
		end
		return html
	end