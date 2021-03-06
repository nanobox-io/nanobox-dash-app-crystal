class Crystal

  # ----------- API
  getRawImage : (seed, isHover) ->
    @draw seed, isHover
    return @getBitmapDataUrl()

  attachImage : (seed, isHover, holder, @height) ->
    @draw seed, isHover
    @getBitmap holder

  crystalize : (data)-> @attachImage data.uniqueNum, data.isHover, data.el, data.height


  # ----------- Meat

  draw : ( @seed = 135218, isHover=false ) ->
    @alreadyDrawn = false

    if @s?
      @s.graphics.clear()

    @s    = new createjs.Shape()
    @s.x  = 2
    @s.y  = 2
    @g    = @s.graphics

    color = if isHover then 0xFF0000 else 0x697C87

    # Draw the points
    @createRandomPointGrid(3,3,5)

    # Color
    pts = _.sortBy( @points, 'x');
    @drawShapesDescending pts, color, isHover
    @dimmensions = { x:pts[0].x, w:pts[8].x - pts[0].x }

    pts = _.sortBy( @points, 'y' );
    @drawShapesDescending pts, color, isHover
    @dimmensions.y = pts[0].y
    @dimmensions.h = pts[8].y - pts[0].y

    # White
    pts.reverse()
    @drawShapesDescending pts, 0xFFFFFF, isHover
    @drawShapesDescending pts, 0xFFFFFF, isHover

  createRandomPointGrid : (rows, cols, size=10) ->
    @points = []
    color = "#FFFFFF"
    jitter = 0.6
    @g.beginStroke null
    for i in [0...cols]
      for j in [0...rows]
        dir = if @randomNum(2*@seed - j - i + 3) > 0.1 then 1 else -1
        x = i*size + @randomNum(4 * @seed + 10 + j + i) * (size * jitter) * dir

        dir = if @randomNum(3*@seed + j + i + 2) > 0.1 then 1 else -1
        y = j*size + @randomNum(5 * @seed + j + i) * (size * jitter) * dir

        pt = new createjs.Point x, y
        @points.push pt
        @seed += Math.round(@seed / 2)

    randomIndex = Math.floor(@points.length * @randomNum(@seed))
    randomAxis  = if @randomNum(@seed*102) > 0.5 then 'x' else 'y'
    midPoint    = Math.round(rows*cols/2)

    # Create a jaggy point
    if randomIndex < midPoint
      @points[randomIndex][randomAxis] -= 2 + 1 * @randomNum(@seed*200)
    else
      @points[randomIndex][randomAxis] += 2 + 1 * @randomNum(@seed*200)

  drawShapesDescending : (pts, color=0xFFFFFF, isHover) ->
    fadeColor=true
    if color != 0xFFFFFF && isHover
      if @alreadyDrawn
        color = 0x1EB8FF
      else
        color = 0x1EB8FF

    @alreadyDrawn = true

    for i in [0...pts.length-3]
      if fadeColor
        opacity = i/pts.length+0.1
      else
        opacity = 1

      @g.beginFill( createjs.Graphics.getRGB(color, opacity) )
      @g.moveTo( pts[i].x, pts[i].y )
      @g.lineTo( pts[i+1].x, pts[i+1].y )
      @g.lineTo( pts[i+2].x, pts[i+2].y )
      @g.lineTo( pts[i+3].x, pts[i+3].y )
      @g.endFill()

  randomNum : (seed, min=0, max=1)->
    seed = (seed * 9301 + 49297) % 233280
    rnd = seed / 233280
    return min + rnd * (max - min)

  getBitmapDataUrl : () ->
    scaleFactor = 1

    scaleFactor = @height / @dimmensions.h
    sw = @dimmensions.w * scaleFactor
    sh = @dimmensions.h * scaleFactor

    @s.cache @dimmensions.x, @dimmensions.y, sw, sh, scaleFactor

    tempCanvas = new createjs.Bitmap @s.cacheCanvas
    tempCanvas.scaleX = tempCanvas.scaleY = 1/scaleFactor
    # @pawnDimmensions[bitmapId]  = {width:w, height:h, gridScale:s}
    # tempCanvas.regX = 10
    # tempCanvas.regY = 10
    @s.uncache()
    bitmap = tempCanvas.clone()

    # Create PNG
    canvas  = document.createElement("canvas")
    canvas.width  = sw
    canvas.height = sh
    ctx = canvas.getContext("2d")
    bitmap.draw(ctx)
    return canvas.toDataURL("image/png")

  getBitmap : ($holder) ->
    $holder.append("<img src='#{@getBitmapDataUrl()}' />")



window.nanobox ||= {}
nanobox.Crystal = Crystal
nanobox.crystals = new nanobox.Crystal()
###
Install the client
nanobox link <app-name>
nanobox build
nanobox deploy
###
