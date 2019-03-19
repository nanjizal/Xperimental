package;
import js.Browser;
import trilateral.tri.Triangle;
import trilateral.tri.TrilateralArray;
import trilateral.geom.Contour;
import trilateral.tri.TriangleArray;
import trilateral.tri.TrilateralPair;
import trilateral.path.Fine;
import htmlHelper.canvas.CanvasWrapper;
import htmlHelper.tools.AnimateTimer;
import justDrawing.Surface;
import js.html.Event;
import js.html.KeyboardEvent;
import js.html.MouseEvent;
import trilateralXtra.color.AppColors;
import trilateral.polys.Shapes;
import khaMath.Vector4;
import trilateral.angle.Angles;
import trilateral.polys.Poly;
class Main {
    public var surface:       Surface;
    public var distance       = 50;
    public var canvas         = new CanvasWrapper();
    public var circleSize:    Float = 5.;
    public var shapes:        Shapes;
    public var triangles      = new TriangleArray();
    public var mousePos:      Vector4;
    public var point:         Vector4;
    public var points         = 7;
    public var places         = 12;// 6*2
    public var bodies         = new Array<Vector4>();
    public var joints         = new Array<Vector4>();
    public var jointsF        = new Array<Vector4>();
    public var mouseIsDown:   Bool = false;
    public var showMouse:     Bool = true;
    public var appColors:     Array<AppColors> = [  Black, Red
                                                 , Orange, Yellow
                                                 , Green, Blue
                                                 , Indigo, Violet
                                                 , LightGrey, MidGrey
                                                 , DarkGrey, NearlyBlack
                                                 , White
                                                 , BlueAlpha, GreenAlpha, RedAlpha ];
    public static function main(){ new Main(); }
    public function new(){
        var doc = Browser.document;
        canvas.width  = 1024*2;
        canvas.height = 768*2;
        doc.body.appendChild( cast canvas );
        surface  = new Surface( canvas.getContext2d() );
        shapes   = new Shapes( triangles, appColors );
        mousePos = new Vector4( 100, 100, 0 );
        setupExperiments();
        AnimateTimer.onFrame = render;
        AnimateTimer.create();
        doc.onmousemove      = mouseMove;
        doc.onmousedown      = mouseDown;
        doc.onmouseup        = mouseUp;
    }
    inline
    function setupExperiments(){
        // simple
        point    = new Vector4( 100, 100, 0 );
        // chain
        var dx = canvas.width/2;
        var dy = canvas.height/2;
        for( i in 0...points ) joints[ i ] = new Vector4( dx + i*distance, dy, 0 );
        // FABRIK
        for( i in 0...points ) jointsF[ i ] = new Vector4( dx + i*distance, dy, 0 );
        // collision
        var collisionArea = 300;
        for( i in 0...places ) {
            var x0 = dx/2 + collisionArea*Math.random();//(dx - collisionArea/2) + 
            var y0 = dy/2 + collisionArea*Math.random();//(dy - collisionArea/2) + 
            bodies[ i ] = new Vector4( x0, y0, 0 );
        }
    }
    inline
    function findColorID( col: AppColors ){
        return appColors.indexOf( col );
    }
    inline
    function circleOutline( x: Float, y: Float, radius: Float, color: AppColors ){
        triangles.addArray( 0, Poly.arc( x, y, radius, 1, 0, 2*Math.PI, CLOCKWISE ), findColorID( color ) );
    }
    inline
    function createSpot( x: Float, y: Float, color: AppColors ){
        shapes.circle( x, y, circleSize, findColorID( color )  );
    }
    inline
    function createCircle( x: Float, y: Float, color: AppColors ){
        circleOutline( x, y, distance, color );
    }
    inline
    function mouseDown( e: MouseEvent ){
        mouseIsDown = true;
        mouseCoord( e );
    }
    inline
    function mouseMove( e: MouseEvent ){
        if( mouseIsDown ) mouseCoord( e );
    }
    inline
    function mouseCoord( e: MouseEvent ){
        mousePos = new Vector4( e.clientX, e.clientY, 0 );
    }
    inline
    function mouseUp( e: MouseEvent ){
        mouseCoord( e );
        mouseIsDown = false;
    }
    inline
    function clear(){
        triangles = [];
        shapes.triangles = triangles;
    }
    inline
    function simple(){
        if( showMouse ) plotMousePos();
        var anchor = mousePos;
        var toNext = mousePos.sub( point );
        if( toNext.length > distance ) point = point.constrainDistance( anchor, distance );
        plotPoint();
    }
    inline
    function chain(){
        var joint = joints[0];
        joint.x = mousePos.x;
        joint.y = mousePos.y;
        createSpot( joint.x, joint.y, Red );
        for( i in 0...( points - 1) ) {
            joints[ i + 1 ] = joints[ i + 1 ].constrainDistance( joints[ i ], distance );
            joint = joints[ i + 1 ];
            shapes.circle( joint.x, joint.y, circleSize, findColorID( Red ) + i + 1 );
        }
    }
    inline
    function fabrik(){
        var joint = jointsF[0];
        joint.x = mousePos.x;
        joint.y = mousePos.y;
        createSpot( joint.x, joint.y, Red );
        for( i in 1...points ) {
            jointsF[ i ] = jointsF[ i ].constrainDistance( jointsF[ i - 1 ], distance );
        }
        var j: Int;
        var dx = canvas.width/4;
        var dy = canvas.height/4;
        var joint = jointsF[ points - 1 ];
        joint.x = dx;
        joint.y = dy;
        createSpot( dx, dy, White );
        for( i in 1...points ){
            j = points - i;
            jointsF[ j - 1 ] = jointsF[ j - 1 ].constrainDistance( jointsF[ j ], distance );
            joint = jointsF[ j - 1 ];
            shapes.circle( joint.x, joint.y, circleSize, findColorID( Red ) + i - 1 );
        }
    }
    inline
    function collision(){
        // separate from mouse
        var body: Vector4;
        var mouseEdge = 2;
        var radius = distance + mouseEdge + circleSize/2;
        for( i in 0...places ) {
            body = bodies[ i ];
            var toNext = mousePos.sub( body );
            if( toNext.length < radius ){
                toNext.length = radius;
                var offset = mousePos.sub( body ).sub( toNext );
                bodies[ i ] = body.add( offset );
            }
        }
        // separate balls
        var other: Vector4;
        for( i in 0...places ) for( j in i...places ) {
            body = bodies[ i ];
            other = bodies[ j ];
            var toNext = other.sub( body );
            if( toNext.length < circleSize*2 ){
                toNext.length = circleSize*2 ;
                var offset = other.sub( body ).sub( toNext ).mult( 0.5 );
                bodies[ i ] = body.add( offset );
                bodies[ j ] = other.sub( offset );
            }
        }
        for( i in 0...places ){
            body = bodies[ i ];
            var col = findColorID( Red ) + i - 1;
            if( col > 7 ) col = col - 8; // wrap colors
            shapes.circle( body.x, body.y, circleSize, col );
        }
    }
    inline
    function chainLink(){
        linkSpots( 11, joints, 0.3, MidGrey );
    }
    inline
    function fabrikLink(){
        linkSpots( 10, jointsF, 0.3, LightGrey );
    }
    inline
    function render( i: Int ): Void {
        clear();
        simple();
        chain();
        fabrik();
        chainLink();
        fabrikLink();
        collision();
        drawTriangles();
    }
    inline
    function plotPoint(){
        createSpot( point.x, point.y, White );
    }
    inline
    function plotMousePos(){
        createCircle( mousePos.x, mousePos.y, MidGrey );
    }
    // draws triangles to screen, approach similar for WebGL, so some additional complexity worth it.
    inline
    function drawTriangles(){
        var tri: Triangle;
        var s = 1.;
        var ox = 0.;
        var oy = 0.;
        var g = surface;
        g.beginFill( 0x181818, 1. );
        g.lineStyle( 0., 0x000000, 0. );
        g.drawRect( 1, 1, 2*1024-2, 2*768-2 );
        g.endFill();
        var triangles = triangles;
        var triangleColors = appColors;
        for( i in 0...triangles.length ){
            tri = triangles[ i ];
            if( tri.mark != 0 ){
                g.beginFill( triangleColors[ tri.mark ] );
            } else {
                g.beginFill( triangleColors[ tri.colorID ] );
                g.lineStyle( 0., triangleColors[ tri.colorID ], 1. );
            }
            g.drawTri( [   ox + tri.ax * s, oy + tri.ay * s
                        ,  ox + tri.bx * s, oy + tri.by * s
                        ,  ox + tri.cx * s, oy + tri.cy * s ] );
            g.endFill();
        }
    }
    inline
    function linkSpots( index: Int, spots: Array<Vector4>, width: Float, color: AppColors ){
        var path = new Fine( null, null, both );
        path.width = width;
        path.moveTo( spots[ 0 ].x, spots[ 0 ].y );
        for( i in 1...points ) path.lineTo( spots[ i ].x, spots[ i ].y );
        triangles.addArray( index, path.trilateralArray, appColors.indexOf( color ) );
    }
}