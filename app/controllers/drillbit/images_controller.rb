require_dependency "drillbit/application_controller"
require 'digest/sha1'

module Drillbit
	class ImagesController < ApplicationController
    skip_before_filter :require_login, :only => [:create]

		layout "drillbit/bare"
		
		include Drillbit::ImagesHelper
		include Drillbit::ApplicationHelper
		
		def create
		
			salt = 'f(£R1:;'
			
			kc = keyCheck(image_params, [:type, :name, :path, :token, :size, :gallery])
			
			status = 400

			if kc.first
				token = Digest::SHA1.hexdigest salt + image_params[:name]

				if token == image_params[:token]
					# File upload has been handled by nginx
					
					# Does gallery exist?
					# This will also need a permissions check
					@gallery = Gallery.find_by_id(image_params[:gallery])
					
					if @gallery
						
						if isImage(image_params[:type])
							time = Time.new
							fullPath, galleryPath, dims = saveImage(image_params[:gallery], image_params[:path], image_params[:name], image_params[:type])
							now = Digest::SHA1.hexdigest image_params[:name].to_s + time.to_s
							
							@image = Image.create(
								name: image_params[:name],
								file_type: image_params[:type],
								path: galleryPath,
								gallery_id: image_params[:gallery].to_i,
								size: image_params[:size].to_i,
								download_token: now,
								height: dims[:height],
								width: dims[:width]
							);
							
				 			status = 200
				 		end
			 		end
				end
			end
 			
			render :nothing => true, :status => status
		end
		
		def new
			@gallery = false
			@image = Image.new
			if params.has_key?(:image_gallery)
				@gallery = Gallery.find_by_id(params[:image_gallery])
			end
			 
			if !@gallery
				@gallery = Gallery.new({
					:post_id => 0,
					:temp => true
				})
			end
		end
		
		def image_params
			params.permit(:type, :name, :path, :token, :size, :gallery)
		end
	end
end