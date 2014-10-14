require_dependency "drillbit/application_controller"

module Drillbit
	class GalleriesController < ApplicationController

		def index
			@post = Post.find_by_id(params[:id])
			
			if @post.image_gallery
				@images = @post.image_gallery.images
				render json: @images
			end
		end
		
		def new
			Gallery.new
		end

		def create
			@post = Post.new(post_params);
			site = Site.find(params[:site_id]);
			@post.site_id = site.id;
			
			if @post.save
				redirect_to edit_site_post_path(site, @post)
			else
				render :new
			end
		end

		def show
			
		end

		def edit
 			@post = Post.find(params[:id])
		end

		def update

		end

		def destroy

		end

		private
		
		def post_params
			params.require(:post).permit(:title, :content)
		end
	end
end
