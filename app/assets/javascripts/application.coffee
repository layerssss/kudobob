# = require jquery
# = require jquery_ujs
# = require jquery.turbolinks
# = require underscore
# = require faker
# = require turbolinks
# = require turbolinks-compatibility
# = require react
# = require react_ujs
# = require bootstrap
# = require bootstrap-notify
# = require ace-rails-ap
# = require ace/theme-solarized_light
# = require ace/mode-javascript
# = require components
# = require_tree .

$ ->
  $('[data-flash]').each (i, el)=>
    $.notify $(el).data('flash')...
