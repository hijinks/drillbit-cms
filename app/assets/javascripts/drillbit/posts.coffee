$('document').ready ()->
	
	$('.post_delete').each ()->
		
		self = $(this)
		targetForm = self.parent().parent()
		targetForm.submit (event)->
			if confirm('Confirmation deletion?') == true
				this.submit()
			
			event.preventDefault()		
		
