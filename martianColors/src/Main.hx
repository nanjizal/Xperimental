package;
import trilateralXtra.color.MartianColours;
import hxPixels.Pixels;
class Main {
    public static function main(){
        new Main();
    }
    public function new(){
        trace( 'main' );
        var pixels: Pixels = new Pixels( 500, 500, true );
        var centreX = 250;
        var centreY = 250;
        var radius = 200;
        for( i in 0...500 ) for( j in 0...500 ) pixels.setPixel32( i, j, 0xFFFFFFFF );
        for( degrees in 0...3600 ){
            var rad = degrees*Math.PI/1800;
            for( r in 0...radius ){
                var strength = r/radius;
                var col = MartianColours.getColor( rad, strength );
                var x = Std.int( centreX + r*Math.sin( rad ) );
                var y = Std.int( centreY + r*Math.cos( rad ) );
                //trace( x + ' ' + y + '  ' + col );
                pixels.setPixel32( x, y, 0xF0000000 + col );
            }
        }
        
        writeModifiedPNG( pixels, 'martianColors' );
    }
    public function writeModifiedPNG( pixels: Pixels, fileName: String ) {
        #if neko
        var dir = haxe.io.Path.directory(neko.vm.Module.local().name);
        #else
        var dir = haxe.io.Path.directory(Sys.executablePath());
        #end
        var outputFileName = fileName + ".png";
        var file = sys.io.File.write(haxe.io.Path.join( [ dir, outputFileName ] ), true );
        var pngWriter = new format.png.Writer( file );
        pixels.convertTo( PixelFormat.ARGB );
        var pngData = format.png.Tools.build32ARGB( pixels.width, pixels.height, pixels.bytes );
        pngWriter.write( pngData );
    }
}