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
      
      #@$el.append @template()
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

    initialize: ->
      @$img = @model.get('$img')

    render: ->
      @$el.append @$img
      @$img.width( @_idealWidth( @model.get('naturalWidth') ) )
      @

    # Snap width a grid line width (always rounding down)
    _idealWidth: ( naturalWidth, maxGridLines ) ->
      for i in [0..@MAX_COLUMNS]
        if( naturalWidth > i * COLUMN_WIDTH && naturalWidth <= (i+1) * COLUMN_WIDTH )
          return (i) * COLUMN_WIDTH
      return @MAX_COLUMNS * COLUMN_WIDTH

  window.RIW.App = new RIW.Wall
  for i in [0..10]
    window.RIW.App.collection.fetch()
