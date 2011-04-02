$(document).ready(function() { 

	var form = $('#update-following-form');

	$('div[data-deselectable]', form).click(function(e) {
		var opacity, checkbox, usersField, usersValue;

		opacity = ($(this).css('opacity') == '0.5') ? '1' : '0.5';
		$(this).fadeTo('fast', opacity).toggleClass('deselected');

		checkbox = $(this).find(':checkbox').first();
		if(e.target.nodeName != 'INPUT')
		    checkbox.attr('checked', !checkbox.attr('checked'));
		setDirty(checkbox);

		usersField = $('input[name="users"]', form);
		usersValue = usersField.attr('value');
		(!checkbox.attr('checked')) ? usersValue += ' ' + checkbox.attr('name') : usersValue = usersValue.replace(' ' + checkbox.attr('name'), '');
		usersField.attr('value', usersValue);

		(isDirty(form)) ? fadeSwitch($('#nav'), $('#save')) : fadeSwitch($('#save'), $('#nav')); 	
	});

	// Pagination

	var pageContainer = $('#page-container');
	var pageWidth = $('.page').first().outerWidth(true);
	var pageNum = (getState()) ? getState() : 1;
	var pagesTotal = $('.page').size();

	// init state

	if(pageNum < 0 || pageNum > pagesTotal)
	    pageNum = 1;
	if(pageNum > 1) {
	    initMargin = -1 * ((pageNum * pageWidth) - pageWidth);
	    pageContainer.css('marginLeft', initMargin);
        }

	refreshPagination(pageNum, pagesTotal);

 	$("a[data-page]").click(function(e) {
		if($(this).hasClass('disabled')) return false;

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
    var key, initVal;

    if(control.attr('type') == 'checkbox') {
	key = 'checked';
	initVal = control.attr('data-init' + key) == "true"; // boolean for comparison
    } else {
	key = 'value';
        initVal = control.attr('data-init' + key);
    }

    (control.attr(key) !== initVal) ? control.removeAttr('data-dirty') : control.attr('data-dirty', 'true');
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

// Redundant/legacy

function formModified(form) {
    var formIsModified = false;
    form.find('input[type="checkbox"]').each(function() {
	    if(!$(this).attr('checked')) {
		formIsModified = true;
	        return false; // break
	    }
    });
    return formIsModified;
}

function refreshVisibility(ele, page) {
    var resultsPerPage = 20;
    var visibleIndexStart = page * resultsPerPage;
    var visibleIndexEnd = visibleIndexStart + resultsPerPage;
    ele.each(function() {
	    eleIndex = ($(this).index() - 1); // no idea why this is necessary
	    ((eleIndex > visibleIndexStart) && (eleIndex <= visibleIndexEnd)) ? $(this).hide() : $(this).fadeIn('fast');
    });
    (page < 1) ? $('a[data-page="last"]').hide() : $('a[data-page="last"]').show();
    (visibleIndexEnd > ele.size()) ? $('a[data-page="next"]').hide() : $('a[data-page="next"]').show();
}