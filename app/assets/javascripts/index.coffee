$ ->
# Configure infinite table
  $('.infinite-table').infinitePages
# debug: true
    loading: ->
      $(this).text('Loading next page...')
    error: ->
      $(this).button('There was an error, please try again')