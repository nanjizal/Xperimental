package iron.helper;
import trilateral.tri.Triangle;
import trilateral.tri.TriangleArray;
import kha.arrays.Float32Array;
import kha.arrays.Uint32Array;
import iron.data.*;
import iron.data.SceneFormat;
import trilateral.arr.ArrayPairs;
import kha.Color;
class MultiColorMesh {
    inline static var vert =         'painter_colored_iron.vert';
    inline static var frag =         'painter_colored_iron.frag';
    inline static var materialName = 'MultiColorMaterial';
    inline static var shaderName   = 'MultiColorShader';
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
    var depth: Float;
    var fractionColor: Float;
    var randomColors: Bool = false;
    public function new( meshName_: String
                        , wid_: Int, hi_: Int
                        , depth_: Float
                        , fractionColor_: Float
                        , randomColors_: Bool ){
        meshName = meshName_;
        wid = wid_;
        hi = hi_;
        depth = depth_;
        fractionColor = fractionColor_;
        randomColors = randomColors_;
    }
    public function draw( triangles: TriangleArray
                        , contours: Array<Array<Float>>
                        , colors: Array<Color>
                        , contourColors: Array<Int> ){
        var tri: Triangle;
        var clen = 0;
        for( i in 0...contours.length ){
            clen += contours[ i ].length*2*2; // x2 as reversed
        }
        var len = length + Std.int( triangles.length );
        vb  = new kha.arrays.Float32Array( Std.int( 9*( len*2 + clen ) ) );
        ib  = new kha.arrays.Uint32Array(  Std.int( 3*( len*2 + clen ) ) );
        col = new kha.arrays.Float32Array( Std.int( 9*( len*2 + clen ) ) );
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
        var z0 = z + depth/2;
        var z1 = z - depth/2 - 0.01;
        for( i in length...len ){
            tri = triangles[ i ];
            vb[ j++ ] = ( tri.ax - offX ) * scaleX;
            vb[ j++ ] = -( tri.ay - offY ) * scaleY;
            vb[ j++ ] = z0;
            vb[ j++ ] = ( tri.bx - offX ) * scaleX;
            vb[ j++ ] = -( tri.by - offY ) * scaleY;
            vb[ j++ ] = z0;
            vb[ j++ ] = ( tri.cx - offX ) * scaleX;
            vb[ j++ ] = -( tri.cy - offY ) * scaleY;
            vb[ j++ ] = z0;
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
            // back
            vb[ j++ ] = ( tri.bx - offX ) * scaleX;
            vb[ j++ ] = -( tri.by - offY ) * scaleY;
            vb[ j++ ] = z1;            
            vb[ j++ ] = ( tri.ax - offX ) * scaleX;
            vb[ j++ ] = -( tri.ay - offY ) * scaleY;
            vb[ j++ ] = z1;
            vb[ j++ ] = ( tri.cx - offX ) * scaleX;
            vb[ j++ ] = -( tri.cy - offY ) * scaleY;
            vb[ j++ ] = z1;
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
        r = 1.;
        g = 1.;
        b = 1.;
        for( contour in 0...contours.length ){
            tri = triangles[ contour ];
            if( randomColors ){} else {
                color = colors[ contourColors[ contour ] ];
                r = _r( color )*fractionColor;
                g = _g( color )*fractionColor;
                b = _b( color )*fractionColor;
            }
            var pairs = new ArrayPairs( contours[ contour ] );
            var p0: { x: Float, y: Float };
            var p1: { x: Float, y: Float };
            var count = triangles.length;
            for( i in 0...pairs.length-1 ){
                p0 = pairs[ i ];
                p1 = pairs[ i + 1 ];
                vb[ j++ ] = ( p0.x - offX ) * scaleX;
                vb[ j++ ] = -( p0.y - offY ) * scaleY;
                vb[ j++ ] = z0;
                vb[ j++ ] = ( p1.x - offX ) * scaleX;
                vb[ j++ ] = -( p1.y - offY ) * scaleY;
                vb[ j++ ] = z0;
                vb[ j++ ] = ( p0.x - offX ) * scaleX;
                vb[ j++ ] = -( p0.y - offY ) * scaleY;
                vb[ j++ ] = z1;
                // reversed                
                vb[ j++ ] = ( p1.x - offX ) * scaleX;
                vb[ j++ ] = -( p1.y - offY ) * scaleY;
                vb[ j++ ] = z0;
                vb[ j++ ] = ( p0.x - offX ) * scaleX;
                vb[ j++ ] = -( p0.y - offY ) * scaleY;
                vb[ j++ ] = z0;
                vb[ j++ ] = ( p0.x - offX ) * scaleX;
                vb[ j++ ] = -( p0.y - offY ) * scaleY;
                vb[ j++ ] = z1;
                if( randomColors ){
                    color = colors[ randomValue( colors.length ) ];
                    r = _r( color )*fractionColor;
                    g = _g( color )*fractionColor;
                    b = _b( color )*fractionColor;
                }
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
                // reversed 
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
                // Second triangle for contour
                vb[ j++ ] = ( p1.x - offX ) * scaleX;
                vb[ j++ ] = -( p1.y - offY ) * scaleY;
                vb[ j++ ] = z0;                
                vb[ j++ ] = ( p1.x - offX ) * scaleX;
                vb[ j++ ] = -( p1.y - offY ) * scaleY;
                vb[ j++ ] = z1;
                vb[ j++ ] = ( p0.x - offX ) * scaleX;
                vb[ j++ ] = -( p0.y - offY ) * scaleY;
                vb[ j++ ] = z1;
                // reversed 
                vb[ j++ ] = ( p1.x - offX ) * scaleX;
                vb[ j++ ] = -( p1.y - offY ) * scaleY;
                vb[ j++ ] = z1;
                vb[ j++ ] = ( p1.x - offX ) * scaleX;
                vb[ j++ ] = -( p1.y - offY ) * scaleY;
                vb[ j++ ] = z0;
                vb[ j++ ] = ( p0.x - offX ) * scaleX;
                vb[ j++ ] = -( p0.y - offY ) * scaleY;
                vb[ j++ ] = z1;
                if( randomColors ){
                    color = colors[ randomValue( colors.length ) ];
                    r = _r( color )*fractionColor;
                    g = _g( color )*fractionColor;
                    b = _b( color )*fractionColor;
                }
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
                // reversed
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
    }
    public inline function randomValue( len: Float ): Int{
        return Std.int( Math.round( Math.random()*(len-1) ) );
    }
    public function triangleMeshCreate(): TMeshData{
        return {  name: meshName
               ,  vertex_arrays: [   { attrib: "pos", size: 3, values: vb }
                                   , { attrib: "col", size: 3, values: col }
                                   ]
               ,  index_arrays: [ { material: 0, values: ib } ] };
    }
    public function materialDataCreate(): TMaterialData {
        return { name: materialName, shader: shaderName, contexts: [{ name: meshName, bind_constants: [] }] };
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
                             , vertex_structure: [ { name: "pos", size: 3 }
                                                 , { name: "col", size: 3 } ]   
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