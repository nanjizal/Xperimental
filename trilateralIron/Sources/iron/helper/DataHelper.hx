package iron.helper;
import kha.arrays.Float32Array;
import kha.math.FastMatrix4;
class DataHelper {
    public static function m4to32Arr( m: FastMatrix4 ): Float32Array {
        var f = new Float32Array( 16 );
        f.set( 0,  m._00 ); f.set( 1,  m._10 ); f.set( 2,  m._20 ); f.set( 3,  m._30 );
        f.set( 4,  m._01 ); f.set( 5,  m._11 ); f.set( 6,  m._21 ); f.set( 7,  m._31 );
        f.set( 8,  m._02 ); f.set( 9,  m._12 ); f.set( 10, m._22 ); f.set( 11, m._32 );
        f.set( 12, m._03 ); f.set( 13, m._13 ); f.set( 14, m._23 ); f.set( 15, m._33 );
        return f;
    }
	public static function toFloat32Array( src: Array<Float> ) : Float32Array {
		var f = new Float32Array( src.length );
		for (i in 0...src.length) { f.set(i, src[i]); }
		return f;
	}
}