jQuery(document).ready(function()
{ 
	if(jQuery("#notice"))
	{
		setTimeout(function()
		{
			jQuery("#notice").fadeOut(500);
		}, 20000);
	};
});

toggleDiv = function(div)
{
	switch ($("#"+div).css('display'))
	{
		case "none":
			$("#"+div).fadeIn(300);
		break;

		case "block":
			$("#"+div).fadeOut(300);
		break;
	}	
}