
{
  div
  input
  span
  a
  p
  form
  img
  button
  h1
  h2
  br
  ul
  li
  table
  tr
  td
  tbody
  thead
  th
  textarea
} = React.DOM
@AceEditor = React.createClass
  getInitialState: ->
    id: "ace_editor_#{Math.floor 1000 * Math.random()}"
  set_value: (value)->
    @editor.setValue value
  get_value: ->
    @editor.getValue()
  componentDidMount: ->
    @editor = ace.edit(@state.id)
    @editor.setTheme('ace/theme/solarized_light')
    @editor.getSession().setMode('ace/mode/javascript')
    if @props.field
      $form = $(ReactDOM.findDOMNode @).closest('form')
      $input = $form.find("[name='#{@props.field}']")
      throw new Error "Can't find #{@props.field}" unless $input.length
      $input.hide()
      @editor.setValue($input.val())
      @editor.on 'change', =>
        $input.val(@editor.getValue())

    @editor.on 'change', =>
      @props.on_change?.call @, @editor.getValue()
  componentWillUnmount: ->
    @editor.destroy()
  render: ->
    div
      id: @state.id
      ref: 'container'
      style:
        position: 'absolute'
        top: 0
        left: 0
        right: 0
        bottom: 0
