#window.Backbone.sync = (method,model,options) ->
  #console.log( "Backbone sync" )
  #if method == 'create' || method == 'update' || method == 'delete'
    #throw "Stahp- shouldn't do anything besides read"
  
  #options.success([{name:'image'}])
$ ->
  class RIW.Wall extends Backbone.View
    el: $('#image-container')
    template: _.template($('#wall-template').html())
    batchSize: 5

    initialize: (options) =>
      @collection = new RIW.ImageCollection
      @controlBox = new RIW.ControllBox
      @listenTo( @collection, 'add', @onNewImage )
      $(window).scroll(@onScroll);
      @render()

    render: =>
      @$el.masonry
        itemSelector: '.image'
        columnWidth : COLUMN_WIDTH
      @

    onNewImage: (newImage) =>
      newView = new RIW.ImageView( {model:newImage} ).render()

      @$el.append( newView.el )
      @$el.masonry( 'appended', newView.el )
    onScroll: =>
      if !@loading && $(window).scrollTop() >= $(document).height() - $(window).height() - 200
        console.log "Loading now..." + @batchSize
        @loading = true
        finishLoading = _.after( @batchSize,
          ( (rndID) =>
            console.log "After called"
            @loading = false
          )
        )
        for j in [0..@batchSize-1]
          window.RIW.App.collection.fetch(
            (rndID) =>
              console.log ("Finishd #{rndID}")
              finishLoading()
          )
  
  class RIW.ImageView extends Backbone.View
    template: _.template($('#image-view-template').html())
    className: 'image'
    MAX_COLUMNS: 3

    events:
      'click .original-img': 'showLarge'
      'click .clone-img': 'hideLarge'

    initialize: ->
      @id = window.imgCount++
      @$img = @model.get('$img')
      @$img.addClass('original-img')

    render: ->
      @$el.append @$img
      @$img.width @_idealWidth( @model.get('naturalWidth') )
      @

    getClone: =>
      unless @$clone
        @$clone = $ '<img>'
        @$clone.attr 'src', @$img.attr('src')
        @$clone.addClass('clone-img')
        @$clone.load( => @positionClone() )
      @$clone

    positionClone: ->

      # The layout engine messes with heights, so lets put it back
      @$clone.css('max-height', 900)
      @$clone.css('max-width', 900)

      originalRect = @$img[0].getBoundingClientRect()
      cloneWidth = @$clone.prop('width')
      originalWidth = @$img.prop('width')

      # Temporarily shrink so we can measure the document width
      @$clone.css('max-height', 1)
      @$clone.css('max-width', 1)
      
      pageWidth = $(document).width()

      @$clone.css('position', 'absolute')
      @$clone.css('left', 0)
      @$clone.css('top', 0)
      @$clone.css('max-height', 900)
      @$clone.css('max-width', 900)
      @$clone.css('z-index', 1)

      if originalRect.left + cloneWidth > pageWidth
        console.log( 'expand left' )
        newLeft = (cloneWidth - originalWidth) * -1
        @$clone.css('left', newLeft)

    
    showLarge: ->
      console.log( 'showLarge' )
      clone = @getClone()
      @$el.append(@$clone)
      clone.show()
    hideLarge: ->
      console.log( 'hideLarge' )
      @getClone().hide()



    # Snap width a grid line width (always rounding down)
    _idealWidth: ( naturalWidth, maxGridLines ) ->
      for i in [0..@MAX_COLUMNS]
        if( naturalWidth > i * COLUMN_WIDTH && naturalWidth <= (i+1) * COLUMN_WIDTH )
          return (i) * COLUMN_WIDTH
      return @MAX_COLUMNS * COLUMN_WIDTH

  window.RIW.App = new RIW.Wall
  for i in [0..10]
    window.RIW.App.collection.fetch()

class RIW.ControllBox extends Backbone.View

window.imgCount = 0
