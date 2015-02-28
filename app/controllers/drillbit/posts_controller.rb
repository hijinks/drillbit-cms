require_dependency "drillbit/application_controller"
require 'sanitize'
require 'fileutils'
require 'nokogiri'

module Drillbit
	class PostsController < ApplicationController
	
		respond_to :json
		
		include Drillbit::ApplicationHelper
		include Drillbit::PostsHelper
		
		def index
			@site = Site.find(params[:site_id])
			if @site
				@posts = Post.find_by(:site_id => @site.id) 
			end
		end
	
		def new
			@site = Site.find(params[:site_id])
			
			if @site
				@post = Post.new
				@content = false
				render layout: "drillbit/post"
			else
				render :nothing => true
			end
		end
	
		def create
			@site = Site.find(params[:site_id])
		  
			if @site
				kc = keyCheck(post_params, [:content, :title, :keywords, :description])
	  		  	
				if kc.first
					unless post_params[:title].blank?
						sanitized = Sanitize.fragment(post_params[:content], Sanitize::Config::RELAXED)
						okHTML = scrub_html(sanitized).strip
						@post = Post.create(
							title: post_params[:title], 
							content: okHTML, 
							site_id: @site.id,
							keywords: post_params[:keywords],
							description: post_params[:description]
							)
						
			  		  	if post_params[:gallery_id]
			  		  		@gallery = Gallery.find(post_params[:gallery_id].to_i)
			  		  		if @gallery
			  		  			@gallery.update!(
			  		  				post_id: @post.id,
			  		  				temp: 0
			  		  			)
			  		  		end
			  		  	end
	  		  							
						returnData = {
							:status => 'success',
							:data => {
								:post => @post.id,
								:site => @site.id
							}
						}
					else
						returnData = {
							:status => 'failure',
							:data => 'Missing title'
						}
					end
				else
					returnData = {
						:status => 'failure',
						:data => 'Missing data'
					}
				end
			else
				render :nothing => true
			end
		  
			render :json => returnData
		end

		def show
		
		end

		def edit
			@post = Post.find(params[:id])
			@site = Site.find(params[:site_id])
			if @site && @post
				@content = Sanitize.fragment(@post.content, Sanitize::Config::RELAXED)
				render layout: "drillbit/post"
			else
			   render :nothing => true
			end
		end

		def update
				
			@post = Post.find(params[:id])
			@site = Site.find(params[:site_id])
	  
			if @site && @post
			
				kc = keyCheck(post_params, [:content, :title])
				bc = keyCheck(post_params, [:banner])
				if kc.first
					unless post_params[:title].blank?
						sanitized = Sanitize.fragment(post_params[:content], Sanitize::Config::RELAXED)
						okHTML = scrub_html(sanitized).strip
						@post.update!(title: post_params[:title], content: okHTML, site_id: @site.id)
						returnData = {
							:status => 'success'
						}
					else
						returnData = {
							:status => 'failure',
							:data => 'Missing title'
						}
				  	end
				elsif bc.first
					@post.update_attributes(post_params)
					if @post.save!
						returnData = {
							:status => 'success'
						}						
					end
				else
					returnData = {
						:status => 'failure',
						:data => 'Missing data'
					}
				end
		  	else
				returnData = {
					:status => 'failure',
					:data => 'Missing data'
				}
		  	end
	  
	  		render :json => returnData	  
		end

		def destroy
			@post = Post.find(params[:id])
			@site = Site.find(params[:site_id])
			if @site && @post
				storagePath = File.join(config.file_store, 'galleries')
				
				gallery = Gallery.find_by(post_id: @post.id)
				
				if gallery
					if File.exists?(File.join(storagePath, gallery.id.to_s))
						FileUtils.rm_r File.join(storagePath, gallery.id.to_s)
						Image.destroy_all(:gallery_id => gallery.id)
					end
				end	
					
				@post.destroy
			end
			
			redirect_to :action => "index"	
		end
		
		def upload_text
			
			
			uploader = TextUploader.new
			uploader.store!(text_file_params[:file])
			
			ext = File.extname(uploader.current_path)  
			
			case ext
				when '.txt' || '.rft'
				  raw = getPlainContents(uploader.current_path)
				when '.doc'
				  raw = getDocContents(uploader.current_path)
				when '.docx'
				  raw = getDocxContents(uploader.current_path)
			end

			baseHtml = <<-EOHTML
<html>
	<body>
		<div id="paragraphs">
		</div>
	</body>
</html>
EOHTML
			
			@doc = Nokogiri::HTML::Document.parse baseHtml		
			@body = @doc.root.first_element_child
			
			@paras = @body.css('div#paragraphs')[0]
			
			paragraphs = raw.split( /\r?\n/ )
			
			paragraphs.each do |para|
				newPara = Nokogiri::XML::Node.new "p", @doc
				newPara.content = para
				@paras.add_child(newPara)
			end
			
			render :text => @body.to_html
		end
		
	
		private
		
		def text_file_params
			params.permit(:file)
		end
			
		def post_params
			params.require(:post).permit(:title, :content, :keywords, :description, :gallery_id, :banner)
		end
	end
end
