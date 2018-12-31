package iron.helper;
import trilateral.tri.Triangle;
import trilateral.tri.TriangleArray;
import kha.arrays.Float32Array;
import kha.arrays.Uint32Array;
import iron.data.*;
import iron.data.SceneFormat;
import kha.Color;
class SingleColorMesh {
    inline static var vert =         'painter_single_iron.vert';
    inline static var frag =         'painter_single_iron.frag';
    inline static var materialName = 'SingleColorMaterial';
    inline static var shaderName   = 'SingleColorShader';
    inline static var mesh_object  = 'mesh_object';
    inline static var worldMatrix  = '_worldViewProjectionMatrix';
    var meshName:   String;
    var vb:         Float32Array;
    var ib:         Uint32Array;
    var col:        Float32Array;
    var wid:        Int;
    var hi:         Int;
    var length:     Int = 0;
    var z: Float    = 0.;
    public function new( meshName_: String, wid_: Int, hi_: Int ){
        meshName = meshName_;
        wid      = wid_;
        hi       = hi_;
    }
    public function draw( triangles: TriangleArray, colors: Array<Color> ){
        var tri: Triangle;
        var len = length + Std.int( triangles.length );
        vb  = new Float32Array( Std.int( 9*len ) );
        ib  = new Uint32Array(  Std.int( 3*len ) );
        var j = 0;
        var k = 0;
        var scaleX = 1/wid;
        var scaleY = 1/hi;
        var offX = wid/2;
        var offY = hi/2;
        tri = triangles[ 0 ];
        var color = colors[0];
        col = new kha.arrays.Float32Array(3);
        col[0] = _r( color ); 
        col[1] = _g( color );
        col[2] = _b( color );
        for( i in length...len ){
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
            ib[ k ] = k++;
            ib[ k ] = k++;
            ib[ k ] = k++;
        }
    }
    public function triangleMeshCreate(): TMeshData{
        return {  name: meshName
               ,  vertex_arrays: [ { attrib: "pos", size: 3, values: vb } ]
               ,  index_arrays:  [ { material: 0, values: ib } ] };
    }
    public function materialDataCreate(): TMaterialData {
        return { name: materialName, shader: shaderName
            , contexts: [{ name: meshName, bind_constants: [ { name: "color", vec3: col } ] }] }
    }
    public function shaderDataCreate(): TShaderData {
        return { name: shaderName,
                 contexts: [{  name:            meshName
                             , vertex_shader:   vert
                             , fragment_shader: frag
                             , compare_mode:    "less"
                             , cull_mode:       "clockwise"
                             , depth_write:     true
                             , constants: [ { name: "color", type: "vec3" },
                                            { "link": worldMatrix, "name": "WVP", "type": "mat4" } ]   
                             , vertex_structure: [ { name: "pos", size: 3 } ]   
                             }] };
    }
    public function meshObjectCreate( objName: String = 'Triangles' ): TObj {
        return { name:          objName
               , type:          mesh_object
               , data_ref:      meshName
               , material_refs: [ materialName ]
               , transform:     null
               };
    }
    public static inline function _r( int: Int ) : Float
        return ((int >> 16) & 255) / 255;
    public static inline function _g( int: Int ) : Float
        return ((int >> 8) & 255) / 255;
    public static inline function _b( int: Int ) : Float
        return (int & 255) / 255;
}