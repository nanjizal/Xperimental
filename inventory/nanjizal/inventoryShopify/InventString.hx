package nanjizal.inventoryShopify;

@:forward
abstract InventString( TInventString ) from TInventString to TInventString {
    public inline 
    function new( v: InventString ) {
        this = v;
    }
    public static inline
    function handleSort( a: InventString, b: InventString ):Int {
        var la = a.Handle.toLowerCase();
        var lb = b.Handle.toLowerCase();
        if ( la < lb) return -1;
        else if (la > lb) return 1;
        return 0;
    }
    @:to
    public inline
    function toString():String {
         return this.Handle 
            + ',' + this.Title
            + ',' + this.Option1_Name
            + ',' + this.Option1_Value
            + ',' + this.Option2_Name
            + ',' + this.Option2_Value
            + ',' + this.Option3_Name
            + ',' + this.Option3_Value 
            + ',' + this.SKU
            + ',' + this.Quantity + '\n';  
    }
    public inline
    function clone(): InventString {
        return {  Handle:        this.Handle 
                , Title:         this.Title
                , Option1_Name:  this.Option1_Name
                , Option1_Value: this.Option1_Value
                , Option2_Name:  this.Option2_Name
                , Option2_Value: this.Option2_Value
                , Option3_Name:  this.Option3_Name
                , Option3_Value: this.Option3_Value 
                , SKU:           this.SKU
                , Quantity:      this.Quantity
            };   
    }
}
typedef TInventString = {
    var Handle:        String;
    var Title:         String;
    var Option1_Name:  String;
    var Option1_Value: String;
    var Option2_Name:  String;
    var Option2_Value: String;
    var Option3_Name:  String;
    var Option3_Value: String;
    var SKU:           String;
    var Quantity:      String;
}