$('document').ready ()->
	
	$('.site_delete').each ()->
		
		self = $(this)
		targetForm = self.parent().parent()
		targetForm.submit (event)->
			if confirm('Confirmation deletion? This will also delete all posts.') == true
				this.submit()
			
			event.preventDefault()		
		
