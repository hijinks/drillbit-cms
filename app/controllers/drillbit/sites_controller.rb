require_dependency "drillbit/application_controller"
require 'fileutils'

module Drillbit
	class SitesController < ApplicationController
		layout "drillbit/full_page"
		
		def index
			@sites = Site.order(:name).page params[:page]
		end

		def new
			@site = Site.new
		end

		def create
			@new_site = Site.new(params[:site])

			if @new_site.save
				redirect_to sites_url, :notice => 'New site saved!'
			else
				render :new
			end
		end

		def edit
			@site = Site.find(params[:id])
		end

		def update
			@site = Site.find(params[:id])
			if @site.update_attributes(params[:site])
				redirect_to edit_site_url(params[:id]), :notice => 'Site updated'
			else
				redirect_to edit_site_url(params[:id]), :alert => 'Update failed'
			end
		end

		def delete
			Site.find(params[:id]).destroy
			redirect_to sites_url, :notice => 'Site deleted!'
		end

		def destroy
			
			@site = Site.find(params[:id])
			
			if @site
				@site.posts.each do |post|
					storagePath = File.join(Rails.configuration.file_store, 'galleries')
					
					gallery = Gallery.find_by(post_id: post.id)
					
					if gallery
						if File.exists?(File.join(storagePath, gallery.id.to_s))
							FileUtils.rm_r File.join(storagePath, gallery.id.to_s)
							Image.destroy_all(:gallery_id => gallery.id)
						end
					end
					
					post.destroy			
				end
				
				@site.destroy
			end
			
			redirect_to :action => "index"	
		end
		
		private

		def site_params
			params.require(:site).permit(:name, :keywords, :description)
		end

	end
end
