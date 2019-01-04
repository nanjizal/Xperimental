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
import trilateral.tri.TriangleArray;
import trilateral.parsing.svg.Svg;
import trilateral.tri.TriangleGradient;
import trilateralXtra.parsing.FillDrawTess2;
import trilateral.parsing.FillDraw;
import trilateral.nodule.*;
import iron.helper.IronHelper;
import iron.helper.MultiColorMesh;
import iron.helper.MaterialMeshHelper;
import iron.math.Vec4;
import iron.math.Mat4;
import kha.Color;
import kha.Assets;
import htmlHelper.tools.AnimateTimer;
class Main {
    public static var wid     = 800;
    public static var hi      = 600;
    public static var bgColor = 0xff6495ED;
    // controls the depth of the logo
    public static var depth   = 0.3;
    // controls the reduction in brightness of color channels.
    public static var fractionColor = 1/2.2;
    // turn random colors on off.
    public static var randomColors = false;
    var ironHelper:     IronHelper;
    var fillDraw:       FillDraw;
    var colorMesh:      MultiColorMesh;
    var sceneName       = "Scene";
    var cameraName      = 'MyCamera';
    var cameraDataName  = 'MyCameraData';
    var meshName        = 'mesh';
    var mesh2Name       = 'mesh2';
    var mesh3Name       = 'mesh3';
    var mesh4Name       = 'mesh4';
    public static function main() {
        kha.System.init( { title: "Iron with Trilateral"
                         , width: wid, height: hi
                         , samplesPerPixel: 4 }, function(){
            new Main();
        });
    }
    public function new(){
        fillDraw = new FillDrawTess2( wid, hi );
        Assets.loadEverything( loadAll );
    }
    function loadAll(){
        ironHelper       = new IronHelper( sceneName
                                         , cameraName
                                         , cameraDataName
                                         , [ meshName ]
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
        colorMesh              = new MultiColorMesh( meshName, wid, hi, depth, fractionColor, randomColors );
        var materialMeshHelper = new MaterialMeshHelper( ironHelper.raw
                                                       , cast colorMesh
                                                       , fillDraw.triangles
                                                       , fillDraw.contours
                                                       , fillDraw.colors
                                                       , fillDraw.contourColors
                                                       , 'triangles' );
        materialMeshHelper.ready = adjustPositions;
        materialMeshHelper.create();
    }
    function adjustPositions( o: Object ){
        AnimateTimer.create();
        AnimateTimer.onFrame = render;
    }
    var theta = Math.PI/4;
    function render( t:Int ):Void{
        var obj    = Scene.active.getChild( 'triangles' );
        var v        = new Vec4( -Math.PI/6, Math.PI/4, Math.PI/7 );
        obj.transform.rotate( v, -0.05 );
        v       = new Vec4( Math.sin( theta+=0.01 )
                          , Math.cos( theta+=0.01 )
                          , Math.sin( theta+=0.01 ) );
        obj.transform.move( v, 0.004 );
    }
}
