//*= require jquery.fitvids
//*= require jquery.bubbletip.js
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
    	insertHtml: ['TrimContent', 'generic', 'sanitize' ]
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


uri = document.URL.split '/'

$(document).ready ()->
	$('#blog-content').attr 'ondrop', 'window.drop(event)'
	$('#blog-content').attr 'ondragover', 'window.allowDrag(event)'


getSelectionText = ()->
    text = "";
    if (window.getSelection)
        text = window.getSelection().toString()
    else if (document.selection && document.selection.type != "Control")
        text = document.selection.createRange().text
    
    return text

window.removeEmpties = ()->
	$('#blog-content *:empty').remove()
								
Aloha.ready ->
	
	$(document.body).append($("<div id='tip1_up' style='display:none;'>Saved!</div>"))
	
	window.imageResizeModalBehaviours()
	
	Aloha.jQuery('#blog-content').aloha();
	
	window.removeEmpties();
				
	$('.resizableImage').each ()->
		
		
		iw = this.width
		ih = this.height
		
		$(this).parent().css 'width', iw
		$(this).parent().css 'height', ih

		$(this).attr 'width', iw
		$(this).attr 'height', ih
		$(this).attr 'style', 'height:'+ih+'px;width:'+iw+'px;';
				
		$(this).css 'display', 'block'
		$(this).css 'margin', '0 auto'
		
		$(this).click ()->
			imageToEdit = $(this)
			window.imageResizeModalPopulate($(this))
			
			$('#img_params').modal('show')


	$('.imgWrap').each ()->
		Aloha.jQuery(this).alohaBlock()
	
	$('#submitPost').on 'show_saved', ()->
	
	$('#submitPost').bubbletip($('#tip1_up'), {
		bindShow: 'show_saved',
		calculateOnShow: true
	});
	
	$('#submitPost').click ()->
		window.removeEmpties();
		
		data = {
			title:$('#post-title').val(),
			content:$('#blog-content-wrap').html(),
			authenticity_token: $('form.edit_post input[name="authenticity_token"]').first().val(),
			site_id: $('#site_id').val()
		}
		
		dataJSON = JSON.stringify(data)
		
		$.ajax
			type: 'PATCH'
			url: $('form.edit_post').first().attr('action')
			data: dataJSON
			contentType: 'application/json'
			dataType: 'json'
			success: (responseJSON)->
				if responseJSON.status == 'success'
					$("#submitPost").trigger("show_saved");
				else
					alert responseJSON.data
