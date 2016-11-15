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
  i
} = React.DOM
_error = (msg)->
  $.notify(
    icon: 'fa fa-exclamation-triangle'
    message: msg
  ,
    type: 'danger'
  )
_info = (msg)->
  $.notify(
    icon: 'fa fa-check-circle'
    message: msg
  ,
    type: 'success'
  )
    
@DojoPanel = React.createClass
  componentDidMount: ->
    @heartbeat_timer = setInterval =>
      @player_channel?.perform 'heartbeat', name: @state.player_name
    , 500
    @player_channel = App.cable.subscriptions.create
      channel: 'PlayerChannel'
      keg: @props.player_keg
      name: @state.player_name
      dojo_id: @props.id
    ,
      connected: =>
      received: ({ step, error })=>
        if step
          action = ''
          script = @refs.script.get_value()
          try
            get_action = eval "_func = function () { \n#{script}\n }; _func()"
            if get_action
              action = get_action step
              action = String action
          catch e
            console.error e
            _error "Execution error: #{e.message}"
          @player_channel.perform('ai_action', { ai_action: action || '' })
        if error
          _error error
    @channel = App.cable.subscriptions.create
      channel: "DojoChannel"
      id: @props.id
    ,
      received: (data) =>
        console.info data.info if data.info
        if fire = data.fire
          @add_fire fire
        @setState data
  add_fire: (fire)->
    fire.id = "fire_#{Math.floor Math.random() * 1000}_#{Date.now()}"
    fire.opacity = 1
    @setState
      fires: [@state.fires..., fire]
    setTimeout =>
      if fire.direction % 2
        fire.position[1] += (fire.direction - 2) * @state.dojo.height
      else
        fire.position[0] -= (fire.direction - 1) * @state.dojo.width
      setTimeout =>
        fire.opacity = 0
        @forceUpdate()
      , 1000
    , 100
  componentWillUnmount: ->
    clearInterval @heartbeat_timer
    @player_channel.unsubscribe()
    @channel.unsubscribe()
  getInitialState: ->
    script_selecting: false
    player_name: faker.name.firstName()
    player_script: @props.scripts[0].content || ''
    script_title: @props.scripts[0].title
    fires: []
  render: ->
    w = $(@refs.dojo).width() || 500
    h = $(@refs.dojo).height() || 500
    div
      style:
        position: 'fixed'
        left: 0
        top: 53 # bootstrap navbar magic number
        right: 0
        bottom: 0
      div
        style:
          position: 'absolute'
          width: 480
          left: 10
          top: 10
          bottom: 10
        div
          style:
            display: 'flex'
            top: 0
            height: 50
            left: 0
            right: 0
            padding: '5px 0'
          div
            className: 'btn btn-default disabled'
            "Player: #{@state.player_name}"
          button
            className: 'btn btn-default'
            onClick: =>
              if new_name = prompt('Player name:', @state.player_name)
                @setState player_name: new_name
                @player_channel.perform('rename', new_name: new_name)
            i
              className: 'fa fa-fw fa-pencil'
            'Rename'
          button
            className: "btn btn-default #{'active' if @state.script_selecting}"
            onClick: (ev)=>
              @setState script_selecting: !@state.script_selecting
            i
              className: 'fa fa-fw fa-file-text'
            @state.script_title || 'Load script'
        div
          style:
            position: 'absolute'
            top: 50
            left: 0
            right: 0
            bottom: 0
          React.createElement AceEditor,
            ref: 'script'
            value: @state.player_script
          if @state.script_selecting
            div
              style:
                zIndex: 100
                position: 'absolute'
                top: 0
                left: 0
                right: 0
                bottom: 0
                backgroundColor: '#ccc'
                padding: 10
              @props.scripts.map (script)=>
                button
                  key: script.id
                  className: 'btn btn-default btn-block'
                  onClick: =>
                    @refs.script.set_value script.content
                    @setState
                      script_selecting: false
                      script_title: script.title
                  span
                    className: 'fa fa-fw fa-file-text'
                  script.title
      div
       ref: 'dojo'
       className: 'dojo_canvas'
       style:
         position: 'absolute'
         left: 500
         right: 0
         top: 0
         bottom: 0
        if @state.players
          div {},
            @state.players.map (player)=>
              x = (player.position[0] + 0.5) * w / @state.dojo.width
              y = (player.position[1] + 0.5) * h / @state.dojo.height
              rotate = - 90 * player.direction
              @_cache_player_rotate ||= {}
              if last_rotate = @_cache_player_rotate[player.id]
                if rotate - last_rotate > 180
                  rotate -= 360
                if rotate - last_rotate < - 180
                  rotate += 360
              @_cache_player_rotate[player.id] = rotate
              div
                key: player.id
                style:
                  position: 'absolute'
                  left: 0
                  top: 0
                  transform: "translate(#{x}px, #{y}px)"
                  transition: 'all ease .5s'
                  width: 0
                  height: 0
                  display: 'flex'
                  justifyContent: 'center'
                  alignItems: 'center'
                  color: player.color
                span
                  className: 'fa fa-fw fa-fighter-jet'
                  style:
                    transition: 'all ease .5s'
                    transform: "rotate(#{rotate}deg)"
                    fontSize: if player.alive then h / @state.dojo.height else '100vh'
                    opacity: if player.alive then 1 else 0
                span
                  style:
                    position: 'absolute'
                    left: '-2em'
                    top: '2em'
                    color: 'white'
                  player.title
            @state.ammos.map (ammo)=>
              x = (ammo.position[0] + 0.5) * w / @state.dojo.width
              y = (ammo.position[1] + 0.5) * h / @state.dojo.height
              div
                key: "ammo_#{ammo.id}"
                style:
                  position: 'absolute'
                  left: 0
                  top: 0
                  transform: "translate(#{x}px, #{y}px)"
                  width: 0
                  height: 0
                  display: 'flex'
                  justifyContent: 'center'
                  color: 'white'
                span
                  className: 'fa fa-fw fa-rocket'
                  style:
                    fontSize: '2em'
            @state.fires.map (fire)=>
              x = (fire.position[0] + 0.5) * w / @state.dojo.width
              y = (fire.position[1] + 0.5) * h / @state.dojo.height
              rotate = - 90 * fire.direction + 45
              div
                key: fire.id
                style:
                  position: 'absolute'
                  left: 0
                  top: 0
                  transition: 'all ease .2s'
                  transform: "translate(#{x}px, #{y}px) rotate(#{rotate}deg)"
                  opacity: fire.opacity
                  width: 0
                  height: 0
                  display: 'flex'
                  justifyContent: 'center'
                  alignItems: 'center'
                  color: 'yellow'
                span
                  className: 'fa fa-fw fa-rocket'
                  style:
                    fontSize: '2em'
        else
          div
            style:
              position: 'absolute'
              top: 0
              left: 0
              right: 0
              bottom: 0
              display: 'flex'
              justifyContent: 'center'
              alignItems: 'center'
            'loading...'

