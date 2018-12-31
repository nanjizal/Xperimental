package iron.helper;
import trilateral.tri.Triangle;
import trilateral.tri.TriangleArray;
import kha.arrays.Float32Array;
import kha.arrays.Uint32Array;
import iron.data.*;
import iron.data.SceneFormat;
import kha.Color;
class TextureColorMesh {
    inline static var vert =         'painter_image_iron.vert';
    inline static var frag =         'painter_image_iron.frag';
    inline static var materialName = 'ImageColorMaterial';
    inline static var shaderName   = 'ImageColorShader';
    inline static var mesh_object  = 'mesh_object';
    inline static var worldMatrix  = '_worldViewProjectionMatrix';
    public var u: Float->Float;
    public var v: Float->Float;
    var meshName:   String;
    var vb:         Float32Array;
    var tx:         Float32Array;
    var ib:         Uint32Array;
    var col:        Float32Array;
    var wid:        Int;
    var hi:         Int;
    var length:     Int = 0;
    public var z: Float    = 0.;
    var textureName: String;
    var textureFile: String;
    public function new( meshName_: String, wid_: Int, hi_: Int, textureName_: String, textureFile_: String  ){
        meshName = meshName_;
        wid = wid_;
        hi = hi_;
        textureName = textureName_;
        textureFile = textureFile_;
        // rescales ( -1 to 1  ) to ( 0 to 1 )
        var from01 = function( x: Float ){
            return ( x + 0.5 )*0.5;
        }
        u = from01;
        v = from01; 
    }
    public function draw( triangles: TriangleArray, colors: Array<Color> ){
        var tri: Triangle;
        var len = length + Std.int( triangles.length );
        vb  = new Float32Array( Std.int( 9*len ) );
        ib  = new Uint32Array(  Std.int( 3*len ) );
        tx  = new Float32Array( Std.int( 1*len ) );
        col = new Float32Array( Std.int( 12*len ) );
        var j = 0;
        var k = 0;
        var c = 0;
        var t = 0;
        var scaleX = 1/wid;
        var scaleY = 1/hi;
        var offX = wid/2;
        var offY = hi/2;
        var color: Int;
        var a: Float;
        var r: Float;
        var g: Float;
        var b: Float;
        var ax: Float;
        var ay: Float;
        var bx: Float;
        var by: Float;
        var cx: Float;
        var cy: Float;
        for( i in length...len ){
            tri = triangles[ i ];
            ax = ( tri.ax - offX ) * scaleX;
            ay = ( tri.ay - offY ) * scaleY;
            bx = ( tri.bx - offX ) * scaleX;
            by = ( tri.by - offY ) * scaleY;
            cx = ( tri.cx - offX ) * scaleX;
            cy = ( tri.cy - offY ) * scaleY;
            vb[ j++ ] =  ax;
            vb[ j++ ] = -ay;
            vb[ j++ ] =  z;
            vb[ j++ ] =  bx;
            vb[ j++ ] = -by;
            vb[ j++ ] =  z;
            vb[ j++ ] =  cx;
            vb[ j++ ] = -cy;
            vb[ j++ ] =  z;
            tx[ t++ ] =  u( ax );
            tx[ t++ ] =  v( ay );
            tx[ t++ ] =  u( bx );
            tx[ t++ ] =  v( by );
            tx[ t++ ] =  u( cx );
            tx[ t++ ] =  v( cy );
            color = colors[ tri.colorID ];
            a = _a( color );
            r = _r( color );
            g = _g( color );
            b = _b( color );
            col[ c++ ] = a;
            col[ c++ ] = r;
            col[ c++ ] = g;
            col[ c++ ] = b;
            col[ c++ ] = a;
            col[ c++ ] = r;
            col[ c++ ] = g;
            col[ c++ ] = b;
            col[ c++ ] = a;
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
                                   , { attrib: "col", size: 4, values: col }
                                   , { attrib: "uvs", size: 3, values: tx }
                                   ]
               ,  index_arrays: [ { material: 0, values: ib } ] };
    }
    public function materialDataCreate(): TMaterialData {
        return { name: materialName, shader: shaderName
               , contexts: [ { name: meshName
                             , bind_constants: [] 
                             , bind_textures: [ { "name": textureName , "file": textureFile, "format": "ARGB"  } ] 
                             } ] };
    }
    public function shaderDataCreate(): TShaderData {
        return { name: shaderName,
                 contexts: [{  name:            meshName
                             , vertex_shader:   vert
                             , fragment_shader: frag
                             , compare_mode:    "less"
                             , cull_mode:       "clockwise"
                             , depth_write:     true
                             , constants: [ {   "link": worldMatrix
                                            ,   "name": "WVP"
                                            ,   "type": "mat4" } ]
                             , texture_units: [ { "name": textureName } ]
                             , vertex_structure: [ { name: "pos", size: 3 }
                                                 , { name: "col", size: 4 }
                                                 , { name: "uvs", size: 2 }, ]   
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
    public static inline function _a( int: Int ) : Float
        return ((int >> 24) & 255) / 255;
    public static inline function _r( int: Int ) : Float
        return ((int >> 16) & 255) / 255;
    public static inline function _g( int: Int ) : Float
        return ((int >> 8) & 255) / 255;
    public static inline function _b( int: Int ) : Float
        return (int & 255) / 255;
}