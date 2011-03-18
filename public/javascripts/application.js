// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function () {

	$('a[data-popup=true]').click(function(e) {
		var windowName = 'chirpette';
		var windowAttributes = (typeof($(this).attr('data-attributes')) != 'undefined') ? $(this).attr('data-attributes') : 'width=800, height=420';
		window.open(this.href, windowName, windowAttributes);
		e.preventDefault();
		return false;
	});
	
});