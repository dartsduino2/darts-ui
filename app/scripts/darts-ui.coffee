'use strict'

Polymer 'darts-ui',
  POINTS: [20, 1, 18, 4, 13, 6, 10, 15, 2, 17, 3, 19, 7, 16, 8, 11, 14, 9, 12, 5]
  FOCUS_CLASS: 'darts-focus'

  centerX: null
  centerY: null
  radius: null

  ready: ->
    @width = @.clientWidth || parseInt @.getAttribute('width')
    @height = @.clientHeight || parseInt @.getAttribute('height')
    @centerX = @width / 2
    @centerY = @height / 2
    @radius = Math.min(@centerX, @centerY) - 2

    @draw()

    @device = new DartsDevice()
    @device.connect @onHit.bind(@)

  draw: ->
    s = new Snap @.$.darts

    @drawCircle s, 'darts-base', 'base', @radius

    @drawRings s, 'darts-cell darts-high-ring', '2',   @radius * 0.75, @radius * 0.04
    @drawRings s, 'darts-cell darts-single',    '1-o', @radius * 0.60, @radius * 0.25
    @drawRings s, 'darts-cell darts-high-ring', '3',   @radius * 0.45, @radius * 0.04
    @drawRings s, 'darts-cell darts-single',    '1-i', @radius * 0.25, @radius * 0.35

    @drawCircle s, 'darts-cell darts-bull darts-bull-outer', '25-1', @radius * 0.1
    @drawCircle s, 'darts-cell darts-bull darts-bull-inner', '25-2', @radius * 0.05

    @drawPoints s, 'darts-point', @radius * 0.88

  drawCircle: (s, className, key, radius) ->
    circle = s.circle @centerX, @centerY, radius
    circle.attr
      class: className
      id: key

  drawRings: (s, className, key, radius, strokeWidth) ->
    rings = s.g()

    for p, i in @POINTS
      angle0 = (i * 18 - 9) * Math.PI / 180
      angle1 = (i * 18 + 9) * Math.PI / 180
      x0 = @centerX + radius * Math.sin angle0
      y0 = @centerY - radius * Math.cos angle0
      x1 = @centerX + radius * Math.sin angle1
      y1 = @centerY - radius * Math.cos angle1

      ring = s.path 'M' + x0 + ' ' + y0 + ' A' + radius + ' ' + radius + ' 0 0 1 ' + x1 + ' ' + y1
      ring.attr
        class: className
        strokeWidth: strokeWidth
        id: p + '-' + key

      rings.append ring

  drawPoints: (s, className, radius) ->
    points = s.g().attr {class: 'points'}

    for p, i in @POINTS
      angle = (i * 18) * Math.PI / 180
      x = @centerX + radius * Math.sin angle
      y = @centerY - radius * Math.cos angle

      point = s.text x, y, p
      point.attr
        class: className
        fontSize: radius * 0.16
        dy: radius * 0.06

      points.append point

  focusesChanged: (oldFocuses, newFocuses) ->
    if oldFocuses?.length > 0
      for focus in oldFocuses.split ' '
        element = @.$.darts.getElementById focus
        element.classList.remove @FOCUS_CLASS if element?

    if newFocuses?.length > 0
      for focus in newFocuses.split ' '
        element = @.$.darts.getElementById focus
        element.classList.add @FOCUS_CLASS if element?

  onClick: (event) ->
    id = event.target.id
    @onHit id

  onHit: (id) ->
    @focuses = id

    [point, ratio] = id.split '-'
    @fire 'hit', {point, ratio} if ratio?
