#window.Backbone.sync = (method,model,options) ->
  #console.log( "Backbone sync" )
  #if method == 'create' || method == 'update' || method == 'delete'
    #throw "Stahp- shouldn't do anything besides read"
  
  #options.success([{name:'image'}])
$ ->
  class RIW.Wall extends Backbone.View
    $el: $('#image-container')
    template: _.template($('#wall-template').html())

    initialize: (options) ->
      #super(options)
      @collection = new RIW.ImageCollection
      @collection.fetch()

    render: =>
      console.log "Rendering wall"
      @$el.append(this.template(this.model))

  #window.RIW.images = new RIW.ImageCollection
  window.RIW.App = new RIW.Wall
