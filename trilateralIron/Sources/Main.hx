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
import iron.math.Vec4;
import iron.math.Mat4;
import kha.Assets;
class Main {
    public static var wid     = 800;
    public static var hi      = 600;
    public static var bgColor = 0xff6495ED;
    var ironHelper:     IronHelper;
    var fillDraw:       FillDraw;
    var multiColorMesh: MultiColorMesh;
    var sceneName       = "Scene";
    var cameraName      = 'MyCamera';
    var cameraDataName  = 'MyCameraData';
    var meshName        = 'mesh';
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
                                         , meshName
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
        multiColorMesh      = new MultiColorMesh( meshName, wid, hi );
        multiColorMesh.draw( fillDraw.triangles, fillDraw.colors );
        var mesh            = multiColorMesh.triangleMeshCreate();
        var raw             = ironHelper.raw;
        raw.mesh_datas.push( mesh );
        MeshData.parse( raw.name, mesh.name, materialSetup );
    }
    function materialSetup( res: MeshData ){
        var raw = ironHelper.raw;
        raw.shader_datas.push( multiColorMesh.shaderDataCreate() );
        var md = multiColorMesh.materialDataCreate();
        raw.material_datas.push( md );
        MaterialData.parse( raw.name, md.name, materialCreated );
    }
    function materialCreated( res: MaterialData ) {
        var tri = multiColorMesh.meshObjectCreate( 'Triangles' );
        var raw = ironHelper.raw;
        raw.objects[ 0 ].children.push( tri );
        Scene.active.parseObject( raw.name, tri.name, null, adjustPositions );    
    }
    function adjustPositions(o: Object){
        var camera = Scene.active.getCamera( cameraName );
        var obj    = Scene.active.getChild( 'Triangles' );
        var v      = new Vec4( 0.5, 0.5, 0 );
        // obj.transform.move( v, 1 );   
    }
}
