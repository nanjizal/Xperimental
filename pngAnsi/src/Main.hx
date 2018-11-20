package;
import hxPixels.Pixels;
import folder.Folder;
import ANSI;
@:enum
@:forward
abstract CharSet( String ) from String to String {
    var CharSimple = " .:-=+*#%@";
    var CharComplex = " .'`^" + '",:;Il!i><~+_-?][}{1)(|' +'\\' + '/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$█';
}
class Main{
    var folder = new Folder();
    static function main(){ new Main(); } public function new(){
        var images = folder.getImages( './' );
        var pixels: Pixels = new Pixels( 100, 100, true );
        var fileName = 'haxe.png';
        var scaleFactor = 0.7;
        for( img in images ) if( img.fileSpec.name == fileName ) pixels = img.pixels;
        initScreen();
        luminosityGrey( pixels, CharSimple, scaleFactor );
    }
    public inline function luminosityGrey( pixels: Pixels, charSet: CharSet, scaleFactor: Float = 1. ){
        var p: Pixel;
        var w = pixels.width;
        var h = pixels.height;
        var brightness = charSet;
        var l: Float;
        var toggle = true;
        var scale = brightness.length;
        ANSI.set( White );
        var str = '';
        w = Std.int( Math.min( w*scaleFactor, 99 ) );
        h = Std.int( Math.min( h*scaleFactor, 84 ) );
        var r: Bool;
        var b: Bool;
        var g: Bool;
        var c: Float;
        var color = White;
        for( x in 0...w ){
            if( toggle ){ // skip rows
                for( y in 0...h ){
                    p = pixels.getPixel32( Math.round( x/scaleFactor ), Math.round( y/scaleFactor ) );
                    l = p.fA*( 0.21*p.fR + 0.72*p.fG + 0.07*p.fB ) * scale;
                    r = ( p.fR > ( 0.3 - 0.21/2 ) ); // adjust these to create different colored images
                    g = ( p.fG > ( 0.3 - 0.72/2 ) );
                    b = ( p.fB > ( 0.3 - 0.07/2 ) );
                    color = White;
                    if( r && b && g ){
                        color = White;
                    } else {
                        if( !r && !g && !b ){
                            color = Black;
                        } else {
                            if( r ){
                                if( g ){
                                    color = Yellow;
                                } else if( b ){
                                    color = Magenta;
                                } else {
                                    color = Red;
                                }
                            } else if( g ){
                                if( b ){
                                    color = Cyan;
                                } else { 
                                    color = Green;
                                }
                            } else {
                                color = Blue;
                            }
                        }
                    }
                    str += xy( x + 1, y/2 + 1 ) + ANSI.set( color ) + brightness.charAt( Std.int( Math.round( l ) ) );
                }
            }
            toggle = !toggle;
        }
        str += xy( 0, Math.round( h/2 ) + 1 );
        str += ANSI.set( White );
        out( str );
    }
    function initScreen(){
        out( ANSI.title("Output") );
        out( clear() );
        out( ANSI.set( BlackBack ) );
    }
    inline
    function xy( x: Float, y: Float ){
        return ANSI.setXY( Std.int( x ), Std.int( y ) );
    }
    function clear(){
        return ANSI.eraseDisplay();
    }
    inline
    function out( s: String = "") {
        #if sys
            Sys.stdout().writeString( s + "\n" );
        #else
            trace( s );
        #end
    }
}
