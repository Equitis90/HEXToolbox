//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks
//= require jquery.infinite-pages
//= require bootstrap-multiselect
//= require_tree .

$(function () {
    $( '#set_selector, #type_selector, #cost_selector' ).multiselect( {
        nonSelectedText: 'All',
        allSelectedText: 'All',
        buttonWidth: '300px',
        numberDisplayed: 1,
        onChange: function() {
            $( '#search_form' ).trigger( 'submit.rails' );
        }
    });

    $( '#sub_type_selector' ).multiselect( {
        nonSelectedText: 'All',
        allSelectedText: 'All',
        buttonWidth: '300px',
        numberDisplayed: 2,
        enableFiltering: true,
        enableFullValueFiltering: true,
        maxHeight: 400,
        onChange: function() {
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