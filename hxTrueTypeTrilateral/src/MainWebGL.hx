package;
import js.Browser;
import trilateral.tri.Triangle;
import trilateral.tri.TrilateralArray;
import trilateral.geom.Contour;
import trilateral.tri.TriangleArray;
import trilateral.tri.TrilateralPair;
import trilateral.path.Fine;
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
    var fillDraw:      FillDraw;
    var fillDrawIn:    FillDraw;
    var scale:         Float;
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
        super( stageRadius*2, stageRadius*2 );
        scale = 1/(stageRadius);
        darkBackground();
        modelViewProjection = Matrix4.identity();
        setupProgram( Shaders.vertex, Shaders.fragment );
        shapes   = new Shapes( triangles, appColors );
        mousePos = new Vector4( 100, 100, 0 );
        fillDraw = new FillDrawTess2( 1024, 768 );
        fillDrawIn = new FillDrawTess2( 1024, 768 );
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
        for( letter in haxeLetters ){
            displayGlyph( letter.charCodeAt(0) - 28, fontUtils, 4 );
        }
    }
    public var pos = 0;
    public function displayGlyph( index:Int, utils:TTFGlyphUtils, displayScale = 4 ) {
        var glyph:GlyphSimple = utils.getGlyphSimple(index);
        if (glyph == null) return;
        var glyphHeader:GlyphHeader = utils.getGlyphHeader(index);
        var contours = utils.getGlyphContours(index);
        var scale: Float = (64 / utils.headdata.unitsPerEm) * displayScale;
        var path = new Fine( null, null, both );
        path.width = 2;
        var x = ( pos * 172. ) + 172*4*scale;
        pos++;
        var y = -768/2;
        var pathModify = path;
        var dy = utils.headdata.yMax;
        for( contour in contours ){
            var offCurvePoint: ContourPoint = null;
            for (i in 0...contour.length) {
                var point = contour[i];
                if (i == 0) {
                    pathModify.moveTo( scale*point.x + x, scale*point.y + y);
                } else {
                    var prevPoint = contour[i - 1];
                    if (point.onCurve) {
                        if (prevPoint.onCurve) {
                            pathModify.lineTo( scale*point.x + x, scale*point.y + y );
                        } else {
                            pathModify.quadTo( scale*offCurvePoint.x + x, scale*offCurvePoint.y + y
                                , scale*point.x + x, scale*point.y + y);
                        }
                    } else {
                        offCurvePoint = contour[i];
                    }
                }
            }
        }
        fillDraw.triangles = triangles;
        fillDraw.fill( path.points, findColorID( Orange ) );
        fillDrawIn.triangles = trianglesIn;
        fillDrawIn.fill( path.points, findColorID( Orange ) );
        triangles.addArray( 7
                          , path.trilateralArray
                          , findColorID( Yellow ) );
        trianglesIn.addArray( 7
                            , path.trilateralArray
                            , findColorID( Yellow ) );
        triangles = trianglesIn.concat( triangles );
        
        setTriangles( triangles, cast appColors );
        setAnimate();
    }
    function setTriangles( triangles: Array<Triangle>, triangleColors:Array<UInt> ) {
        var rgb: RGB;
        var colorAlpha = 1.;
        var tri: Triangle;
        var count = 0;
        var i: Int = 0;
        var c: Int = 0;
        var j: Int = 0;
        var ox: Float = -1.0;
        var oy: Float = -1.0;
        var no: Int = 0;
        for( tri in triangles ){
                vertices[ i++ ] = tri.ax*scale + ox;
                vertices[ i++ ] = -tri.ay*scale + oy;
                vertices[ i++ ] = tri.depth* theta;
                vertices[ i++ ] = tri.cx*scale + ox;
                vertices[ i++ ] = -tri.cy*scale + oy;
                vertices[ i++ ] = tri.depth* theta;
                vertices[ i++ ] = tri.bx*scale + ox;
                vertices[ i++ ] = -tri.by*scale + oy;
                vertices[ i++ ] = tri.depth * theta;
                vertices[ i++ ] = tri.ax*scale + ox;
                vertices[ i++ ] = -tri.ay*scale + oy;
                vertices[ i++ ] = tri.depth* theta;
                vertices[ i++ ] = tri.bx*scale + ox;
                vertices[ i++ ] = -tri.by*scale + oy;
                vertices[ i++ ] = tri.depth* theta;
                vertices[ i++ ] = tri.cx*scale + ox;
                vertices[ i++ ] = -tri.cy*scale + oy;
                vertices[ i++ ] = tri.depth * theta;
            if( tri.mark != 0 ){
                rgb = WebGLSetup.toRGB( triangleColors[ tri.mark ] );
            } else {
                rgb = WebGLSetup.toRGB( triangleColors[ tri.colorID ] );
            }
            for( k in 0...3 ){
                colors[ c++ ] = rgb.r;
                colors[ c++ ] = rgb.g;
                colors[ c++ ] = rgb.b;
                colors[ c++ ] = colorAlpha;
                indices[ j++ ] = count++;
                colors[ c++ ] = rgb.r;
                colors[ c++ ] = rgb.g;
                colors[ c++ ] = rgb.b;
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