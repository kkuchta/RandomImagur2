// Everything in here should have no side-effect (ie, utility functions) 



/**
 * Generates a random 5 character alphanumeric string (upper and lower case)
 * From http://stackoverflow.com/questions/1349404/generate-a-string-of-5-random-characters-in-javascript
 */
function makeid()
{
    var text = "";
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for( var i=0; i < 5; i++ ){
        text += possible.charAt(Math.floor(Math.random() * possible.length));
    }

    //console.log( 'id=' + text );
    return text;
}
