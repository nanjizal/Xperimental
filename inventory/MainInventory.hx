package;
import nanjizal.inventoryShopify.Merger;
class MainInventory{
    public static function main(){ 
        var args = Sys.args();
        Merger.mergeHandlesInto( args[0]      // inventory file to change
                               , args[1]      // inventory file with products to copy over
                               , args[2]      // 'handles' or products that should be copied over
                               , args[3] );   // file to save new inventory to
    }
}
