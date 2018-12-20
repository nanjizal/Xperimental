package trilateralXtra.iron;
import iron.App;
import iron.Scene;
import iron.RenderPath;
import iron.data.*;
import iron.data.SceneFormat;
import iron.object.Object;
import kha.arrays.Float32Array;
import kha.arrays.Uint32Array;
import trilateral.tri.Triangle;
import trilateral.tri.TriangleArray;
import kha.Color;
class IronMesh {
    var raw:        TSceneFormat;
    var sceneName:  String;
    var meshName:   String;
    var vb:         Float32Array;
    var ib:         Uint32Array;
    var col:        Float32Array;
    public function new( sceneName_: String, meshName_: String ){
        sceneName = sceneName_;
        meshName = meshName_;
    }
    public function create( wid: Int, hi: Int, triangles: TriangleArray, colors: Array<Color> ){
        draw( wid, hi, triangles, colors );
        App.init( ready );
    }
    function draw( wid: Int, hi: Int, triangles: TriangleArray, colors: Array<Color> ){
        var tri: Triangle;
        var len = Std.int( triangles.length );
        vb  = new kha.arrays.Float32Array( Std.int( 9*len ) );
        ib  = new kha.arrays.Uint32Array(  Std.int( 3*len ) );
        col = new kha.arrays.Float32Array( Std.int( 9*len ) );
        var j = 0;
        var k = 0;
        var c = 0;
        var scaleX = 1/wid;
        var scaleY = 1/hi;
        var offX = wid/2;
        var offY = hi/2;
        var color: Int;
        var r: Float;
        var g: Float;
        var b: Float;
        var z: Float = 0.;
        for( i in 0...len ){
            tri = triangles[ i ];
            vb[ j++ ] = ( tri.ax - offX ) * scaleX;
            vb[ j++ ] = -( tri.ay - offY ) * scaleY;
            vb[ j++ ] = z;
            vb[ j++ ] = ( tri.bx - offX ) * scaleX;
            vb[ j++ ] = -( tri.by - offY ) * scaleY;
            vb[ j++ ] = z;
            vb[ j++ ] = ( tri.cx - offX ) * scaleX;
            vb[ j++ ] = -( tri.cy - offY ) * scaleY;
            vb[ j++ ] = z;
            color = colors[ tri.colorID ];
            r = _r( color );
            g = _g( color );
            b = _b( color );
            col[ c++ ] = r;
            col[ c++ ] = g;
            col[ c++ ] = b;
            col[ c++ ] = r;
            col[ c++ ] = g;
            col[ c++ ] = b;
            col[ c++ ] = r;
            col[ c++ ] = g;
            col[ c++ ] = b;
            ib[ k ] = k++;
            ib[ k ] = k++;
            ib[ k ] = k++;
        }
    }
    function ready(){
        createPath();
        sceneSetup();
    }
    function createPath(){
        var path = new RenderPath();
        path.commands = function() {
            path.setTarget( "" );
            path.clearTarget( 0xff6495ED, 1.0 );
            path.drawMeshes( meshName );
        };
        RenderPath.setActive( path );
    }
    function sceneSetup(){
        raw = {
            name: sceneName,
            shader_datas: [],
            material_datas: [],
            mesh_datas: [],
            objects: []
        }
        Data.cachedSceneRaws.set( raw.name, raw );
        Scene.create(raw, sceneReady);
    }
    function triangleMeshCreate(): TMeshData{
        return {  name: "TriangleMesh"
               ,  vertex_arrays: [   { attrib: "pos", size: 3, values: vb }
                                   , { attrib:"col", size: 3, values: col }
                                   ]
               ,  index_arrays: [ { material: 0, values: ib } ] };
    }
    function materialDataCreate(): TMaterialData {
        return { name: "MyMaterial", shader: "MyShader",contexts: [{ name: meshName, bind_constants: [] }] };
              // , contexts: [{ name: meshName, bind_constants: [ { name: "color", vec3: col } ] }] };
    }
    function shaderDataCreate(): TShaderData {
        return { name: "MyShader",
                 contexts: [{  name: meshName
                             , vertex_shader: "mesh2.vert"
                             , fragment_shader: "mesh2.frag"
                             , compare_mode: "less"
                             , cull_mode: "clockwise"
                             , depth_write: true
                             /*, constants: [ { name: "color", type: "vec3" } ]*/   
                             , vertex_structure: [ {name:"pos",size:3 }
                                                 , {name:"col",size:3 } ]   
                             }]
        };
    }
    function sceneReady( scene: Object ) {
        var mesh = triangleMeshCreate();
        raw.mesh_datas.push( mesh );
        MeshData.parse( raw.name, mesh.name, function( res: MeshData ){
            raw.shader_datas.push( shaderDataCreate() );
            var md = materialDataCreate();
            raw.material_datas.push( md );
            MaterialData.parse( raw.name, md.name, function( res: MaterialData ){ dataReady(); } ); 
        });
    }
    function meshObjectCreate(): TObj {
        return { name:     "Triangles"
               , type:     "mesh_object"
               , data_ref: "TriangleMesh"
               , material_refs: ["MyMaterial"]
               , transform: null
               };
    }
    function dataReady() {
        var tri = meshObjectCreate();
        raw.objects.push( tri );
        Scene.active.parseObject( raw.name, tri.name, null, function( o: Object ) { trace( 'Triangle ready' ); });
    }
    public static inline function _r( int: Int ) : Float
        return ((int >> 16) & 255) / 255;
 
    public static inline function _g( int: Int ) : Float
        return ((int >> 8) & 255) / 255;
 
    public static inline function _b( int: Int ) : Float
        return (int & 255) / 255;
}