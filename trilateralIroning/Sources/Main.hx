package;

import iron.App;
import iron.Scene;
import iron.RenderPath;
import iron.data.*;
import iron.data.SceneFormat;
import iron.object.Object;
import trilateral.tri.*;
import trilateral.geom.*;
import trilateral.path.*;
import trilateral.justPath.*;
import trilateral.angle.*;
import trilateral.polys.*;
import trilateral.angle.*;
import trilateral.tri.Triangle;
import trilateral.path.Fine;
import trilateral.tri.TriangleArray;
import trilateral.parsing.svg.Svg;
import trilateral.tri.TriangleGradient;
import trilateralXtra.parsing.FillDrawTess2;
import trilateral.parsing.FillDraw;
import trilateral.nodule.*;
import iron.helper.IronHelper;
import iron.helper.MultiColorMesh;
import iron.helper.MaterialMeshHelper;
import trilateralXtra.color.AppColors;
import trilateral.justPath.transform.ScaleContext;
import trilateral.justPath.transform.ScaleTranslateContext;
import trilateral.justPath.transform.TranslationContext;
import iron.math.Vec4;
import iron.math.Mat4;
import kha.Color;
import kha.Assets;
import htmlHelper.tools.AnimateTimer;
typedef DrawData = {
    var triangles:  TriangleArray;
    var edges:      Array<Array<Float>>;
}
class Main {
    public static var wid     = 800;
    public static var hi      = 600;
    public static var bgColor = 0xff6495ED;
    // controls the depth of the logo
    public static var depth   = 0.3;
    // controls the reduction in brightness of color channels.
    public static var fractionColor = 1/2.2;
    // turn random colors on off.
    public static var randomColors = false  ;
    var ironHelper:     IronHelper;
    var fillDraw:       FillDraw;
    var colorMesh:      MultiColorMesh;
    var colorMesh2:     MultiColorMesh;
    var centre:                 Point;
    var bottomLeft:             Point;
    var bottomRight:            Point;
    var topLeft:                Point;
    var topRight:               Point;
    var quarter:                Float;
    var sceneName       = "Scene";
    var cameraName      = 'MyCamera';
    var cameraDataName  = 'MyCameraData';
    var stageRadius     = 600.;
    public var appColors:       Array<AppColors> = [ Black, Red, Orange, Yellow, Green, Blue, Indigo, Violet
                                                   , LightGrey, MidGrey, DarkGrey, NearlyBlack, White
                                                   , BlueAlpha, GreenAlpha, RedAlpha ];
    public static function main() {
        kha.System.init( { title: "Iron with Trilateral"
                         , width: wid, height: hi
                         , samplesPerPixel: 4 }, function(){
            new Main();
        });
    }
    public function new(){
        fillDraw = new FillDrawTess2( wid, hi );
        setup();
        Assets.loadEverything( loadAll );
    }
    public
    function setup(){
        centre          = { x: stageRadius- 700, y: stageRadius - 300 };
        quarter         = stageRadius/2;
        bottomLeft      = { x: stageRadius - quarter, y: stageRadius + quarter - 1000 };
        bottomRight     = { x: stageRadius + quarter, y: stageRadius + quarter - 1000 };
        topLeft         = { x: stageRadius - quarter, y: stageRadius - quarter - 1000 };
        topRight        = { x: stageRadius + quarter, y: stageRadius - quarter - 1000 };
    }
    function loadAll(){
        ironHelper       = new IronHelper( sceneName
                                         , cameraName
                                         , cameraDataName
                                         , [ 'svgMesh','linesMest','quadMesh','cubicMesh'
                                           ,'shapeMesh','birdMesh','bird2Mesh','bird3Mesh' ]
                                         , bgColor );
        ironHelper.ready = sceneReady;
        ironHelper.create();
    }
    function sceneReady( scene: Object ) {
        svgToTriangles( Assets.blobs.salsaLogo_svg.toString() );
        meshCreate();
    }
    function svgToTriangles( svgStr: String ): FillDraw {
        var nodule: Nodule  = ReadXML.toNodule( svgStr );
        var svg: Svg        = new Svg( nodule );
        // randomColors controls if the face is rendered with random colors.
        svg.render( fillDraw, randomColors );
        return fillDraw;
    }
    function meshCreate( ){
        var blanks = new Array<Color>();
        for( i in 0...fillDraw.colors.length ) blanks[ i ] = Color.White;
        var lines  = addJoinTestForwards();
        var quads  = addQuadCurve();
        var cubic  = addCubicCurve();
        var shapes = addShapes();
        var birdYellow = addBird( Yellow );
        var birdRed    = addBird( Red );
        objCount = 7;
        createObj( 'svg', 'svgMesh'
                 , fillDraw.triangles, fillDraw.contours
                 , 0.3, fillDraw.colors, fillDraw.contourColors );
        createObj( 'lines', 'linesMesh'
                 , lines.triangles, lines.edges
                 , 0.2, cast appColors, cast appColors );
        createObj( 'quadCurve', 'quadMesh'
                , quads.triangles, quads.edges
                , 0.1, cast appColors, cast appColors );
        createObj( 'cubicCurve', 'cubicMesh'
                , cubic.triangles, cubic.edges
                , 0.1, cast appColors, cast appColors );
        createObj( 'shapes', 'shapesMesh'
                , shapes, [[]]
                , 0.1, cast appColors, cast appColors );  
        createObj( 'bird', 'birdMesh'
                , birdRed.triangles, birdRed.edges
                , 0.005, cast appColors, cast appColors );       
        createObj( 'bird2', 'bird2Mesh'
                , birdYellow.triangles, birdYellow.edges
                , 0.005, cast appColors, cast appColors ); 
        createObj( 'bird3', 'bird3Mesh'
                , birdRed.triangles, birdRed.edges
                , 0.005, cast appColors, cast appColors );                 
    }
    public
    function createObj( nom: String, meshNom: String
                      , triangles_: TriangleArray, edges_: Array<Array<Float>>
                      , depth: Float
                      , colors_: Array<Color>, contourColors_:Array<Color> ){
        var mesh             = new MultiColorMesh( meshNom, wid, hi, depth, fractionColor, randomColors );
        var mm = new MaterialMeshHelper( ironHelper.raw
                                       , cast mesh
                                       , triangles_
                                       , edges_
                                       , colors_
                                       , contourColors_
                                       , nom );
        mm.ready = adjustPositions;
        mm.create();
    }
    function addJoinTestForwards(): DrawData {
        var path = new Fine( null, null, both );
        path.width = 50;
        var triangles = new TriangleArray();
        // forwards
        var dx = -50;
        var dy = 70;
        path.moveTo( 200 + dx, 450 + dy );
        path.lineTo( 700 + dx, 450 + dy );
        path.lineTo( 700 + dx, 700 + dy );
        path.lineTo( 450 + dx, 750 + dy );
        path.lineTo( 450 + dx, 700 + dy );
        path.lineTo( 200 + dx, 80 + dy );
        path.lineTo( 150 + dx, 450 + dy );
        path.lineTo( 90 + dx, 700 + dy );
        path.moveTo( 0.,0. ); // required to make it put endCap
        triangles.addArray( 10
                        ,   path.trilateralArray
                        ,   appColors.indexOf( Orange ) );
        return { triangles: triangles, edges: path.getEdges() };
    }
    function addQuadCurve(): DrawData {
        var path = new Fine( null, null, both ); // fineOverlap fails
        var triangles = new TriangleArray();
        path.width = 2;
        path.widthFunction = function( width: Float, x: Float, y: Float, x_: Float, y_: Float ): Float{
            return width+0.008*5;
        }
        var translationContext = new TranslationContext( path, -100, 300 );
        var p = new SvgPath( translationContext );
        p.parse( quadtest_d );
        path.moveTo( 0.,0. );
        triangles.addArray( 7
                        ,   path.trilateralArray
                        ,   1 );
        return { triangles: triangles, edges: path.getEdges() };
    }
    function addCubicCurve(): DrawData {
        var path = new Fine( null, null, both );
        var triangles = new TriangleArray();
        path.width = 1;
        path.widthFunction = function( width: Float, x: Float, y: Float, x_: Float, y_: Float ): Float{
            return width+0.008*5;
        }
        var translationContext = new TranslationContext( path, -50, 500 );
        var p = new SvgPath( translationContext );
        p.parse( cubictest_d );
        path.moveTo( 0.,0. );
        triangles.addArray( 7
                        ,   path.trilateralArray
                        ,   5 );
        return { triangles: triangles, edges: path.getEdges() };
    }
    function addShapes(){
        var size = 80;
        var triangles = new TriangleArray();
        var shapes = new Shapes( triangles, appColors );
        shapes.star( ( bottomLeft.x + centre.x )/2, ( bottomLeft.y + centre.y )/2,      size,  findColorID( Orange ) );
        shapes.diamondOutline( ( topLeft.x + centre.x )/2
                                                 , ( topLeft.y + centre.y )/2,  0.7*size, 6,   findColorID( MidGrey ) );
        shapes.diamond( ( topLeft.x + centre.x )/2, ( topLeft.y + centre.y )/2,     0.7*size,  findColorID( Yellow ) );
        shapes.squareOutline( ( bottomRight.x + centre.x )/2
                                            , ( bottomRight.y + centre.y )/2, 0.7*size, 6,     findColorID( MidGrey ) );
        shapes.square( ( bottomRight.x + centre.x )/2
                                                 , ( bottomRight.y + centre.y )/2,  0.7*size,  findColorID( Green )   );
        
        shapes.rectangle( topLeft.x - 100, centre.y - 50,                        size*2, size,  findColorID( Blue )    );
        shapes.circle( ( topRight.x + centre.x )/2, ( topRight.y + centre.y )/2,        size,  findColorID( Indigo )  );
        shapes.spiralLines( centre.x, centre.y, 15, 60, 0.08, 0.05,                            findColorID( Red )     );
        shapes.roundedRectangleOutline( topLeft.x - size
                              ,( topLeft.y + bottomLeft.y )/2 - size/2, size*2, size,  6, 30,  findColorID( MidGrey ) );
        
        shapes.roundedRectangle( topLeft.x - size
                              ,( topLeft.y + bottomLeft.y )/2 - size/2, size*2, size, 30,      findColorID( Violet )  );
        
        return triangles;
    }
    function addBird( col: Int ){
        var path = new Fine( null, null, both );
        path.width = 3;
        var triangles = new TriangleArray();
        var scaleContext = new ScaleContext( path, 1.5, 1.5 );
        var p = new SvgPath( scaleContext );
        p.parse( bird_d );
        triangles.addArray( 6
                        ,   path.trilateralArray
                        ,   appColors.indexOf( col ) );
       return { triangles: triangles, edges: path.getEdges() }; 
    }
    function findColorID( col: AppColors ){
        return appColors.indexOf( col );
    }
    var ready = 0;
    var objCount = 0;
    function adjustPositions( o: Object ){
        ready++;
        if( ready < objCount ) return;
        trace( 'ready' );
        AnimateTimer.create();
        AnimateTimer.onFrame = render;
    }
    var theta = Math.PI/4;
    var first = true;
    function render( t:Int ):Void{
        var lines    = Scene.active.getChild( 'lines' );
        var svg      = Scene.active.getChild( 'svg' );
        var quad     = Scene.active.getChild( 'quad' );
        var cubic    = Scene.active.getChild( 'cubic' );
        var bird     = Scene.active.getChild( 'bird' );
        var bird2     = Scene.active.getChild( 'bird2' );
        var bird3     = Scene.active.getChild( 'bird3' );
        var v        = new Vec4( 1, 0.2, -0.5 );
        if( first ) {
            bird.transform.scale = new Vec4( .5, .5, 1.);
            bird.transform.move( v, 0.8 );
            v        = new Vec4( 1, -0.5, 0 );
            bird2.transform.move( v, -0.5 );
            v       = new Vec4( 0, 0, 1 );
            bird3.transform.move( v, 0.5 );
        }
        v        = new Vec4( -Math.PI/6, Math.PI/4, Math.PI/7 );
        lines.transform.rotate( v, -0.05 );
        svg.transform.rotate( v, 0.05 );
        v        = new Vec4( -Math.PI/6, 0, 0 );
        bird.transform.rotate( v, 0.06 );
        v       = new Vec4( Math.sin( theta+=0.01 )
                          , Math.cos( theta+=0.01 )
                          , Math.sin( theta+=0.01 ) );
        lines.transform.move( v, 0.004 );
        svg.transform.move( v, 0.003 );
        first = false;
    }
    var quadtest_d = "M200,300 Q400,50 600,300 T1000,300";
    var cubictest_d = "M100,200 C100,100 250,100 250,200S400,300 400,200";
    var bird_d = "M210.333,65.331C104.367,66.105-12.349,150.637,1.056,276.449c4.303,40.393,18.533,63.704,52.171,79.03c36.307,16.544,57.022,54.556,50.406,112.954c-9.935,4.88-17.405,11.031-19.132,20.015c7.531-0.17,14.943-0.312,22.59,4.341c20.333,12.375,31.296,27.363,42.979,51.72c1.714,3.572,8.192,2.849,8.312-3.078c0.17-8.467-1.856-17.454-5.226-26.933c-2.955-8.313,3.059-7.985,6.917-6.106c6.399,3.115,16.334,9.43,30.39,13.098c5.392,1.407,5.995-3.877,5.224-6.991c-1.864-7.522-11.009-10.862-24.519-19.229c-4.82-2.984-0.927-9.736,5.168-8.351l20.234,2.415c3.359,0.763,4.555-6.114,0.882-7.875c-14.198-6.804-28.897-10.098-53.864-7.799c-11.617-29.265-29.811-61.617-15.674-81.681c12.639-17.938,31.216-20.74,39.147,43.489c-5.002,3.107-11.215,5.031-11.332,13.024c7.201-2.845,11.207-1.399,14.791,0c17.912,6.998,35.462,21.826,52.982,37.309c3.739,3.303,8.413-1.718,6.991-6.034c-2.138-6.494-8.053-10.659-14.791-20.016c-3.239-4.495,5.03-7.045,10.886-6.876c13.849,0.396,22.886,8.268,35.177,11.218c4.483,1.076,9.741-1.964,6.917-6.917c-3.472-6.085-13.015-9.124-19.18-13.413c-4.357-3.029-3.025-7.132,2.697-6.602c3.905,0.361,8.478,2.271,13.908,1.767c9.946-0.925,7.717-7.169-0.883-9.566c-19.036-5.304-39.891-6.311-61.665-5.225c-43.837-8.358-31.554-84.887,0-90.363c29.571-5.132,62.966-13.339,99.928-32.156c32.668-5.429,64.835-12.446,92.939-33.85c48.106-14.469,111.903,16.113,204.241,149.695c3.926,5.681,15.819,9.94,9.524-6.351c-15.893-41.125-68.176-93.328-92.13-132.085c-24.581-39.774-14.34-61.243-39.957-91.247c-21.326-24.978-47.502-25.803-77.339-17.365c-23.461,6.634-39.234-7.117-52.98-31.273C318.42,87.525,265.838,64.927,210.333,65.331zM445.731,203.01c6.12,0,11.112,4.919,11.112,11.038c0,6.119-4.994,11.111-11.112,11.111s-11.038-4.994-11.038-11.111C434.693,207.929,439.613,203.01,445.731,203.01z";
}
