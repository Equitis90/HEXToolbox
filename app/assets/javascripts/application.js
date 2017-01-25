//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks
//= require jquery.infinite-pages
//= require bootstrap-multiselect
//= require_tree .

$(document).ready(function () {
    $( '[rel="card_popover"]' ).popover({
        trigger: 'hover',
        html: true,
        content: function(){ return '<img src="'+$( this ).data( 'img' ) + '" width="350" height="490" />';}
    });

    if ( ($(window).height() + 100) < $(document).height() ) {
        $('#top-link-block').removeClass('hidden').affix({
            offset: {top:100}
        });
    }
});