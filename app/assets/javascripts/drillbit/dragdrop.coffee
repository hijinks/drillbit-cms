window.imageResizeModalBehaviours = ()->
	$('#imgWidthOpt').change ()->
		if $('#lockAspect').attr('checked') == 'checked'
			oR = $('#originalRatio').val()
			wv = $('#imgWidthOpt').val()
			$('#imgHeightOpt').attr('value', Math.floor(wv*oR))
			
	$('#imgHeightOpt').change ()->
		if $('#lockAspect').attr('checked') == 'checked'
			oR = $('#originalRatio').val()
			hv = $('#imgHeightOpt').val()
			$('#imgWidthOpt').attr('value', Math.floor(hv/oR))
	
	$('#lockAspect').change ()->
		if this.checked == true
			$('#lockAspect').attr('checked', 'checked')
			$('#imgHeightOpt').trigger('change')
			$('#imgWidthOpt').trigger('change')
		else
			$('#lockAspect').attr('checked', false)
			$('#imgHeightOpt').trigger('change')
			$('#imgWidthOpt').trigger('change')


window.imageResizeModalPopulate = (image)->
	iw = $(image).width()+10
	ih = $(image).height()+10
	
	window.imageToEdit = image
	
	$('#lockAspect').attr('checked', 'checked')
	$('#lockAspect').checked = true

	$('#originalRatio').attr('value', ih/iw)
	$('#imgWidthOpt').attr('value', iw)
	$('#imgHeightOpt').attr('value', ih)
	
	$('#saveImageDims').off('click')
	$('#saveImageDims').click ()->
		$(window.imageToEdit).css
			height:$('#imgHeightOpt').val()
			width:$('#imgWidthOpt').val()
		
		$(window.imageToEdit).parent().css
			height:$('#imgHeightOpt').val()
			width:$('#imgWidthOpt').val()	
			
window.allowDrag = (ev)->
	ev.preventDefault()

window.dragStart = (ev)->
	ev.dataTransfer.effectAllowed = 'move'
	ev.dataTransfer.setData "src", ev.target.getAttribute('src')
	ev.dataTransfer.setData "class", ev.target.getAttribute('class')
	ev.dataTransfer.setData "width", ev.target.getAttribute('original-width')
	ev.dataTransfer.setData "height", ev.target.getAttribute('original-height')
	ev.dataTransfer.setDragImage ev.target,0,0
	return true
	
window.drop = (ev)->
	ev.preventDefault()
	imgSrc = ev.dataTransfer.getData 'src'
	imgClass = ev.dataTransfer.getData 'class'
	iw = ev.dataTransfer.getData 'width'
	ih = ev.dataTransfer.getData 'height'
	sl = imgSrc.split('/')
	sl.pop()
	sl.push('medium')
	cl = imgClass.split(' ')
	
	if cl.indexOf("galleryDrop") >= 0	
		imgDiv = document.createElement("div")
		imgDivInner = document.createElement("div")
		imgDivInner.setAttribute('class', 'imgWrapInner')
		imgDiv.setAttribute('class', 'imgWrap')
		
		newImg = document.createElement("img")
		newImg.setAttribute('class', 'img-thumbnail resizableImage')
		
		newImg.setAttribute('src', sl.join('/'))
		imgDiv.appendChild(imgDivInner)
		imgDivInner.appendChild(newImg)
		
		if $(ev.target).is('#blog-content')
			$(ev.target).append imgDiv
		else
			$(ev.target).parents().each ()->
				if $(this).is('#blog-content')
					$(this).append imgDiv
			
		
		$(newImg).css 'width', iw
		$(newImg).css 'height', ih
		$(newImg).attr 'width', iw
		$(newImg).attr 'height', ih
		
		$(imgDivInner).css 'width', iw
		$(imgDivInner).css 'height', ih
		
		$(newImg).css 'display', 'block'
		$(newImg).css 'margin', '0 auto'
		
		$(newImg).click ()->
			window.imageToEdit = $(this)
			window.imageResizeModalPopulate($(this))
			$('#img_params').modal('show')
			
		Aloha.jQuery(imgDiv).alohaBlock()
		
$('document').ready ()->
