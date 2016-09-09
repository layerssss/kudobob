# = require jquery
# = require jquery_ujs
# = require turbolinks
# = require react
# = require react_ujs
# = require bootstrap
# = require bootstrap-notify
# = require components
# = require_tree .

$(document)
  .on 'turbolinks:load', ->
    $('[data-flash]').each (i, el)=>
      $.notify $(el).data('flash')...
