'use strict'

class DartsDevice

  listener: null

  connect: (listener) ->
    @listener = listener

    peer = new Peer 'server', {host: 'localhost', port: 9999}
    conn = peer.connect 'device'

    conn.on 'open', ->
      conn.send 'Connected to a server.'

    conn.on 'data', (id) =>
      @listener? id

  disconnect: ->
    @listener = null;

window.DartsDevice = DartsDevice
