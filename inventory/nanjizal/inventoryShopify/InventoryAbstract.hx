package nanjizal.inventoryShopify;
import nanjizal.inventoryShopify.InventString;
import nanjizal.nodule.StringCodeIterator;
import haxe.ds.IntMap;
/**
 * InventoryAbstract is an abstract of an array of InventString and allows you to create an Inventory from strings.
 **/
@:forward
abstract InventoryAbstract( Array<InventString> ) from Array<InventString> to Array<InventString> {
    public inline 
    function new( ?v: Array<InventString> ) {
        if( v == null ) v = getEmpty();
        this = v; 
    }
    /** 
     * allows easier creation of InventoryAbstract
     **/
    public static inline 
    function getEmpty(){
        return new InventoryAbstract( new Array<InventString>() );
    }
    @:from
    public static // inline 
    function fromCSVString( str ): InventoryAbstract {
        var sl        = new StringCodeIterator( str );
        sl.next();
        var arr = new InventoryAbstract();
        var no = 0;
        var Handle:        String = '';
        var Title:         String = '';
        var Option1_Name:  String = '';
        var Option1_Value: String = '';
        var Option2_Name:  String = '';
        var Option2_Value: String = '';
        var Option3_Name:  String = '';
        var Option3_Value: String = '';
        var SKU:           String = '';
        var Quantity:      String = '';
        var count = 0;
        while( sl.hasNext() ){
            switch( sl.c ){
                case '\n'.code | '\r'.code:   
                    Quantity = sl.toStr();
                    arr[ no++ ] = { Handle:        Handle
                                  , Title:         Title
                                  , Option1_Name:  Option1_Name
                                  , Option1_Value: Option1_Value
                                  , Option2_Name:  Option2_Name
                                  , Option2_Value: Option2_Value
                                  , Option3_Name:  Option3_Name
                                  , Option3_Value: Option3_Value
                                  , SKU:           SKU
                                  , Quantity:      Quantity };
                    count = 0;
                    sl.resetBuffer();
                case ','.code: // case comma
                    switch( count ){
                        case 0:
                            Handle        = sl.toStr();
                        case 1:
                            Title         = sl.toStr();
                        case 2:
                            Option1_Name  = sl.toStr();
                        case 3:
                            Option1_Value = sl.toStr();
                        case 4:
                            Option2_Name  = sl.toStr();
                        case 5:
                            Option2_Value = sl.toStr();
                        case 6:
                            Option3_Name  = sl.toStr();
                        case 7:
                            Option3_Value = sl.toStr();
                        case 8:
                            SKU = sl.toStr();
                    }
                    count++;
                    sl.resetBuffer();
                default: // otherwise
                    sl.addChar();
            }
            sl.next();
        }
        arr[ no ] = { Handle: Handle
                    , Title: Title
                    , Option1_Name:  Option1_Name
                    , Option1_Value: Option1_Value
                    , Option2_Name:  Option2_Name
                    , Option2_Value: Option2_Value
                    , Option3_Name:  Option3_Name
                    , Option3_Value: Option3_Value
                    , SKU:           SKU
                    , Quantity:      Quantity };
        return arr;
    }
    @:to
    public inline
    function toString(): String {
        var str = '';
        var inventStr: String;
        for( i in 0...this.length ){ 
            inventStr = this[ i ];
            str       += inventStr;                
        }
        return str;
    }
    public inline
    function sortByHandle(){
        var firstLineIn = this.shift();
        haxe.ds.ArraySort.sort( this, InventString.handleSort );
        this.unshift( firstLineIn );
    }
    public inline
    function getByHandle( handle: String, sortFirst: Bool = false ){
        if( sortFirst ) sortByHandle();
        var out   = new InventoryAbstract();
        var no    = 0;
        var found = true;
        var item: InventString;
        for( i in 0...this.length ){
            item = this[ i ];
            if( item.Handle == handle ){
                found = true;
                out[ no++ ] = item.clone();
            } else {
                 if( sortFirst && found ) break;
            }
        }
        return out;
    }
    public inline
    function getByTitle( title: String, sortFirst: Bool = false ){
        if( sortFirst ) sortByHandle();
        var out   = new InventoryAbstract();
        var no    = 0;
        var found = false;
        var item: InventString;
        for( i in 0...this.length ){
            item = this[ i ];
            if( item.Title == title ){
                found = true;
                out[ no++ ] = item.clone();
            } else {
                if( sortFirst && found ) break;
            }
        }
        return out;
    }
    public inline
    function changeTitle( title: String, newTitle: String, sortFirst: Bool = false ){
        if( sortFirst ) sortByHandle();
        var found = false;
        var item: InventString;
        var changeCount = 0;
        for( i in 0...this.length ){
            item = this[ i ];
            if( item.Title == title ){
                found = true;
                item.Title = newTitle;
                changeCount++;
            } else {
                if( sortFirst && found ) break;
            }
        }
        return changeCount;  
    }
    public inline
    function changeQuantity( handle: String, qty: Int, size: String, ?color: String = '', ?sortFirst: Bool = false ){
        if( sortFirst ) sortByHandle();
        var found = true;
        var item: InventString;
        var changeCount = 0;
        for( i in 0...this.length ){
            item = this[ i ];
            if( item.Handle == handle ){
                found = true;
                if( item.Option1_Name == 'Size' && item.Option1_Value == size ){
                    if( color == '' ){
                        item.Quantity = Std.string( qty );
                        changeCount++;
                    } else if( item.Option2_Name == "Color"  && item.Option2_Value == color ){
                        item.Quantity = Std.string( qty );
                        changeCount++;
                    }
                }
            } else {
                 if( sortFirst && found ) break;
            }
        }
        return changeCount;
    }
    public inline
    function clone(){
        var out = new InventoryAbstract();
        var item: InventString;
        for( i in 0...this.length ){
            item = this[ i ];
            out[ i ] = item.clone();
        }
        return out;
    }
    public static inline
    function mergeHandlesInto(  inventoryIn:       InventoryAbstract
                             ,  inventoryModifier: InventoryAbstract
                             ,  handles: Array<String> ): InventoryAbstract {
        // create empty inventory
        var inventoryOut = new InventoryAbstract();
        // clone the inventory header line
        inventoryOut[ 0 ] = inventoryIn[ 0 ].clone();
        // make sure lines are in order
        inventoryIn.sortByHandle();
        //   folder.saveText( 'tempInventoryIn.csv', inventoryIn.toString() );
        // make sure lines are in order
        inventoryModifier.sortByHandle();
        
        // get positions of handles
        var posIn = new Array<Int>();
        var posMod = new Array<Int>();
        var h;
        var intMap = new IntMap<Int>();
        var saveP = -1;
        for( j in 0...handles.length ){
            h = handles[ j ];
            saveP = -1;
            for( i in 0...inventoryIn.length ){
                if( h.toLowerCase() == inventoryIn[ i ].Handle ){
                    trace( 'found ' + h );
                    saveP = i;
                    break;
                }
            }
            for( i in 0...inventoryModifier.length ){
                if( h.toLowerCase() == inventoryModifier[ i ].Handle ){
                    trace( 'found_ ' + h );
                    intMap.set( saveP, i );
                    break;
                }
            }
        }
        var i         = 1;
        var aHandle   = '';
        var aTitle    = '';
        var inventStrIn:  InventString;
        var inventStrMod: InventString;
        var processed = 0;
        var handlesProcessed = new Array<String>();
        var j         = 1;
        var k:        Int;
        var hasSize:  Bool;
        var hasColor: Bool;
        var qty;
        while( i < inventoryIn.length ) {
            // if inventoryIn is handle to modify
            if( intMap.exists( i ) ){
                // current Handle
                inventStrIn = inventoryIn[ i ];
                aHandle     = inventStrIn.Handle;
                aTitle      = inventStrIn.Title;
                handlesProcessed[ processed++ ] = aHandle;
                k = intMap.get( i );
                // add in the values from inventoryMod
                while( true ){
                    inventStrMod = inventoryModifier[ k++ ];
                    if( inventStrMod.Handle.toLowerCase() == aHandle.toLowerCase() ){ 
                        
                        inventoryOut[ j++ ] = {  Handle: aHandle
                                              ,  Title:  aTitle
                                              ,  Option1_Name:  inventStrMod.Option1_Name
                                              ,  Option1_Value: inventStrMod.Option1_Value
                                              ,  Option2_Name:  inventStrMod.Option2_Name
                                              ,  Option2_Value: inventStrMod.Option2_Value
                                              ,  Option3_Name:  inventStrMod.Option3_Name
                                              ,  Option3_Value: inventStrMod.Option3_Value
                                              ,  SKU:           inventStrMod.SKU
                                              ,  Quantity:      inventStrMod.Quantity };
                    } else {
                        break;
                    }
                    if( k > inventoryModifier.length ) break;
                }
                // increment i to end of section that needs replacing.
                while( i < inventoryIn.length ){
                    if( inventoryIn[ i++ ].Handle != aHandle ){
                        i--;
                        break;
                    }
                }
            } else {
                // if does not need adjusting
                inventoryOut[ j++ ] = inventoryIn[ i ];
                i++;
            }
        }
        trace( 'processed ' + handlesProcessed );
        return inventoryOut;
    }
}