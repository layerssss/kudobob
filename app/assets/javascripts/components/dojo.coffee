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
} = React.DOM
@Dojo = React.createClass
  componentDidMount: ->
    @player_channel = App.cable.subscriptions.create
      channel: 'PlayerChannel'
      keg: @props.player_keg
      dojo_id: @props.id
    ,
      connected: =>
        setInterval =>
          @player_channel.perform 'heartbeat'
        , 300
      received: (player)=>
        @setState { player }
    @channel = App.cable.subscriptions.create
      channel: "DojoChannel"
      id: @props.id
    ,
      received: (data) =>
        @setState data
  getInitialState: -> {}
  render: ->
    div {},
      if @state.player
        p {}, "me: #{@state.player.name}"
      p {}, "players:"
      if @state.players
        ul {},
          @state.players.map (player)=>
            li
              key: player.id
            , "#{player.name}"
      else
        p {}, 'loading...'

