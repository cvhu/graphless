// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .


(function($) {
    $.cookie = function(key, value, options) {

        // key and at least value given, set cookie...
        if (arguments.length > 1 && (!/Object/.test(Object.prototype.toString.call(value)) || value === null || value === undefined)) {
            options = $.extend({}, options);

            if (value === null || value === undefined) {
                options.expires = -1;
            }

            if (typeof options.expires === 'number') {
                var days = options.expires, t = options.expires = new Date();
                t.setDate(t.getDate() + days);
            }

            value = String(value);

            return (document.cookie = [
                encodeURIComponent(key), '=', options.raw ? value : encodeURIComponent(value),
                options.expires ? '; expires=' + options.expires.toUTCString() : '', // use expires attribute, max-age is not supported by IE
                options.path    ? '; path=' + options.path : '',
                options.domain  ? '; domain=' + options.domain : '',
                options.secure  ? '; secure' : ''
            ].join(''));
        }

        // key and possibly options given, get cookie...
        options = value || {};
        var decode = options.raw ? function(s) { return s; } : decodeURIComponent;

        var pairs = document.cookie.split('; ');
        for (var i = 0, pair; pair = pairs[i] && pairs[i].split('='); i++) {
            if (decode(pair[0]) === key) return decode(pair[1] || ''); // IE saves cookies with empty string as "c; ", e.g. without "=" as opposed to EOMB, thus pair[1] may be undefined
        }
        return null;
    };
})(jQuery);


function updateCookie(obj) {
    $.cookie('key_public', obj.key_public, {expires: 7, path: '/'});
    $.cookie('username', obj.username, {expires: 7, path: '/'});                      
    $.cookie('fullname', obj.fullname, {expires: 7, path: '/'});
}

function clearCookie() {
    $.cookie('key_public', null, {path: '/'});
    $.cookie('username', null, {path: '/'});
    $.cookie('fullname', null, {path: '/'});
}
// Begin

$(document).ready(function() {
	userBar.refresh();
	// $("#user-button").tooltip("already a member?", "white");
})

var userBar = {
	button: "#user-button",
	refresh: function() {
		var key_public = $.cookie('key_public');
		if (key_public==null) {
			if (window.location.pathname == "/login") {
				$(userBar.button).html('Sign Up').attr('href', '/signup');
				$(userBar.button).tooltip('Not a member?', 'white');
			} else if (window.location.pathname == '/signup') {
				$(userBar.button).html('Log In').attr('href', '/login');
				$(userBar.button).tooltip('Already a member?', 'white');
			} else {
				$(userBar.button).html('Log In').attr('href', '/login');
				$(userBar.button).tooltip('Already a member?', 'white');
			}
		} else {
            $.ajax({
                type: 'GET',
                url: '/api/users/header?key_public=' + key_public,
                dataType: 'json',
                beforeSend: function() {
                    $(userBar.button).html("");
                },
                success: function(obj) {
                    if (obj.status == 'success') {
                        $(userBar.button).html(obj.fullname);
                        $(userBar.button).click(function(e) {
                            e.preventDefault();

                        })
                    } else {
                        clearCookie();
                        window.location = '/login';
                    }
                }
            })
        }
	}
}

$.fn.tooltip = function(message, type) {
	var wrapper = $("<div class='tooltip-wrapper'></div>").html(message).addClass(type);
	$(wrapper).hide().insertAfter(this);
	var pos_x = $(this).position().left + $(this).width()/2 - $(wrapper).width()/2;
	var pos_y = $(this).position().top + $(this).height() + $(wrapper).height() + 15;
	$(wrapper).css({top: pos_y, left: pos_x}).delay(500).fadeIn('slow');
	return wrapper;
}