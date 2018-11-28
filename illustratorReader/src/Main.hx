package;
import folder.Folder;
import StringCodeIterator;
@:enum
abstract NoKey( Int ) to Int from Int {
    var backspace = 8;
    var tab = 9;
    var enter = 13;
    var shift = 16;
    var ctrl = 17;
    var alt = 18;
    var pause =	19;
    var capslock = 20;
    var escape = 27;
    var leftwindow = 91;
    var rightwindow = 92;
    var selectkey = 93;
    var numlock = 144;
    var cmd = 224;
    var andQuote = 34;
}
class Main {
    public function out( d: Dynamic ){
        #if sys
            Sys.println( d );
        #else
            trace( d );
        #end
    }
    var folder: Folder;
    public static function main(){ new Main(); } public function new(){
        folder = new Folder();
        var str = folder.loadText( 'arm0.ai' );
        process( str );
    }
    public function process( str_: String ){
        var lineCount = 0;
        var contentBuf = new StringBuf();
        var strIter = new StringCodeIterator( str_ );
        var s:String;
        var i: Int = 0; // letter count
        var j: Int = 'Adobe'.length;
        var last: Int = 0;
        var path: String = '';
        while( strIter.hasNext() ){
            switch( strIter.c ){
                case '\n'.code | '\r'.code:
                    lineCount++;
                    if( i > 1 ){ // ignore single character
                        switch( last ){
                            case 'k'.code:
                                out( 'color ' +  convertColor( strIter.toStr().substr( 0, i - 2 ) ) );
                            case 'L'.code:
                                path = path + ' L ' + strIter.toStr().substr( 0, i - 2 );
                            case 'm'.code:
                                path = path + 'm ' +  strIter.toStr().substr( 0, i - 2 );
                            case 'C'.code:
                                path = path + ' C ' + strIter.toStr().substr( 0, i - 2 );
                            case _:
                                // ignore
                        }
                    }
                    i = 0;
                    strIter.resetBuffer();
                case      backspace 
                        | shift 
                        | ctrl 
                        | alt 
                        | pause 
                        | leftwindow 
                        | rightwindow 
                        | selectkey 
                        | numlock 
                        | cmd 
                        | 143 
                        | null:
                    //ignore
                case '%'.code:
                    // most lines have %% and might as well ignore.
                    while( strIter.hasNext() ){
                        switch( strIter.c ){
                            case '\n'.code | '\r'.code:
                                lineCount++;
                                break;
                            case _:
                        }
                        strIter.next();
                    }
                case _:
                    i++;
                    strIter.addChar();
                    if( i == j ){
                        // ignore lines with "Adobe" in.
                        var s = strIter.toStr();
                        if( s == "Adobe" ){
                            // reset letter count
                            i = 0;
                            // clear "Adobe from buffer"
                            strIter.resetBuffer();
                            while( strIter.hasNext() ){
                                switch( strIter.c ){
                                    case '\n'.code | '\r'.code:
                                        lineCount++;
                                        break;
                                    case _:
                                }
                                strIter.next();
                            }
                        }
                    }
            }
            last = strIter.c;
            strIter.next();
        }
        // out( 'file has ' + lineCount );
        out( path + 'z' );
        path = path+'z';
        folder.saveText( 'data.path', path );
    }
    // https://www.ginifab.com/feeds/pms/cmyk_to_rgb.php
    public function convertColor( str: String ){
        var arr     = str.split(' ');
        var cyan    = Std.parseInt( arr[0] );
        var magenta = Std.parseInt( arr[1] );
        var yellow  = Std.parseInt( arr[2] );
        var black   = Std.parseInt( arr[3] );
        var red = Math.round( 255 * ( 1 - cyan / 100 ) * ( 1 - black / 100 ) );
        var green = Math.round( 255 * ( 1 - magenta / 100 ) * ( 1 - black / 100 ) );
        var blue = Math.round( 255 * ( 1 - yellow / 100 ) * ( 1 - black / 100 ) );
        return red << 16 | green << 8 | blue;
    }
}



/*    
case 'l'.code:
case 'H'.code:
case 'h'.code:
case 'V'.code:
case 'v'.code:
case 'C'.code:
case 'c'.code:
case 'S'.code:
case 'Q'.code:
case 'q'.code:
case 'T'.code:
case 't'.code:
case 'A'.code:
case 'a'.code:
*/
