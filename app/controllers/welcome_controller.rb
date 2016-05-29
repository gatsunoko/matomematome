class WelcomeController < ApplicationController
# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'
	def index
		@articles = Article.all.order(articledate: :desc)
		@sites = Site.all

		# htmlをパース(解析)してオブジェクトを生成
		#@tetugaku = Nokogiri::HTML.parse(url_set("http://blog.livedoor.jp/nwknews/"), nil, 'utf-8')
		#itsoku = Nokogiri::HTML.parse(url_set("http://blog.livedoor.jp/itsoku/"), nil, 'utf-8')
		#@burusoku = Nokogiri::HTML.parse(url_set("http://burusoku-vip.com/"), nil, 'utf-8')
		#@viper = Nokogiri::HTML.parse(url_set("http://blog.livedoor.jp/news23vip/"), nil, 'utf-8')
		#@inazuma = Nokogiri::HTML.parse(url_set("http://inazumanews2.com/"), nil, 'utf-8')
=begin

		@gara = Nokogiri::HTML.parse(url_set("http://karapaia.livedoor.biz/"), nil, 'utf-8')
		@ajajasita = Nokogiri::HTML.parse(url_set("http://blog.livedoor.jp/chihhylove/"), nil, 'utf-8')
=end
	end

	def show
		p '---------------------------------------------'
		p params[:sitename]
		@articles = Article.where('hpname like ?', "%" + params[:sitename] + "%").order(articledate: :desc)
		@sites = Site.all

		render 'index'
	end
end
