$ ->
  RIW.Image = Backbone.Model.extend
    initialize: ( options ) ->
      @$img = options.$img
      this.set 'naturalWidth', @$img.width()
      this.set 'naturalHeight', @$img.height()
      @$img.remove()
      @$img.detach()
      @$img.css 'position','relative'
      @$img.css 'left','0'
      @$img.css 'top','0'

    clone: ->


  RIW.ImageCollection = Backbone.Collection.extend
    model: RIW.Image
    initialize: (arr, options) ->
      @store = options.store
      @store.enableAutoFill()
      @toFetch = 0
    parse: ($img) ->
      return {
        '$img': $img
      }

    fetch: (success) ->

      rndID = Math.random()
      @toFetch++
      fetchWaitTime = 100
      totalWaitTime = 0

      processImage = (newImage) =>
        @add @parse( newImage )
        if _.isFunction( success )
          success rndID

      newImage = @store.getImage()
      if newImage
        processImage( newImage )
      else
        intervalID = setInterval ( =>
          totalWaitTime += fetchWaitTime
          newImage = @store.getImage()

          if newImage
            processImage( newImage )
            clearInterval intervalID

          else if totalWaitTime > 100000
            console.log "Wtf- we've been trying to get an image for more than 10 seconds."
            clearInterval intervalID
            @fetching = false
        ), fetchWaitTime
