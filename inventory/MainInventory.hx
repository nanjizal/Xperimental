package;
import nanjizal.inventoryShopify.Merger;
class MainInventory{
    public static function main(){ 
        var args = Sys.args();
        Merger.mergeHandlesInto( args[0]
                               , args[1]
                               , args[2]
                               , args[3] );
    }
}