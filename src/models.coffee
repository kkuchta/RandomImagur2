RIW.Image = Backbone.Model.extend {
  initialize: ->
    console.log( "init image" )
  
}

RIW.ImageCollection = Backbone.Collection.extend {
  initialize: ->
    console.log( "init image collection" )
  sync: ->
    console.log( "collection sync" )
}
