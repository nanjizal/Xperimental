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

import constraints.demo.Inner;
import constraints.demo.Chain;
import constraints.demo.Fabrik;
import constraints.demo.Collision;

class Main {
    var innerDemo:     Inner;
    var chainDemo:     Chain;
    var fabrikDemo:    Fabrik;
    var collisionDemo: Collision;
    var surface:       Surface;
    var distance       = 50;
    var canvas         = new CanvasWrapper();
    var circleSize     = 5.;
    var lineWidth      = 0.3;
    var shapes:        Shapes;
    var triangles      = new TriangleArray();
    var mousePos:      Vector4;
    var points         = 7;
    var places         = 12;// 6*2
    var centreX:       Float;
    var centreY:       Float;
    var mouseIsDown:   Bool = false;
    var showMouse:     Bool = true;
    var appColors:     Array<AppColors> = [  Black, Red
                                           , Orange, Yellow
                                           , Green, Blue
                                           , Indigo, Violet
                                           , LightGrey, MidGrey
                                           , DarkGrey, NearlyBlack
                                           , White ];
    public static function main(){ new Main(); }
    public function new(){
        var doc = Browser.document;
        canvas.width  = 1024*2;
        canvas.height = 768*2;        
        centreX  = canvas.width/2;
        centreY  = canvas.height/2;
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
        innerDemo = new Inner( 100, 100, distance );
        // chain
        chainDemo = new Chain( centreX, centreY, points, distance );
        // FABRIK
        fabrikDemo = new Fabrik( centreX/2, centreY/2, points, distance );
        // collision
        var collisionArea = 300;
        collisionDemo = new Collision( centreX, centreY, places, circleSize, collisionArea, distance );
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
        innerDemo.update( mousePos );
        createSpot( innerDemo.point.x, innerDemo.point.y, White );
    }
    inline
    function chain(){
        var jointRender = ( i: Int, joint: Vector4 ) 
            -> shapes.circle( joint.x, joint.y, circleSize, findColorID( Red ) + i );
        chainDemo.update( mousePos, jointRender );
    }
    inline
    function fabrik(){
        var jointRender = ( i: Int, joint: Vector4 ) 
            -> shapes.circle( joint.x, joint.y, circleSize, findColorID( Red ) + i );
        fabrikDemo.update( mousePos, jointRender );
    }
    inline
    function collision(){
        var jointRender = ( i: Int, joint: Vector4 ) -> {
            var col = findColorID( Red ) + i;
            if( col > 7 ) col = col - 7; // wrap colors
            shapes.circle( joint.x, joint.y, circleSize, col );
        }
        collisionDemo.update( mousePos, jointRender );
    }
    inline
    function render( i: Int ): Void {
        clear();
        plotMousePos();
        simple();
        chain();
        fabrik();   
        linkSpots( 10, chainDemo.joints,  lineWidth, DarkGrey );
        linkSpots( 11, fabrikDemo.joints, lineWidth, LightGrey );
        collision();
        drawTriangles();
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
