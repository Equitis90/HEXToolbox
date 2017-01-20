//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks
//= require jquery.infinite-pages
//= require bootstrap-multiselect
//= require_tree .

$(function () {
    var multiselectButtonWidth = '240px';
    $( '#set_selector, #type_selector, #cost_selector, #rarity_selector' ).multiselect( {
        nonSelectedText: 'All',
        allSelectedText: 'All',
        buttonWidth: multiselectButtonWidth,
        numberDisplayed: 1,
        onChange: function() {
            $( '#search_form' ).trigger( 'submit.rails' );
        }
    });

    $( '#sub_type_selector' ).multiselect( {
        nonSelectedText: 'All',
        allSelectedText: 'All',
        buttonWidth: multiselectButtonWidth,
        numberDisplayed: 2,
        enableFiltering: true,
        enableFullValueFiltering: true,
        maxHeight: 400,
        onChange: function() {
            $( '#search_form' ).trigger( 'submit.rails' );
        }
    });

    $( '#shard_selector' ).multiselect({
        nonSelectedText: 'All',
        allSelectedText: 'All',
        buttonWidth: multiselectButtonWidth,
        numberDisplayed: 4,
        enableHTML: true,
        'optionLabel': function( element ) {
            return '<img src="'+$( element ).attr( 'data-img' )+' " height="14" width="14"> '+$( element ).text();
        },
        onChange: function() {
            $( '#search_form' ).trigger( 'submit.rails' );
        },
        buttonText: function(options, select) {
            if (options.length === 0) {
                return 'All';
            } else {
                var labels = [];
                options.each(function() {
                    labels.push('<img src="'+$( this ).attr( 'data-img' )+' " height="14" width="14"> '+$( this ).text());
                });
                return labels.join(', ') + '';
            }

        }
    });

    $( '#card_name' ).bind( 'keyup', function () {
        $( '#search_form' ).trigger( 'submit.rails' );
    } );

    $( '[rel="card_popover"]' ).popover({
        trigger: 'hover',
        html: true,
        content: function(){ return '<img src="'+$( this ).data( 'img' ) + '" width="350" height="490" />';}
    })
});