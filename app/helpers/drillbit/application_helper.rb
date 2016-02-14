require 'nokogiri'

module Drillbit
  module ApplicationHelper
		def javascript(*files)
			content_for(:head) { javascript_include_tag(*files) }
		end

		def stylesheet(*files)
			content_for(:head) { stylesheet_link_tag(*files) }
		end
		
		def keyCheck(hash, keysNeeded)
			ok = true
			notPresent = []
			
			keysNeeded.each {|k|
				if !hash.has_key?(k)
					ok = false
					notPresent.push(k)				
				end
			}
			
			if ok
				return true, []
			else
				return false, notPresent
			end
		end
		
		def rebuild_editables(html)
		
			raw = '<div>'+(html)+'</div>'
			
			parsed  = Nokogiri::HTML::fragment(raw)

			parsed.xpath(".//div[contains(concat(' ', @class, ' '), ' videoWrap ')]").each do |node|
				iframe = node.xpath(".//iframe").first()
				
				if iframe
					video_div  = Nokogiri::XML::Node.new "div", parsed
					video_div['class'] = 'videoWrap'
					thumb_url = iframe['alt']
					thumb_img = Nokogiri::XML::Node.new "img", parsed
					thumb_img['class'] = 'videoWrapThumb'
					thumb_img['src'] = thumb_url
					thumb_img['alt'] = iframe['src']
					thumb_img['width'] = 300
					thumb_img['height'] = 240
					
					video_div.add_child(thumb_img)
					node.add_next_sibling(video_div)
					node.remove				
				end
			end
				
			res = parsed.to_html
			
			return res[5..-7]
		end

		def scrub_html(raw)
			
			# Need a root element
			
			raw = '<div>'+raw+'</div>'
			
			parsed  = Nokogiri::HTML::fragment(raw)
			
			parsed.xpath(".//div[contains(concat(' ', @class, ' '), ' imgWrap ')]").each do |node|
				img = node.xpath(".//img").first()
				if img
					heightVal = 'auto'
					widthVal = 'auto'
					
					if !img['style'].nil?
						
						hv = /height:([^;]+)/.match(img['style'])
						
						if hv
							heightVal = hv[1].strip
						end
						
						wv = /width:([^;]+)/.match(img['style'])
	
						if wv
							widthVal = wv[1].strip
						end
					elsif img['height'] && img['width']
						heightVal = img['height']
						widthVal = img['width']
					end
															
					newImg = Nokogiri::XML::Node.new "img", parsed
						
					newImg['src'] = img['src']
					newImg['height'] = heightVal
					newImg['class'] = 'img-thumbnail resizableImage'
					newImg['width'] = widthVal
					
					newImgDivInner = Nokogiri::XML::Node.new "div", parsed
					newImgDivInner['class'] = 'imgWrapInner'
					
					newImgDiv = Nokogiri::XML::Node.new "div", parsed
					newImgDiv['class'] = 'imgWrap'
									
					newImgDivInner.add_child(newImg)
					newImgDiv.add_child(newImgDivInner)
					node.add_next_sibling(newImgDiv)
				end
				
				node.remove
			end
			
			parsed.xpath(".//div[contains(concat(' ', @class, ' '), 'to-clean')]").each do |node|
				node.remove
			end
			
			parsed.xpath(".//div[contains(concat(' ', @class, ' '), ' videoWrap ')]").each do |node|
				thumb = node.xpath(".//img").first()
				if thumb
					if !thumb['alt'].nil?
						video_url = thumb['alt']
						thumb_url = thumb['src']
						wrapper_div = Nokogiri::XML::Node.new "div", parsed
						wrapper_div['class'] = 'videoWrap embed-responsive embed-responsive-16by9'
						
																
						iframe = Nokogiri::XML::Node.new "iframe", parsed
						
						iframe['src'] = video_url
						iframe['alt'] = thumb_url
						iframe['class'] = 'video-embed embed-responsive-item'
	
						wrapper_div.add_child(iframe)
						node.add_next_sibling(wrapper_div)
						node.remove
					end
				end
			end
						
			res = parsed.to_html

			# Get rid of root element
			return res[5..-7]			
		end
	
  end
end
