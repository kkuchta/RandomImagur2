var ImgurImage = function($img, $container){

    this.$img = $img;
    this.$container = $container;

};

ImgurImage.prototype = {
    display: function(useKittens){
        
        var $img = this.$img;
        $img.css('float','left');
        this.$container.append($img);

        if( controls.kittens.getChecked() ){
            var width = $img.prop('width');
            var height = $img.prop('height');
            var kittenSize = getKittenSize({width:width,height:height});
            var kittenURL = 'http://placekitten.com/' + kittenSize.width + '/' + kittenSize.height;
            $img.attr('src',kittenURL);
        }
        setImageSize( $img );
    }
};


// Gets a valid jquery image object
ImgurImage.createRandom = function($container,callback){

    // Load an image and check its size (recursive because we have to wait on
    // the image loaded callback)
    var tryImage = function(){
        var url = 'http://i.imgur.com/' + makeid() + '.jpg';
        var $img = $("<img class='imgurImage' src='" + url + "'>");

        // Hide the image but still add it to the body so the height/width load
        $img.css('position','absolute');
        $img.css('left','-10000px');
        $img.css('top','-10000px');
        $img.css('opacity','-10000px');
        $('body').append($img);
        $img.load(function(){
            if(
                (this.width == 161 && this.height == 81) || // kill non-existant images
                (this.width < COLUMN_WIDTH ) || // kill images smaller than 1 column
                (this.width < 25 || this.height < 25 ) // kill super thin/tall images
            ){
                console.log('gotbadimage');
                $img.remove();
                tryImage();
            }
            else{
                console.log("success");
                $img.css('position','relative');
                $img.css('left','0');
                $img.css('top','0');
                $img.detach();

                var newImage = new ImgurImage($img, $container);
                callback(newImage);
            }
        });
    };
    tryImage();
};
