$(document).ready(function() {

	$('a[data-window]').click(function(e) {
		var windowType = $(this).attr('data-window');
		var windowName = (typeof($(this).attr('data-window-name')) != 'undefined') ? $(this).attr('data-window-name') : new Date().getTime();
		var windowAttributes = '';
		if(windowType == 'popup')
		    windowAttributes = (typeof($(this).attr('data-attributes')) != 'undefined') ? $(this).attr('data-attributes') : 'width=800,height=420';
		window.open(this.href, windowName, windowAttributes);
		e.preventDefault();
	});

	$('a[data-destroy]').click(function(e) {
		var destroyClass = $(this).attr('data-destroy');
		$('.' + destroyClass).fadeTo('slow', 0, function() {
			$(this).animate({ height: 0, padding: 0, margin: 0 }, 'fast', function() {
				$(this).remove();
			});
		});
		e.preventDefault();
        });
	
});

function getState() {
    return window.location.hash.substr(1)
}

function setState(state) {
    window.location.hash = '#' + state;
}