package nanjizal.inventoryShopify;
import nanjizal.inventoryShopify.InventoryAbstract;
import nanjizal.inventoryShopify.Files;

using nanjizal.inventoryShopify.Files;
class Merger {
    public static //inline 
    function mergeHandlesInto(  fileIn:       String
                             ,  fileModifier: String
                             ,  fileHandles:  String
                             ,  saveFile:     String )
        {          
        saveFile.saveInventory( InventoryAbstract.mergeHandlesInto
                            (  
                               fileIn.loadInventory()
                            ,  fileModifier.loadInventory()
                            ,  fileHandles.loadHandles()
                            ) );
    }
    //public function new(){} // not used? 
}