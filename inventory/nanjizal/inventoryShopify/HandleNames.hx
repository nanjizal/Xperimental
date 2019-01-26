package nanjizal.inventoryShopify;
import nanjizal.nodule.StringCodeIterator;
/**
 * HandleNames is an abstract of an array of String used for inventory handles.
 **/
@:forward
abstract HandleNames( Array<String> ) from Array<String> to Array<String> {
    public inline 
    function new( ?v: Array<String> ) {
        if( v == null ) v = getEmpty();
        this = v; 
    }
    /** 
     * allows easier creation of HandleNames
     **/
    public static inline 
    function getEmpty(){
        return new HandleNames( new Array<String>() );
    }
    /** 
     * sort function ideal if inventory has been sorted.
     **/
    public static inline
    function sort( a: String, b: String ):Int {
        var la = a.toLowerCase();
        var lb = b.toLowerCase();
        if ( la < lb) return -1;
        else if (la > lb) return 1;
        return 0;
    }
    /**
     * optimized fromString to extract handle names from a string
     */
    @:from
    public static inline
    function fromString( str: String ): HandleNames {
        var s         = new StringCodeIterator( str );
        s.next();
        var arr = new HandleNames();
        var no = 0;
        while( s.hasNext() ){
            switch( s.c ){
                case '\n'.code | '\r'.code:   // ignore new lines
                    arr[ no++ ] = s.toStr();
                    s.resetBuffer();
                case ','.code:
                    arr[ no++ ] = s.toStr();
                    s.resetBuffer();
                default: // otherwise
                    s.addChar();
            }
            s.next();
        }
        arr[ no ] = s.toStr();
        // sort for quicker parsing
        haxe.ds.ArraySort.sort( arr, HandleNames.sort );
        return arr;
    }
}