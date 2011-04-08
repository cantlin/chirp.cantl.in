$(document).ready(function() { 

	var form = $('#update-following-form');

	$('.checkbox-control', form).click(function(e) {
		var checkbox, hiddenField;
		
		if(e.target.nodeName == 'A')
		    return;

		checkbox = $(this).find(':checkbox').first();
		hiddenField = checkbox.next('input[type="hidden"]'); // Do the actual POSTing from a hidden field

		if(e.target.nodeName != 'INPUT') // Let the browser do its thing
		    checkbox.attr('checked', !checkbox.attr('checked'));
		
		if(!checkbox.attr('checked'))
		    $(this).removeClass('selected').addClass('deselected');
		else
		    $(this).removeClass('deselected').addClass('selected');

		(setDirty(checkbox)) ? hiddenField.attr('name', hiddenField.attr('data-name')) : hiddenField.removeAttr('name');
		(isDirty(form)) ? fadeSwitch($('#nav'), $('#save')) : fadeSwitch($('#save'), $('#nav')); 	
	});

	// Pagination

	var pageContainer = $('#page-container');
	var pageWidth = $('.page').first().outerWidth(true);
	var pageNum = (getState() && getState() > 0 && getState() <= pagesTotal) ? getState() : 1;
	var pagesTotal = $('.page').size();

	// init state

	if(pageNum > 1) {
	    initMargin = -1 * ((pageNum * pageWidth) - pageWidth);
	    pageContainer.css('marginLeft', initMargin);
        }

	refreshPagination(pageNum, pagesTotal);

 	$("a[data-page]").click(function(e) {
		if($(this).hasClass('disabled')) return false;
		$(this).blur();

 		var action = $(this).attr('data-page');
		var marginLeft = pageWidth;
		
		if(action == 'next') {
		    pageNum++;
		    marginLeft = -1 * marginLeft;
		} else pageNum--;

 		setState(pageNum);
		pageContainer.animate({marginLeft: '+=' + marginLeft + 'px'}, 'slow');
		refreshPagination(pageNum, pagesTotal);

 		e.preventDefault();
        });

});

function setDirty(control) {
    var key, keyVal, initVal;

    if(control.attr('type') == 'checkbox') {
	key = 'checked';
	initVal = (control.attr('data-init-' + key) == 'true'); // boolean for comparison
    } else {
	key = 'value';
        initVal = control.attr('data-init-' + key);
    }

    keyVal = control.attr(key);

    if(keyVal == initVal) {
	control.removeAttr('data-dirty');
	return false;
    } else
	control.attr('data-dirty', 'true');

    return true;

};

function isDirty(form) {
    return ($('[data-dirty]', form).length != 0)
}

function fadeSwitch(eleOut, eleIn, speed, callback) {
    var speed = (typeof(speed) == 'undefined') ? 'fast' : speed;
    eleOut.fadeOut(speed, function() {
	    eleIn.fadeIn(speed, function() {
		    if(callback) callback(this);
	    });
    });
}

function refreshPagination(pageNum, pagesTotal) {
    var linkNext = $('a[data-page="next"]');
    var linkLast = $('a[data-page="last"]');
    (pageNum >= pagesTotal) ? linkNext.addClass('disabled') : linkNext.removeClass('disabled');
    (pageNum <= 1) ? linkLast.addClass('disabled') : linkLast.removeClass('disabled');
}