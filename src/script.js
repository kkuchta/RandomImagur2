// Width of the columns of images, which will be resized to be a multiple of this
var COLUMN_WIDTH = 150;

$( function(){
    $(document).on('mouseenter', '.imgurImage', null, hoverHandler); 
    $('#images').masonry({
        columnWidth : COLUMN_WIDTH,
        isAnimated: true
    });

    $('#bottomOfImages').waypoint(function(){
        addImages(10);
    },{
        offset: '100%'
    });

    controls.bindEvents();
    controls.restoreState();
    //addImages(10);
} );

function addImages( countToLoad ){
    var countLoaded = 0;
    var container = $('#images');

    for( var i = 0; i < countToLoad; i++ ){
        ImgurImage.createRandom( container, function(imgurImage){
            //displayImage(imgurImage);
            imgurImage.display();
            $('#images').masonry( 'appended', imgurImage.$img, true );

            countLoaded++;
            if( countLoaded >= countToLoad ){
                console.log('finished!');
                $.waypoints('refresh');
            }
        });
    }
}

function hoverHandler( e ){
    var $imgClone = null;
    $img = $(this);
    var killClone = function(){
        $imgClone.remove();
        //$img.off( 'mouseout', killClone );
        //$img.css('opacity','1');
        $img.css('visibility','');
    };

    // Clone the image at full size
    $imgClone = $('<img>');
    $imgClone.css('position','absolute');
    $imgClone.attr('src',$img.attr('src'));
    var position = $img.position();

    $imgClone.css('left', position.left);
    $imgClone.css('top', position.top);
    $imgClone.css('max-height', 900);
    $imgClone.css('max-width', 900);

    $img.css('visibility','hidden');
    $imgClone.mouseout(killClone);
    $('#images').append($imgClone);

    var cloneWidth = Math.min($imgClone.prop('width'), 900);
    var smallWidth = $img.prop('width');
    var imagesDivWidth = $('#images').width();

    if( position.left + cloneWidth > imagesDivWidth ){
        console.log( 'expand left' );
        var newLeft = position.left - (cloneWidth - smallWidth);
        $imgClone.css('left', newLeft);
    }
}


// Expects {width:123,height:123}
function getKittenSize( rawSize ){
    var width = rawSize.width;
    var height = rawSize.height;
    while( width >= 2000 || height >= 2000 ){
        width = Math.floor(width/2);
        height = Math.floor(height/2);
    }
    return {height:height,width:width};
}


function setImageSize($img){
    var width = $img.prop('width');
    var newWidth = fixWidth( width, COLUMN_WIDTH, 3 );
    $img.css('width',newWidth);
    var height = $img.css('max-height',1000);
}

/**
 * Snap width a grid line width (always rounding down)
 */
function fixWidth( width, gridWidth, maxGridLines ){
    for( var i=1; i < maxGridLines; i++ ){
        if( width > i * gridWidth && width <= (i+1) * gridWidth ){
            return (i) * gridWidth;
        }
    }
    return maxGridLines * gridWidth;
}

var controls = (function(){
    var $container = $('#controls');

    var $kittenButton = $container.find('.kittens');

    var saveState = function(){
        console.log('saving control state');
        var kittenChecked = pub.kittens.getChecked();
        console.log( 'kitten checked = ' + kittenChecked );
        localStorage.setItem( 'kittenButton', kittenChecked );
    };

    var pub = {
        kittens: {
            getChecked: function(){
                return $('.kittens').prop('checked');
            },
            setChecked: function( checked ){
                $('.kittens').prop('checked', checked );
            }
        },

        // Sets up the click events
        bindEvents: function(){
            $kittenButton.change(function(){
                saveState();
            });

        },

        restoreState: function(){
            console.log('restoring state');
            var kittenChecked = (localStorage.getItem( 'kittenButton' ) === 'true');
            console.log( 'kitten checked = ' + kittenChecked );
            pub.kittens.setChecked( kittenChecked );
        }
    };
    return pub;
})();
