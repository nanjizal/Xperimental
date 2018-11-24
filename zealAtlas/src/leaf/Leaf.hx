package leaf;
using leaf.Leaf;
typedef Point2D = { x: Int, y: Int } 
typedef Axis = { beta: Float, hyp: Float }
class Leaf {
    public var name:                String;
    public var textureName:         String;
    public var alpha:               Float = 1.;
    public var parent:              Leaf;
    public var rank:                Int = 0;
    // image position
    public var x:           Int;
    public var y:           Int;
    // image dim
    public var w ( default, null ):    Int;
    public var h ( default, null ):    Int;
    // rotation point
    public var rx:         Float = 0.;
    public var ry:         Float = 0.;
    // angle in radians
    public var theta( default, set ): Float;
    // store by depth
    public var leaves:                      Array<Leaf>;
    public var leafCentre:                  Array<Point2D>;
    public var leafAxis:                    Array<Axis>;
    public var left( default, default ):    Int;
    public var top( default, default ):     Int;
    public var wid( default, null ):        Int;
    public var hi( default, null ):         Int;    
    public var cx( default, null ):         Float;
    public var cy( default, null ):         Float;
    public var hyp:                         Float;
    public var beta:                        Float;
    var cos:                                Float;
    var sin:                                Float;
    var dx:                                 Float;
    var dy:                                 Float;
    public var offset:                      Point2D;
    var flipped:                            Bool;
    // rotational coordinate
    public var rotX: Float;
    public var rotY: Float;
    // other cross
    public var crossX: Float;
    public var crossY: Float;
    public function set_theta( theta_: Float = 0 ): Float {
        //if( theta == null ) theta = 0.;
        var dTheta = theta - theta_;
        theta = theta_;
        //if( rx == null ) rx = 0.;
        //if( ry == null ) ry = 0.;
        var sine            = Math.sin( theta );
        var cos             = Math.cos( theta );
        // new dimensions
        wid                 = Std.int( Math.abs( w*cos ) + Math.abs( h*sine ) );
        hi                  = Std.int( Math.abs( w*sine ) + Math.abs( h*cos ) ); 
        // new centre
        cx                  = wid/2;
        cy                  = hi/2;
        // calculates offset of pivot
        offset              = pivotOffset();
        left                = Std.int( x + offset.x );
        top                 = Std.int( y + offset.y );
        return theta_;
    }
    public inline
    function updatePosition(){
        offset              = pivotOffset();
        left                = Std.int( x + offset.x );
        top                 = Std.int( y + offset.y );
    }
    public function addLeaf( leaf: Leaf, rx_: Int, ry_: Int ){
        if( leaf == null ) return;
        leaf.rank = rank + 1;
        leafCentre.push( { x: rx_, y: ry_ } );
        leaves.push( leaf );
    }
    public function rotate( theta_: Float, rx_: Float, ry_: Float ) {
        rx = rx_;
        ry = ry_;
        theta = theta_;
        for( i in 0...leafCentre.length ){
            if( leafAxis[i] == null ){
                var dx2     = rx - leafCentre[ i ].x;
                var dy2     = ry - leafCentre[ i ].y;
                leafAxis.push( { beta: Math.atan2( dy2, dx2 ), hyp: Math.pow( dx2*dx2 + dy2*dy2, 0.5 ) } ); 
            }
        }
    }
    public function new( name_: String, textureName_: String
                       , w_: Int, h_: Int, x_: Int = 0, y_: Int = 0, flipped_ = false ) {
        name    = name_;
        textureName = textureName_;
        leaves  = [];
        leafAxis = new Array<Axis>();
        leafCentre = new Array<Point2D>();
        x       = x_;
        y       = y_;
        w       = w_;
        h       = h_;
        flipped = flipped_;
    }
    public function pivotOffset(): Point2D {
        var dx      = w/2 - rx;
        var dy      = h/2 - ry;
        // calculates the angle from the old centre to the pivot point.
        beta        = Math.atan2( dy, dx );
        // calculates the diagonal distance from the old centre to the pivot point.
        hyp         = Math.pow( dx*dx + dy*dy, 0.5 );
        var bt      = beta + theta;
        cos = Math.cos( bt );
        sin = Math.sin( bt );
        return  {   x: Std.int( rx - cx + hyp*cos )
                ,   y: Std.int( ry - cy + hyp*sin )
                };
    }
    public function calculate(){
        var bt      = beta + theta;
        cos = Math.cos( bt );
        sin = Math.sin( bt );
        
        rotX = left + cx - hyp*cos;
        rotY = top  + cy - hyp*sin;
        //  left, top, w, h 
        //  hitTest = box, left, top, wid, hi 
        //  rotX, rotY  and crossX and crossY  coordinate 
        crossX = left + cx;
        crossY = top  + cy;
        for( i in 0...leaves.length ){
            
            var axis                = leafAxis[ i ];
            var leaf                = leaves[ i ];
            
            var loff                = leaf.offset;
            var hyp2                = axis.hyp;
            var b2t                 = axis.beta + theta;
            leaf.left = Std.int( rotX - hyp2*Math.cos( b2t ) + loff.x - leaf.rx ) ;
            leaf.top  = Std.int( rotY - hyp2*Math.sin( b2t ) + loff.y - leaf.ry );
            leaves[ i ].calculate();
            
        }
    }
    
    /*
    
    // no bounds checking
    public inline function liteHit( px: Float, py: Float ): Bool {
        var ax = left;
        var ay = right;
        var bx = 
        var by = 
        var gx = wid;
        var gy = hi;
        var hx = 
        var hy =
        return triangleHit( px, py, ax, ay, bx, by, hx, hy ) 
            && triangleHit( px, py, bx, by, gx, gy, hx, hy );
        
    }
    public inline function triangleHit( px: Float, py: Float
                                      , ax: Float, ay: Float
                                      , bx: Float, bx: Float
                                      , gx: Float, gy: Float ): Bool {
                                      
        var planeAB = ( ax - px )*( by - py ) - ( bx - px )*( ay - py );
        var planeBG = ( bx - px )*( gy - py ) - ( gx - px )*( by - py );
        var planeGA = ( gx - px )*( ay - py ) - ( ax - px )*( gy - py );
        return Algebra.sign( planeAB ) == Algebra.sign( planeBG ) && Algebra.sign( planeBG ) == Algebra.sign( planeGA );                              
    }
    public function fullHit( px: Float, py: Float ): Bool {
        if( px > top && px < right && py > left && py < bottom ) return true;
        return liteHit( px, py );
    }
    */
}