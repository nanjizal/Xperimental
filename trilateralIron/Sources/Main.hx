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
import trilateralXtra.parsing.FillDrawPolyK;
import trilateral.parsing.FillDraw;
import trilateral.nodule.*;
import iron.helper.IronHelper;
import iron.helper.MultiColorMesh;
import iron.helper.MaterialMeshHelper;
import iron.helper.SingleColorMesh;
import iron.helper.TextureColorMesh;
import iron.math.Vec4;
import iron.math.Mat4;
import kha.Color;
import kha.Assets;
class Main {
    public static var wid     = 800;
    public static var hi      = 600;
    public static var bgColor = 0xff6495ED;
    var ironHelper:     IronHelper;
    var fillDraw:       FillDraw;
    var colorMesh:      MultiColorMesh;
    var singleMesh:     SingleColorMesh;
    var textureMesh:    TextureColorMesh;
    var sceneName       = "Scene";
    var cameraName      = 'MyCamera';
    var cameraDataName  = 'MyCameraData';
    var meshName        = 'mesh';
    var mesh2Name       = 'mesh2';
    var mesh3Name       = 'mesh3';
    public static function main() {
        kha.System.init( { title: "Iron with Trilateral"
                         , width: wid, height: hi
                         , samplesPerPixel: 4 }, function(){
            new Main();
        });
    }
    public function new(){
        fillDraw = new FillDrawPolyK( wid, hi );
        Assets.loadEverything( loadAll );
    }
    function loadAll(){
        ironHelper       = new IronHelper( sceneName
                                         , cameraName
                                         , cameraDataName
                                         , [ mesh3Name, mesh2Name, meshName ]
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
        svg.render( fillDraw );
        return fillDraw;
    }
    function meshCreate( ){
        
        var blanks = new Array<Color>();
        for( i in 0...fillDraw.colors.length ) blanks[ i ] = Color.White;
        
        textureMesh          = new TextureColorMesh( mesh3Name, wid, hi, 'textureName', 'HueAlpha' ); 
        var materialMeshHelper3 = new MaterialMeshHelper( ironHelper.raw
                                                        , cast textureMesh 
                                                        , fillDraw.triangles
                                                        , blanks
                                                        , 'triangles3' );
        materialMeshHelper3.ready = adjustTriangles3;
        materialMeshHelper3.create();
        
        singleMesh          = new SingleColorMesh( mesh2Name, wid, hi ); 
        var materialMeshHelper2 = new MaterialMeshHelper( ironHelper.raw
                                                        , cast singleMesh 
                                                        , fillDraw.triangles
                                                        , [ Color.Red ] 
                                                        , 'triangles2' );
        materialMeshHelper2.ready = adjustTriangles2;
        materialMeshHelper2.create();
        
        colorMesh              = new MultiColorMesh( meshName, wid, hi );
        var materialMeshHelper = new MaterialMeshHelper( ironHelper.raw
                                                       , cast colorMesh
                                                       , fillDraw.triangles
                                                       , fillDraw.colors
                                                       , 'triangles' );
        materialMeshHelper.ready = adjustPositions;
        materialMeshHelper.create();
        
    }
    function adjustTriangles3( o: Object ){
        var camera = Scene.active.getCamera( cameraName );
        var obj    = Scene.active.getChild( 'triangles3' );
        //var v      = new Vec4( -0.5, -0.5, 0 );
        //obj.transform.move( v, 1 ); 
    }
    function adjustTriangles2( o: Object ){
        var camera = Scene.active.getCamera( cameraName );
        var obj    = Scene.active.getChild( 'triangles2' );
        var v      = new Vec4( -0.5, -0.5, 0 );
        obj.transform.move( v, 1 ); 
    }
    function adjustPositions( o: Object ){
        var camera = Scene.active.getCamera( cameraName );
        var obj    = Scene.active.getChild( 'triangles' );
        var v      = new Vec4( 0.5, 0.5, 0 );
        obj.transform.move( v, 1 );
    }
}
