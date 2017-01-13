// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks
//= require jquery.infinite-pages
//= require bootstrap-multiselect
//= require_tree .

$(function () {
    $( '#set_selector' ).multiselect( {
        onChange: function() {
            $( 'html, body' ).animate( { scrollTop: 0 }, 1000 );
            $( '#search_form' ).trigger( 'submit.rails' );
        }
    });

    $( '#card_name' ).bind( 'keyup', function () {
        $( '#search_form' ).trigger( 'submit.rails' );
    } );

    $('[rel="card_popover"]').popover({
        trigger: 'hover',
        html: true,
        content: function(){ return '<img src="'+$(this).data('img') + '" width="350" height="490" />';}
    })
});