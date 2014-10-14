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
			@gallery = Gallery.new({
				:post_id => 0,
				:temp => 1
			})
			@gallery.save
			render layout: "drillbit/bare"
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
			@gallery = Gallery.find_by_id(params[:id])
 			
 			unless @gallery.nil?
	 			if @images = @gallery.images
					render layout: "drillbit/bare"
				else
					render :text => 'No images!'
				end
			else
				render :text => 'No gallery!'
			end
		end

		def edit
 			@gallery = Gallery.find_by(post_id: params[:id])
 			if @gallery
 				render layout: "drillbit/bare"
 			else
 				render :nothing => true, :status => 404
 			end
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
