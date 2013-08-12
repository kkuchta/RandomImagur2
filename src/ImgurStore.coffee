
class window.ImgurStore
  constructor: (@imageBufferSize = 30, @minWidth = 150, @kittenMode = false)->
    @imageList = []
    @fillCounter = 0
    @autoFillInterval = 50
    @nonExistantCounter = 0
    @totalCounter = 0

  enableAutoFill: ->
    @autoFillIntervalID = setInterval( @_autoFill, @autoFillInterval )
  disableAutoFill: ->
    clearInterval @autoFillIntervalID

  getImage: ->
    @imageList.pop()

  _autoFill: =>
    if @fillCounter == 0
      @_fillList()

  _fillList: ->
    i = @imageList.length
    while i < @imageBufferSize
      @fillCounter++
      i++
      @_fetchImage()

   _makeid: ->
    text = ""
    possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

    for i in [1..5]
      text += possible.charAt(Math.floor(Math.random() * possible.length))

    return text

  _fetchImage: ->
    recurseUntilSuccess = =>
      @_tryToGetImage().then (
        ($img) =>
          @imageList.unshift $img
          @fillCounter--
      ), (
        ->
          recurseUntilSuccess()
      )
    recurseUntilSuccess()

  _tryToGetImage: (success, failure)->
    url = 'http://i.imgur.com/' + @_makeid() + '.jpg'
    $img = $ "<img class='imgurImage' src='" + url + "'>"
    $deferred = $.Deferred()

    # Hide the image but still add it to the dom so the height/width load
    $img.css('position','absolute')
    $img.css('left','-10000px')
    $img.css('top','-10000px')
    $img.css('opacity','-10000px')
    $('body').append($img)
    $img.load (e) =>
      @totalCounter++
      if( ($img.width() == 161 && $img.height() == 81) || # kill non-existant images
          ($img.width() < @minWidth ) || # kill images smaller than 1 column
          ($img.width() < 25 || $img.height() < 25 ) )# kill super thin/tall images

        if $img.width() == 161 && $img.height() == 81
          @nonExistantCounter++

        $deferred.reject()
        $img.remove()
      else
        if( @kittenMode )
          @_makeKitten($img)
          $img.load =>
            $deferred.resolve($img)
        else
            $deferred.resolve($img)
    $deferred

  _makeKitten: ($img) ->
    width = $img.width()
    height = $img.height()
    while width >= 2000 || height >= 2000
        width = Math.floor width/2
        height = Math.floor height/2

    kittenURL = "http://placekitten.com/#{width}/#{height}"
    $img.attr 'src', kittenURL

