//*= require jquery.storageapi
//*= require jquery.cookie
//*= require jquery.fitvids
//*= require drillbit/dragdrop

Aloha = window.Aloha || {};

Aloha.settings = 
	locale: 'en'
	jQuery: jQuery
	baseUrl: '/assets/drillbit/'
	requireConfig:
		paths:
			'aloha-gallery': '/assets/drillbit/aloha-gallery'
	contentHandler:
    	insertHtml: ['generic', 'sanitize' ]
	plugins:
		image:
			config: [ 'img' ],
			editables:{
				'#blog-content' : []
			}
			ui:
				oneTab	: false
				insert	: true
				reset	: true
				aspectRatioToggle: true 
				align	: true
				resize	: true
				meta	: true
				margin	: true
				crop	: false
				resizable	: true
				handles	: 'ne, se, sw, nw'  
		
			onCropped: ($image, props)->
			
			onReset: ($image)->
			
			onResize: ($image)->
		
			onResized: ($image)->

	toolbar:
		tabs:[
			{
				label: "tab.format.label"
			},
			{
				label: "tab.insert.label"
			},
			{
				label: 'Media',
				exclusive: true,
				components: [
					"gallery"
				]
			}
		]



storage = $.localStorage
uri = document.URL.split '/'
saveInterval = false

$.cookie.json = true;


saveToLocal = ->
	storage.set(uri[uri.length - 3],
		'title':$('#post-title').val(),
		'keywords':$('#keywords').val()
		'description':$('#description').val()
		'banner': $('#banner').val()
		'content':$('#blog-content').html()
		'gallery': galleryId()
	)

galleryId = ->
	if $('#gallery_id').length
		v = $('#gallery_id').val()
	else
		v = false

	return v

autoSave = (callback)->
	
	if autosaveCycle != undefined
		clearInterval autosaveCycle
		
	autosaveCycle = setInterval(->
		callback.call()
		console.log('saving')
	,saveInterval)


window.removeEmpties = ()->
	$('#blog-content *:empty').remove()
	
$('document').ready ()->
	$('#chooseAutosaveInterval').change ()->
		saveVal = this.options[this.selectedIndex].text
		d = saveVal.split(' ')
		saveInterval = d[0]*60000
		autoSave(saveToLocal)
	
	if !saveInterval
		$( "#chooseAutosaveInterval" ).trigger 'change'

	
Aloha.ready ->

	Aloha.jQuery('#blog-content').aloha();

	window.removeEmpties();
	
	formType = uri[uri.length - 1]
	siteId = uri[uri.length - 3]
	
	# Local storage
	if storage.isSet(uri[uri.length - 3])
		$('#blog-content').html(storage.get(siteId).content)
	
	$('#blog-content').focusin ()->
		saveInterval = autoSave(saveToLocal)
	
	$('#blog-content').focusout ()->
		clearInterval(saveInterval)
		
	$('#submitPost').click ()->
		window.removeEmpties();
		
		data = {
			title:$('#post-title').val(),
			content:$('#blog-content-wrap').html(),
			keywords:$('#keywords').val(),
			description:$('#description').val(),
			gallery_id:galleryId(),
			authenticity_token: $('#new_post input[name="authenticity_token"]').val()
		}
		dataJSON = JSON.stringify(data)
		$.ajax
			type: 'POST'
			url: $('#new_post').attr('action')
			data: dataJSON
			contentType: 'application/json'
			dataType: 'json'
			success: (responseJSON)->
				if responseJSON.status == 'success'
					window.location = '/admin/sites/'+responseJSON.data.site+'/posts/'+responseJSON.data.post+'/edit'
				else
					alert responseJSON.data
