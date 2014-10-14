$(document).ready ()->
	
	progressId = Math.random().toString(36).substr(2)
	
	$('#uploadForm').attr 'action', '/admin/upload?X-Progress-ID='+progressId
	
	getProgress = ()->
		pInt = setInterval ()->
			$.ajax
				url:'/admin/progress',
				dataType: 'json',
				beforeSend: (xhr)->
					xhr.setRequestHeader('X-Progress-ID', progressId)
				success: (data)->
					if data.state in ['starting', 'uploading']
						percent = Math.floor (data.received/data.size)*100
						$('#progBar').attr 'aria-valuenow', percent
						$('#progBar').width percent+'%'
						$('#progBar').text percent+'%'
						
					else
						$('#progBar').attr 'aria-valuenow', '100'
						$('#progBar').width '100%'
						$('#progBar').text '100%'
						#$('.progress').first.css 'display', 'none'
						clearInterval pInt
				
		,1000
		
	$("#uploadForm > input[type=button]").click ()->
		if $("#uploadForm > input[type=file]").val()
			$('#uploadForm').submit()
			#$('.progress').first.css 'display', 'block'
			setTimeout ()->
				getProgress()
			,500
		else
			alert 'No file!'
		