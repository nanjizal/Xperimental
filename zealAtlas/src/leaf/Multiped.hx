package leaf;
import leaf.Leaf;
import hxRectPack2D.output.BodyFrames;
typedef MultipedNode = {
      name:   String
    , top:    TopNode
    , leaves: Array<LeafNode>
}
typedef TopNode = {
    > LeafNode
    , x: Float
    , y: Float
}
typedef LeafNode = {
      name:         String
    , texture:      String
    , parentName:   String
    , ox:           Float
    , oy:           Float
    , cx:           Float
    , cy:           Float
    , rotation:     Float
}
class Multiped {
    public var leaves = new Array<Leaf>();
    var multi: MultipedNode;
    var bodyFrames: BodyFrames;
    public var topLeaf: Leaf;
    public function new( x: Float, y: Float, multi_: MultipedNode, bodyFrames_: BodyFrames ){
        multi = multi_;
        bodyFrames = bodyFrames_;
        parse( x, y );
    }
    public function calculate(){
        topLeaf.calculate();
    }
    public function parse( x: Float, y: Float ){
        trace( 'parsing multiped: ' + multi.name );
        var top = multi.top;
        topLeaf = createLeaf( top.name, top.texture );
        topLeaf.x = Math.round( x + top.x ); // left
        topLeaf.y = Math.round( y + top.y ); // top
        var limb = bodyFrames.limbByName( top.texture );
        addChildren( top, topLeaf );
        topLeaf.rotate( 0, limb.realW/2, limb.realH/2 );
        topLeaf.calculate();
        leaves.reverse();
    }
    public function addChildren( parentNode: LeafNode, parentLeaf: Leaf ){
        for( aNode in multi.leaves ){
            if( parentNode.name == aNode.parentName ){
                var leaf = createLeaf( aNode.name, aNode.texture );
                if( leaf != null ){
                    leaves.push( leaf );
                    parentLeaf.addLeaf( leaf, Math.round( aNode.ox ), Math.round( aNode.oy ) );
                    addChildren( aNode, leaf );
                    leaf.rotate( 0, Math.round( aNode.cx ), Math.round( aNode.cy ) );
                }
            }
        }
    }
    public
    function createLeaf( name: String, nameTexture: String ){
        trace('createLeaf ' + name );
        var limb = bodyFrames.limbByName( nameTexture );
        if( limb == null  ) {
            trace( 'limb not found:' + nameTexture );
            return null;
        }
        var leaf = new Leaf(  name, nameTexture
                            , Std.int( limb.realW ), Std.int( limb.realH ), 0, 0, limb.flipped );
        leaves.push( leaf );
        return leaf;
    }
}