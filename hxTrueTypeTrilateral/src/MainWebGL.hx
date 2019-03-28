package;
import js.Browser;
import trilateral.tri.Triangle;
import trilateral.tri.TrilateralArray;
import trilateral.geom.Contour;
import trilateral.tri.TriangleArray;
import trilateral.tri.TrilateralPair;
import trilateral.path.Fine;
import trilateral.arr.ArrayPairs;
import htmlHelper.canvas.CanvasWrapper;
import htmlHelper.tools.AnimateTimer;
import js.html.Event;
import js.html.KeyboardEvent;
import js.html.MouseEvent;
import trilateralXtra.color.AppColors;
import trilateral.polys.Shapes;
import khaMath.Vector4;
import trilateral.angle.Angles;
import trilateral.polys.Poly;
import trilateralXtra.parsing.FillDrawTess2;
import hxGeomAlgo.Tess2;
import trilateral.parsing.FillDraw;
import truetype.TTFGlyphUtils;
import format.ttf.Data;
import haxe.io.BytesInput;
import trilateral.path.Base;
import trilateral.path.FillOnly;
import trilateral.justPath.transform.ScaleContext;
import trilateral.justPath.transform.ScaleTranslateContext;
import trilateral.justPath.transform.TranslationContext;
import htmlHelper.webgl.WebGLSetup;
import shaders.Shaders;
import khaMath.Matrix4;
using htmlHelper.webgl.WebGLSetup;
class MainWebGL extends WebGLSetup {
    var distance       = 50;
    var shapes:        Shapes;
    var trianglesIn    = new TriangleArray();
    var triangles      = new TriangleArray();
    var setMatrix:              Matrix4->Void;
    var theta          = 0.;
    var mousePos:      Vector4;
    var centreX:       Float;
    var centreY:       Float;
    var scale:         Float;
    var thickness:     Float;
    var path:          Base;
    var fractionColor  = 1/2.2;
    var z0             = -0.1;
    var z1             = 0.1;
    public static inline var fl: Float = 420;
    public inline static var stageRadius: Int = 570;
    var appColors:     Array<AppColors> = [  Black, Red
                                           , Orange, Yellow
                                           , Green, Blue
                                           , Indigo, Violet
                                           , LightGrey, MidGrey
                                           , DarkGrey, NearlyBlack
                                           , White ];
    public static function main(){ new MainWebGL(); }
    public function new(){
        super( stageRadius*2, stageRadius*2 );
        scale = 1/(stageRadius);
        darkBackground();
        modelViewProjection = Matrix4.identity();
        setupProgram( Shaders.vertex, Shaders.fragment );
        shapes   = new Shapes( triangles, appColors );
        mousePos = new Vector4( 100, 100, 0 );
        setupExperiments();
    }
    inline
    function setupExperiments(){
        var bytes = haxe.Resource.getBytes("font");
        var bytesInput = new BytesInput(bytes);
        var ttfReader:format.ttf.Reader = new format.ttf.Reader(bytesInput);
        var ttf:TTF = ttfReader.read();
        var fontUtils = new TTFGlyphUtils(ttf);
        var haxe = 'Haxe';
        var haxeLetters = haxe.split('');
        path = new Fine( null, null, both );
        path.width = 2;
        for( letter in haxeLetters ) displayGlyph( letter.charCodeAt(0) - 28, fontUtils, 4 );
        setTriangles( triangles, cast appColors, cast Orange );
        setAnimate();
    }
    public var pos = 0;
    public function displayGlyph( index:Int, utils:TTFGlyphUtils, displayScale = 4 ) {
        var glyph:GlyphSimple = utils.getGlyphSimple(index);
        if (glyph == null) return;
        var glyphHeader:GlyphHeader = utils.getGlyphHeader(index);
        var contours = utils.getGlyphContours(index);
        var scale: Float = (64 / utils.headdata.unitsPerEm) * displayScale;
        var x = ( pos * 172. ) + 172*4*scale;
        pos++;
        var y = -768/2;
        var pathModify = path;
        var dy = utils.headdata.yMax;
        var point = contours[0][0];
        for( contour in contours ){
            var offCurvePoint: ContourPoint = null;
            for( i in 0...contour.length ){
                point = contour[ i ];
                if (i == 0 ){
                    pathModify.moveTo( scale*point.x + x, scale*point.y + y);
                } else {
                    var prevPoint = contour[ i - 1 ];
                    if( point.onCurve ) {
                        if( prevPoint.onCurve ){
                            pathModify.lineTo( scale*point.x + x, scale*point.y + y );
                        } else {
                            pathModify.quadTo( scale*offCurvePoint.x + x, scale*offCurvePoint.y + y
                                , scale*point.x + x, scale*point.y + y);
                        }
                    } else {
                        offCurvePoint = contour[ i ];
                    }
                }
            }
            pathModify.moveTo( scale*point.x + x, scale*point.y + y);
        }
        var fillDraw = new FillDrawTess2( 1024, 768 );
        fillDraw.triangles = triangles;
        fillDraw.fill( path.points, findColorID( Orange ) );
        triangles.addArray( 7
                          , path.trilateralArray
                          , findColorID( Yellow ) );
    }
    function setTriangles( triangles: Array<Triangle>, triangleColors:Array<UInt>, edgeColor: UInt ) {
        var rgb: RGB;
        var colorAlpha = 1.;
        var tri: Triangle;
        var count = 0;
        var i: Int = 0;
        var c: Int = 0;
        var j: Int = 0;
        var ox: Float = -1.0;
        var oy: Float = -1.0;
        var no: Int   = 0;
        var px        = 0.;
        var py        = 0.;
        var qx        = 0.;
        var qy        = 0.;
        var r         = 0.;
        var g         = 0.;
        var b         = 0.;
        var edges = path.getEdges();
        for( contour in 0...edges.length ){
            tri = triangles[ contour ];
            var pairs = new ArrayPairs( edges[ contour ] );
            var p0: { x: Float, y: Float };
            var p1: { x: Float, y: Float };
            rgb = WebGLSetup.toRGB( edgeColor );
            r = rgb.r*fractionColor;
            g = rgb.g*fractionColor;
            b = rgb.b*fractionColor;
            for( p in 0...pairs.length-1 ){
                p0 = pairs[ p ];
                p1 = pairs[ p + 1 ];
                px = p0.x * scale + ox;
                py = -p0.y * scale + oy;
                qx = p1.x * scale + ox;
                qy = -p1.y * scale + oy;
                // remove extremes
                if( px < -1. ) continue;
                if( py < -1. ) continue;
                if( qx < -1. ) continue;
                if( qy < -1. ) continue;
                if( px > 1. ) continue;
                if( py > 1. ) continue;
                if( qx > 1. ) continue;
                if( qy > 1. ) continue;
                vertices[ i++ ] = px;
                vertices[ i++ ] = py;
                vertices[ i++ ] = z0;
                vertices[ i++ ] = qx;
                vertices[ i++ ] = qy;
                vertices[ i++ ] = z0;
                vertices[ i++ ] = px;
                vertices[ i++ ] = py;
                vertices[ i++ ] = z1;
                vertices[ i++ ] = qx;
                vertices[ i++ ] = qy;
                vertices[ i++ ] = z0;
                vertices[ i++ ] = px;
                vertices[ i++ ] = py;
                vertices[ i++ ] = z0;
                vertices[ i++ ] = qx;
                vertices[ i++ ] = qy;
                vertices[ i++ ] = z1;
                vertices[ i++ ] = qx;
                vertices[ i++ ] = qy;
                vertices[ i++ ] = z0;
                vertices[ i++ ] = qx;
                vertices[ i++ ] = qy;
                vertices[ i++ ] = z1;
                vertices[ i++ ] = px;
                vertices[ i++ ] = py;
                vertices[ i++ ] = z1;
                vertices[ i++ ] = qx;
                vertices[ i++ ] = qy;
                vertices[ i++ ] = z1;
                vertices[ i++ ] = qx;
                vertices[ i++ ] = qy;
                vertices[ i++ ] = z0;
                vertices[ i++ ] = px;
                vertices[ i++ ] = py;
                vertices[ i++ ] = z1;
                for( k in 0...3 ){
                    colors[ c++ ] = r;
                    colors[ c++ ] = g;
                    colors[ c++ ] = b;
                    colors[ c++ ] = colorAlpha;
                    indices[ j++ ] = count++;
                    colors[ c++ ] = r;
                    colors[ c++ ] = g;
                    colors[ c++ ] = b;
                    colors[ c++ ] = colorAlpha;
                    indices[ j++ ] = count++;
                    colors[ c++ ] = r;
                    colors[ c++ ] = g;
                    colors[ c++ ] = b;
                    colors[ c++ ] = colorAlpha;
                    indices[ j++ ] = count++;
                    colors[ c++ ] = r;
                    colors[ c++ ] = g;
                    colors[ c++ ] = b;
                    colors[ c++ ] = colorAlpha;
                    indices[ j++ ] = count++;
                }
            }
        }
        var ax = 0.;
        var ay = 0.;
        var bx = 0.;
        var by = 0.;
        var cx = 0.;
        var cy = 0.;
        for( tri in triangles ){
                ax = tri.ax*scale + ox;
                ay = -tri.ay*scale + oy;
                bx = tri.bx*scale + ox;
                by = -tri.by*scale + oy;
                cx = tri.cx*scale + ox;
                cy = -tri.cy*scale + oy;
                vertices[ i++ ] = ax;
                vertices[ i++ ] = ay;
                vertices[ i++ ] = z0;
                vertices[ i++ ] = cx;
                vertices[ i++ ] = cy;
                vertices[ i++ ] = z0;
                vertices[ i++ ] = bx;
                vertices[ i++ ] = by;
                vertices[ i++ ] = z0;
                vertices[ i++ ] = ax;
                vertices[ i++ ] = ay;
                vertices[ i++ ] = z0;
                vertices[ i++ ] = bx;
                vertices[ i++ ] = by;
                vertices[ i++ ] = z0;
                vertices[ i++ ] = cx;
                vertices[ i++ ] = cy;
                vertices[ i++ ] = z0;
                vertices[ i++ ] = ax;
                vertices[ i++ ] = ay;
                vertices[ i++ ] = z1;
                vertices[ i++ ] = cx;
                vertices[ i++ ] = cy;
                vertices[ i++ ] = z1;
                vertices[ i++ ] = bx;
                vertices[ i++ ] = by;
                vertices[ i++ ] = z1;
                vertices[ i++ ] = ax;
                vertices[ i++ ] = ay;
                vertices[ i++ ] = z1;
                vertices[ i++ ] = bx;
                vertices[ i++ ] = by;
                vertices[ i++ ] = z1;
                vertices[ i++ ] = cx;
                vertices[ i++ ] = cy;
                vertices[ i++ ] = z1;
            if( tri.mark != 0 ){
                rgb = WebGLSetup.toRGB( triangleColors[ tri.mark ] );
            } else {
                rgb = WebGLSetup.toRGB( triangleColors[ tri.colorID ] );
            }
            r = rgb.r;
            g = rgb.g;
            b = rgb.b;
            for( k in 0...3 ){
                colors[ c++ ] = r;
                colors[ c++ ] = g;
                colors[ c++ ] = b;
                colors[ c++ ] = colorAlpha;
                indices[ j++ ] = count++;
                
                colors[ c++ ] = r;
                colors[ c++ ] = g;
                colors[ c++ ] = b;
                colors[ c++ ] = colorAlpha;
                indices[ j++ ] = count++;
            
                colors[ c++ ] = r;
                colors[ c++ ] = g;
                colors[ c++ ] = b;
                colors[ c++ ] = colorAlpha;
                indices[ j++ ] = count++;
            
                colors[ c++ ] = r;
                colors[ c++ ] = g;
                colors[ c++ ] = b;
                colors[ c++ ] = colorAlpha;
                indices[ j++ ] = count++;
            }
        }
        gl.uploadDataToBuffers( program, vertices, colors, indices );
    }
    function darkBackground(){
        var dark = 0x18/256;
        bgRed   = dark;
        bgGreen = dark;
        bgBlue  = dark;
    }
    inline
    function findColorID( col: AppColors ){
        return appColors.indexOf( col );
    }
    public inline
    function setAnimate(){
        AnimateTimer.onFrame = ( i: Int ) -> render();
        AnimateTimer.create();
    }
    override public 
    function render(){
        modelViewProjection = spin();
        super.render();
    }
    inline function spin(): Matrix4{
        if( theta > Math.PI ) theta = -Math.PI;
        return Matrix4.rotationZ( theta += Math.PI/100 ).multmat( Matrix4.rotationY( theta ) );
    }
}
