jQuery(document).ready(function()
{
	var contentHeight = Math.round(jQuery(window).height() - 130);

	resizeContent(contentHeight);

	window.onresize = function()
	{
		contentHeight = Math.round(jQuery(window).height() - 130);
		resizeContent(contentHeight);
	};
	
	if(jQuery("#notice"))
	{
		setTimeout(function()
		{
			jQuery("#notice").fadeOut(500);
		}, 20000);
	};
});

resizeContent = function(newHeight)
{
	jQuery("#content").css({"height": newHeight+"px"});
}