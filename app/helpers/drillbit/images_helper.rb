require 'RMagick'

module Drillbit
	module ImagesHelper
		
		def isImage(fileType)
			okTypes = [
				'image/jpeg',
				'image/pjpeg',
				'image/png',
				'image/gif'
			]
			
			return okTypes.include? fileType
		end
		
		def saveImage(gallery_id, rel_path, file_name, file_type)
			
			storagePath = '/home/shinto/site/rails/shinto/app/store/galleries'
			tmpPath = File.join('/home/shinto/site/rails/shinto/app/store/tmp', rel_path)
			randkey = (0...8).map { (65 + rand(26)).chr }.join.downcase 
			galleryDir = File.join(storagePath, gallery_id)
			galleryPath = File.join(gallery_id, randkey + '_' + file_name)
			newPath = File.join(galleryDir, randkey + '_' + file_name)
			ext = File.extname(file_name)
			
			justName = File.basename(file_name, ext)
			thumbNameM = File.join(galleryDir, randkey + '_' + justName + '_m' + ext)
			thumbNameS = File.join(galleryDir, randkey + '_' + justName + '_s' + ext)
			if !Dir.exists? galleryDir
				Dir.mkdir galleryDir
				FileUtils.chown 'www-data', 'www-data', galleryDir
			end
			
			FileUtils.mv(tmpPath, newPath)
			
			FileUtils.chown 'www-data', 'www-data', newPath
			
			img = Magick::Image.read(newPath).first
			oWidth = img.columns
			oHeight = img.rows
			
			img2 = Magick::Image.read(newPath).first
			
			thumb = img.resize_to_fit!(100, 100)
			
			
			if file_type.downcase == 'image/gif'
				thumb.write thumbNameS
				FileUtils.cp(newPath, thumbNameM)
			else
				if img.rows < 500 && img.columns < 500
					thumb2 = img2
				else
					thumb2 = img2.resize_to_fit!(500, 500)
				end
				thumb.write thumbNameS
				thumb2.write thumbNameM
			end
			
			
			
			FileUtils.chown 'www-data', 'www-data', thumbNameS
			FileUtils.chown 'www-data', 'www-data', thumbNameM
			
			dims = {
				:width => oWidth,
				:height => oHeight
			}
			return newPath, galleryPath, dims
		end

		def getImage(gallery_id, file_name)

		end
	end
end
