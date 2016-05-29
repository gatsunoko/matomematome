class SitesController < ApplicationController
	before_action :set_site, only: [:show, :edit, :update, :destroy]

	def index
		@sites = Site.all
	end

 	def new
		@site = Site.new
	end

	def edit		
	end

	def show		
	end

	def create
		@site = Site.new(site_params)
		if @site.save
			redirect_to site_path(@site)
		else
			render 'new'
		end
	end

	def update
		if @site.update(site_params)
			redirect_to site_path(@site)
		else
			render 'new'
		end
	end

	def destroy	
		@site.destroy

		redirect_to sites_path	
	end

	def site_params
		params.require(:site).permit(:sitename, :order)
	end

	def set_site
		@site = Site.find params[:id]
	end
end
