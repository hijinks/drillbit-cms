module Drillbit
  module PostsHelper
	def getPlainContents(path)
		file = File.open(path)
		contents = file.read
		file.close
		return contents
	end
	
	def getDocContents(path)
		cmd = "catdoc -a #{path}"
		return %x[ #{cmd} ]
	end
	
	def getDocxContents(path)
		cmd = "/usr/local/bin/docx2txt.pl #{path} -"
		return %x[ #{cmd} ]
	end
  end
end
