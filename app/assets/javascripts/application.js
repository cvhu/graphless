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
                    $(userBar.button).spinning();
                },
                success: function(obj) {
                    if (obj.status == 'success') {
                        if (window.location.pathname == '/login' || window.location.pathname == '/signup') {
                            window.location = '/@' + obj.username
                        }
                        $(userBar.button).html(obj.fullname + ' <i class="fa fa-chevron-down"></i>');
                        $(userBar.button).click(function(e) {
                            e.preventDefault();
                            if ($('#user-nav').length>0){
                                $('#user-nav').slideUp('normal', function(){ $(this).remove();});
                                $(userBar.button).html(obj.fullname + ' <i class="fa fa-chevron-down"></i>');
                            }else{
                                userBar.showMenu(obj);
                                $(userBar.button).html(obj.fullname + ' <i class="fa fa-chevron-up"></i>');
                            }
                        })
                    } else {
                        clearCookie();
                        window.location = '/login';
                    }
                }
            })
        }
	},
    showMenu: function(obj) {
        var root = $('<ul id="user-nav"></ul>');
        $('<li></li>').html('<a id="user-nav-profile" href="/@' + obj.username + '">Profile</a>').appendTo(root);
        var logout = $('<a href="#" id="signout-link">Log Out</a>');
        $(logout).click(function(e){
            e.preventDefault();
            $.ajax({                
                url: '/api/users/logout',
                type: 'post',
                data: {
                    key_public: $.cookie('key_public')
                },
                dataType: 'json',
                success: function(data){
                    userBar.logout();
                }
            })
        })
        $('<li></li>').append(logout).appendTo(root);   
        $(root).hide().insertAfter(userBar.button).slideDown();
        var pos_x = $(userBar.button).position().left + $(userBar.button).width()/2 - $(root).width()/2;
        var pos_y = $(userBar.button).position().top + $(userBar.button).height() + $(root).height() + 25;
        $(root).css({top: pos_y, left: pos_x});
    },
    logout: function() {
        clearCookie();
        window.location = '/login';
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

var models = [];

$.fn.loadModels = function() {
    var wrapper = this;
    $.ajax({
        type: 'GET',
        url: '/api/models/list.json?key_public=' + $.cookie('key_public'),
        dataType: 'json',
        beforeSend: function() {
            $(wrapper).spinning();
        },
        success: function(obj) {
            if (obj.status == 'success') {
                $(wrapper).unspinning();
                $(wrapper).loadNewModelForm();
                $.each(obj.models, function(i, v) {
                    $(wrapper).addModel(v);
                })
            } else {
                console.log(obj);
            }
        }
    })
    return wrapper;
}

$.fn.loadNewModelForm = function() {
    var wrapper = this;
    var add = $('<a href="#" class="model-box model-new"></a>').html('<i class="fa fa-plus fa-3x"></i>');
    $(add).click(function(e) {
        e.preventDefault();
        wrapper.editModel();
    })
    $(wrapper).append(add);
    return wrapper;
}

$.fn.addModel = function(model) {
    models.push(model);
    var wrapper = this;
    if (model.user != null) {
        var model_div = $('<a href="#" class="model-box"></a>').html(model.name).hide();
        model_div.addClass('model');
        $(model_div).click(function(e) {
            e.preventDefault();
            model_div.chooseModel(model.id);
        })
        model_div.insertAfter(wrapper.find('.model-new'));
        $(model_div).fadeIn();
    } else {
        // model_div.addClass('model-default');
        // model_div.attr('href', null);
    }
    return wrapper;
}

$.fn.loadEvents = function() {
    var wrapper = this;
    $.ajax({
        type: 'GET',
        url: '/api/events/list.json?key_public=' + $.cookie('key_public') + '&app_id=' + $('#app').attr('app_id'),
        dataType: 'json',
        beforeSend: function() {
            $(wrapper).spinning();
        },
        success: function(obj) {
            if (obj.status == 'success') {
                $(wrapper).unspinning();
                $(wrapper).loadNewEventForm();
                $.each(obj.events, function(i, v) {
                    $(wrapper).addEvent(v);
                })
            } else {
                console.log(obj);
            }
        }
    })
    return wrapper;
}

$.fn.loadNewEventForm = function() {
    var wrapper = this;
    var add = $('<a href="#" class="event-box event-new"></a>').html('<i class="fa fa-plus fa-3x"></i>');
    $(add).click(function(e) {
        e.preventDefault();
        wrapper.createEvent($('#model').attr('model_id'));
    })
    $(wrapper).append(add);
    return wrapper;
}

$.fn.addEvent = function(event_obj) {
    var wrapper = this;
    var event_div = $('<a href="#" class="event-box"></a>').hide();
    event_div.addClass('event');
    $(event_div).click(function(e) {
        e.preventDefault();
        event_div.viewEvent(event_obj.id);
    })
    event_div.insertAfter(wrapper.find('.event-new'));
    $(event_div).fadeIn();
    return wrapper;
}

$.fn.createEvent = function(model_id) {
    var root = this;
    var wrapper = $('<div class="model-view bordered-box"></div>');
    $.ajax({
        type: 'GET',
        url: '/api/models/view.json?model_id=' + model_id,
        dataType: 'json',
        beforeSend: function() {
            wrapper.spinning();
        },
        success: function(obj) {
            wrapper.unspinning();
            // $('<div class="model-name"></div>').html(obj.model.name).appendTo(wrapper);
            var form = $('<form action="/api/events/create.json"></form>').appendTo(wrapper);
            var ul = $('<ul></ul>').appendTo(form);
            ul.buildMnodes(-1, obj, 'add-event');
            $('<input type="hidden" name="key_public">').val($.cookie('key_public')).appendTo(form);
            $('<input type="hidden" name="app_id">').val($('#app').attr('app_id')).appendTo(form);
            $('<input type="hidden" name="model_id">').val($('#model').attr('model_id')).appendTo(form);
            var buttonsDiv = $('<div class="form-field"></div>').appendTo(wrapper);
            var addButton = $('<input type="submit" class="half-length blue button" value="Add Event">').appendTo(buttonsDiv);
            $(addButton).click(function(e) {
                e.preventDefault();
                console.log(form.serialize());
                $.ajax({
                    type: 'POST',
                    url: form.attr('action'),
                    data: form.serialize(),
                    beforeSend: function() {
                        addButton.spinning();
                    },
                    success: function(obj) {
                        addButton.unspinning();
                        dismissLightBox();
                        root.addEvent(obj.event);
                    }
                })
            })
            var cancelButton = $('<a href="#" class="half-length red button"></a>').html('Cancel').appendTo(buttonsDiv);
            $(cancelButton).click(function(e) {
                e.preventDefault();
                dismissLightBox();
            })
            wrapper.launchLightBox();
        }
    })
}


$.fn.viewEvent = function(event_id) {
    var root = this;
    var wrapper = $('<div class="model-view bordered-box"></div>');
    $.ajax({
        type: 'GET',
        url: '/api/events/view.json?event_id=' + event_id,
        dataType: 'json',
        beforeSend: function() {
            wrapper.spinning();
        },
        success: function(obj) {
            wrapper.unspinning();
            var ul = $('<ul></ul>').appendTo(wrapper);
            ul.buildMnodes(-1, obj, 'view-event');
            var buttonsDiv = $('<div class="form-field"></div>').appendTo(wrapper);
            var okayButton = $('<a href="#" class="half-length blue button"></a>').html('Okay').appendTo(buttonsDiv);
            $(okayButton).click(function(e) {
                e.preventDefault();
                dismissLightBox();
            })
            wrapper.launchLightBox();
        }
    })
}

$.fn.loadApps = function() {
    var wrapper = this;
    $.ajax({
        type: 'GET',
        url: '/api/apps/list.json?key_public=' + $.cookie('key_public'),
        dataType: 'json',
        beforeSend: function() {
            $(wrapper).spinning();
        },
        success: function(obj) {
            if (obj.status == 'success') {
                $(wrapper).unspinning();
                $(wrapper).loadNewAppForm();
                $.each(obj.apps, function(i, v) {
                    $(wrapper).addApp(v);
                })
            } else {
                console.log(obj);
            }
        }
    })
    return wrapper;
}

$.fn.loadNewAppForm = function() {
    var wrapper = this;
    var add = $('<a href="/apps/new" class="app-box app-new"></a>').html('<i class="fa fa-plus fa-3x"></i>');
    $(wrapper).append(add);
    return wrapper;
}

$.fn.addApp = function(app) {
    var wrapper = this;
    var app_div = $('<a href="/apps/' + app.id + '" class="app-box"></a>').html(app.name).hide();
    app_div.addClass('app');
    app_div.insertAfter(wrapper.find('.app-new'));
    $(app_div).fadeIn();
    return wrapper;
}


$.fn.chooseModel = function(model_id) {
    var root = this;
    var wrapper = $('<div class="model-view bordered-box"></div>');
    $.ajax({
        type: 'GET',
        url: '/api/models/view.json?model_id=' + model_id,
        dataType: 'json',
        beforeSend: function() {
            wrapper.spinning();
        },
        success: function(obj) {
            wrapper.unspinning();
            // $('<div class="model-name"></div>').html(obj.model.name).appendTo(wrapper);
            var ul = $('<ul></ul>').appendTo(wrapper);
            ul.buildMnodes(-1, obj, 'choose');
            var buttonsDiv = $('<div class="form-field"></div>').appendTo(wrapper);
            var chooseButton = $('<a href="#" class="half-length blue button"></a>').html('Choose').appendTo(buttonsDiv);
            $(chooseButton).click(function(e) {
                e.preventDefault();
                $('.model-box.model .fa-check-circle').remove();
                root.append($('<i class="fa fa-check-circle fa-lg"></i>'));
                $('#chosen-model').html(obj.model.name);
                $('input[name="model_id"]').val(model_id);
                dismissLightBox();
            })
            var cancelButton = $('<a href="#" class="half-length red button"></a>').html('Cancel').appendTo(buttonsDiv);
            $(cancelButton).click(function(e) {
                e.preventDefault();
                dismissLightBox();
            })
            wrapper.launchLightBox();
        }
    })
}

$.fn.buildMnodes = function(parent_id, obj, mode) {
    var wrapper = this;
    if (mode == 'view-event') {
        mnodes = obj.event.mnodes;
    } else {
        mnodes = obj.model.mnodes;
    }
    $.each(mnodes, function(i, v) {
        if (v.parent_id == parent_id) {
            var li = $('<li></li>').appendTo(wrapper);
            var field = $('<div class="form-field"></div>').appendTo(li);
            var label = $('<label></label>').html(v.name + '(' + v.data_type + ')').appendTo(field);
            if (v.data_type != 'compound') {
                console.log('! compount' + mode);
                if (mode == 'add-event') {
                    console.log('text');
                    $('<input type="text" name="contents[]">').appendTo(field);
                    $('<input type="hidden" name="mnodes[]">').val(v.id).appendTo(field);
                } else if (mode == 'view-event') {
                    var value_content = getValue(obj.event.values, v.id);
                    console.log('view-event ' + value_content);
                    $('<input type="text" disabled>').val(value_content).appendTo(field);
                }
            }
            var ul = $('<ul></ul>').appendTo(li);
            ul.buildMnodes(v.id, obj, mode);
        }
    })
}

function getValue(values, mnode_id) {
    var content = '';
    $.each(values, function(i, v) {
        if (v.mnode_id == mnode_id) {
            // console.log('values: ' + v.mnode_id +' mnode_id: ' + mnode_id);
            content = v.content;
        }
    })
    return content;
}

$.fn.editModel = function() {
    var root = this;
    var wrapper = $('<div class="model-edit"></div>');
    var form = $('<form action="/api/models/create.json" id="new-model" class="bordered-box"></form>').appendTo(wrapper);
    var nameField = $('<div class="form-field"></div>').html('<label>Name</label><input type="text" name="name" class="full-length">').appendTo(form);
    var propertiesField = $('<div class="form-field"></div>').html('<label>Properties</label>').appendTo(form);
    propertiesField.addModelSelection();
    var keyPublic = $('<input name="key_public" type="hidden">').val($.cookie('key_public')).appendTo(form);
    var buttonsDiv = $('<div class="form-field"></div>').appendTo(form);
    var saveButton = $('<input type="submit" class="half-length blue button" value="Save">').appendTo(buttonsDiv);
    $(saveButton).click(function(e) {
        e.preventDefault();
        console.log(form.serialize());
        $.ajax({
            type: 'POST',
            url: form.attr('action'),
            data: form.serialize(),
            beforeSend: function() {
                saveButton.spinning();
            },
            success: function(obj) {
                saveButton.unspinning();
                dismissLightBox();
                root.addModel(obj.model);
            }
        })
    })
    var cancelButton = $('<a href="#" class="half-length red button"></a>').html('Cancel').appendTo(buttonsDiv);
    $(cancelButton).click(function(e) {
        e.preventDefault();
        dismissLightBox();
    })
    $(wrapper).launchLightBox();
}

$.fn.addModelSelection = function() {
    var wrapper = this;
    var property = $('<div class="model-property"></div>').hide().appendTo(wrapper).fadeIn();
    $('<input type="text" name="property_names[]" placeholder="property name" class="full-length">').appendTo(property);
    var selection = $('<select name="property_models[]" class="models"></select>').appendTo(property);
    $.each(models, function(i, model) {
        $('<option></option>').val(model.id).html(model.name).appendTo(selection);
    })
    var add = $('<a href="#" class="add"></a>').html('<i class="fa fa-plus-square fa-2x"></i>').appendTo(property);
    $(add).click(function(e) {
        e.preventDefault();
        $(wrapper).addModelSelection(models);
    });
    if ($(wrapper).find('.model-property').length > 1) {
        var remove = $('<a href="#" class="remove"></a>').html('<i class="fa fa-minus-square fa-2x"></i>').appendTo(property);
        $(remove).click(function(e) {
            e.preventDefault();
            $(property).remove();
        });
    }
    return this;
}

$.fn.launchLightBox = function() {
    var blackBox = $('<div id="black-overlay"></div>').hide().appendTo('body').fadeIn();
    var lightBox = $('<div id="white-overlay"></div>').append(this).appendTo('body');
    var pos_x = $(blackBox).width()/2 - $(lightBox).width()/2;
    var pos_y = $(blackBox).height()/2 - $(lightBox).height()/2;
    $(lightBox).css({top: pos_y, left: pos_x});
}

function dismissLightBox() {
    $('#white-overlay').remove();
    $('#black-overlay').remove();
}

$.fn.spinning = function() {
    $(this).html('<i class="fa fa-refresh fa-spin" style="text-align: center;"></i>');
}

$.fn.unspinning = function() {
    $(this).find('.fa-spin').first().remove();
}