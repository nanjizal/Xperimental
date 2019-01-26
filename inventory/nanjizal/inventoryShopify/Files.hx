package nanjizal.inventoryShopify;
import nanjizal.inventoryShopify.InventoryAbstract;
import haxe.io.Path;
#if neko
import neko.vm.Module;
#end
class Files {
    /**
     *  used to load or save Inventory CSV files
     */
    public static var files = new Files();
    public static //inline
    function loadInventory( fileName: String ): InventoryAbstract {
        var inventory: InventoryAbstract = files.loadText( fileName );
        return inventory;
    } 
    public static inline
    function loadHandles( fileName: String ): HandleNames {
        var names: HandleNames = files.loadText( fileName );
        return names;
    }
    public static inline
    function saveInventory( fileName: String, inventory: InventoryAbstract ){
        files.saveText( fileName, inventory.toString() );
    }
    public 
    function saveText( fileName: String, str: String ){
        //Sys.println( 'save text ' + fileName );
        sys.io.File.saveContent( filePath( fileName ), str );
    }
    public 
    function loadText( fileName: String ){
        //Sys.println( 'load text ' + fileName );
        return sys.io.File.getContent( filePath( fileName ) );
    }
    public
    function filePath( fname: String ){
        return Path.join( [ dir, fname ] );
    }
    public var dir( get, never ): String;
    function get_dir(): String {
        #if neko
        var dir = Path.directory( Module.local().name );
        #else
        var dir = Path.directory( Sys.executablePath() );
        #end
        return dir;
    }
    public function new(){} // not used? 
}