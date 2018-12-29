package iron.helper;
import trilateral.tri.Triangle;
import trilateral.tri.TriangleArray;
import kha.arrays.Float32Array;
import kha.arrays.Uint32Array;
import iron.data.*;
import iron.data.SceneFormat;
import kha.Color;
class MultiColorMesh{
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
        wid = wid_;
        hi = hi_;
    }
    public function draw( triangles: TriangleArray, colors: Array<Color> ){
        var tri: Triangle;
        var len = length + Std.int( triangles.length );
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
    public function triangleMeshCreate(): TMeshData{
        return {  name: meshName
               ,  vertex_arrays: [   { attrib: "pos", size: 3, values: vb }
                                   , { attrib: "col", size: 3, values: col }
                                   ]
               ,  index_arrays: [ { material: 0, values: ib } ] };
    }
    public function materialDataCreate(): TMaterialData {
        return { name: "MultiColorMaterial", shader: "MultiColorShader",contexts: [{ name: meshName, bind_constants: [] }] };
    }
    public function shaderDataCreate(): TShaderData {
        return { name: "MultiColorShader",
                 contexts: [{  name: meshName
                             , vertex_shader:   "painter_colored_iron.vert"
                             , fragment_shader: "painter_colored_iron.frag"
                             , compare_mode: "less"
                             , cull_mode: "clockwise"
                             , depth_write: true
                             , constants: [ {
                                 "link": "_worldViewProjectionMatrix",
                                 "name": "WVP",
                                 "type": "mat4"
                              } ]   
                             , vertex_structure: [ { name: "pos", size: 3 }
                                                 , { name: "col", size: 3 } ]   
                             }]
        };
    }
    public function meshObjectCreate( objName: String = 'Triangles' ): TObj {
        return { name:     objName
               , type:     "mesh_object"
               , data_ref: meshName
               , material_refs: [ "MultiColorMaterial" ]
               , transform: null
               };
    }
    public static inline function _r( int: Int ) : Float
        return ((int >> 16) & 255) / 255;
 
    public static inline function _g( int: Int ) : Float
        return ((int >> 8) & 255) / 255;
 
    public static inline function _b( int: Int ) : Float
        return (int & 255) / 255;
}