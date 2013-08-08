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
      return
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
      @$img = @model.get('$img')
      @$img.addClass('original-img')

    render: ->
      @$el.append @$img
      @$img.width @_idealWidth( @model.get('naturalWidth') )
      @$img.append @getClone()
      @

    getClone: =>
      unless @$clone
        @$clone = $ '<img>'
        @$clone.attr 'src', @$img.attr('src')
        @$clone.load( => @positionClone() )
      @$clone

    positionClone: ->

        position = @$img.position()
        @$clone.css('position', 'absolute')
        @$clone.css('left', position.left)
        @$clone.css('top', position.top)
        @$clone.css('max-height', 900)
        @$clone.css('max-width', 900)
        @$clone.css('z-index', 1)
        @$clone.removeClass('original-img')
        @$clone.addClass('clone-img')

        originalRect = @$img[0].getBoundingClientRect()

        cloneWidth = Math.min(@$clone.prop('width'), 900)
        originalWidth = @$img.prop('width')
        pageWidth = $(document).width()

        if originalRect.left + cloneWidth > pageWidth
          console.log( 'expand left' )
          newLeft = (cloneWidth - originalWidth) * -1
          @$clone.css('left', newLeft)

    
    showLarge: ->
      console.log( 'onclick' )
      clone = @getClone()
      @$el.append(@$clone)
      clone.show()
    hideLarge: ->
      console.log( '2onclick' )
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
