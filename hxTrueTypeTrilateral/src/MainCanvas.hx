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
import justDrawing.Surface;
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
import khaMath.Matrix4;
class MainCanvas {
    var surface:       Surface;
    var distance       = 50;
    var canvas         = new CanvasWrapper();
    var shapes:        Shapes;
    var trianglesIn    = new TriangleArray();
    var triangles      = new TriangleArray();
    var mousePos:      Vector4;
    var centreX:       Float;
    var centreY:       Float;
    var fillDraw:      FillDraw;
    var fillDrawIn:    FillDraw;
    public static inline var fl: Float = 420;
    var appColors:     Array<AppColors> = [  Black, Red
                                           , Orange, Yellow
                                           , Green, Blue
                                           , Indigo, Violet
                                           , LightGrey, MidGrey
                                           , DarkGrey, NearlyBlack
                                           , White ];
    public static function main(){ new MainCanvas(); }
    public function new(){
        var doc = Browser.document;
        canvas.width  = 1024*2;
        canvas.height = 768*2;        
        centreX  = canvas.width/2;
        centreY  = canvas.height/2;
        doc.body.appendChild( cast canvas );
        surface  = new Surface( canvas.getContext2d() );
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
        path.width = 0.2;
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
        AnimateTimer.onFrame = render;
        AnimateTimer.create();
    }  
    inline
    function findColorID( col: AppColors ){
        return appColors.indexOf( col );
    }
    var theta = 0.;
    inline
    function render( i: Int ): Void {
        theta += Math.PI/20;
        rotateXYZ( trianglesIn, triangles, 0, theta, 0, 1024/2, 768/2, -1, -1 );
        drawTriangles();
    }
    // draws triangles to screen, approach similar for WebGL, so some additional complexity worth it.
    function drawTriangles(){
        var tri: Triangle;
        var sx = 0.3;
        var sy = -0.3;
        var ox = 1024/4;
        var oy = 768/4;
        var g = surface;
        g.beginFill( 0x181818, 1. );
        g.lineStyle( 0., 0x000000, 0. );
        g.drawRect( 1, 1, 2*1024-2, 2*768-2 );
        g.endFill();
        var triangles = triangles;
        var triangleColors = appColors;
        for( i in 0...triangles.length ){
            tri = triangles[ i ];
            if( tri.mark != 0 ){
                g.beginFill( triangleColors[ tri.mark ] );
            } else {
                g.beginFill( triangleColors[ tri.colorID ] );
                g.lineStyle( 0., triangleColors[ tri.colorID ], 1. );
            }
            g.drawTri( [   ox + tri.ax * sx, oy + tri.ay * sy
                        ,  ox + tri.bx * sx, oy + tri.by * sy
                        ,  ox + tri.cx * sx, oy + tri.cy * sy ] );
            g.endFill();
        }
    }
    public static
    function rotateXYZ( refTriangles: TriangleArray, targetTriangles: TriangleArray, 
                        rX: Float, rY: Float, rZ: Float, ox: Float, oy: Float, oz: Float, zSpecial: Float ){
        var sX = Math.sin( rX ); 
        var sY = Math.sin( rY ); 
        var sZ = Math.sin( rZ );
        var cX = Math.cos( rX ); 
        var cY = Math.cos( rY ); 
        var cZ = Math.cos( rZ );
        var x: Float;
        var y: Float;
        var z: Float;
        var x2: Float;
        var y2: Float;
        var z2: Float;
        var tx: Float;
        var ty: Float;
        var tz: Float;
        var ax_: Float;
        var bx_: Float;
        var cx_: Float;
        var ay_: Float;
        var by_: Float;
        var cy_: Float;
        var s: Float;
        var fL = fl;
        var tin:  Triangle;
        var tout: Triangle; 
        for( i in 0...refTriangles.length ){
            tin = refTriangles[i];
            tout = targetTriangles[i]; 
            tx = tin.ax - ox;
            ty = tin.ay - oy;
            tz = zSpecial - oz;
            x = tx*cY*cZ + tz*sY - ty*sZ + ox;
            y = ty*cX*cZ -tz*sX + tx*sZ + oy;
            z = ty*sX + tz*cX*cY - tx*sY + oz;
            s = 1-(-z)/fL;
            ax_ = x/s;
            ay_ = y/s;
            tx = tin.bx - ox;
            ty = tin.by - oy;
            tz = zSpecial - oz;
            x = tx*cY*cZ + tz*sY - ty*sZ + ox;
            y = ty*cX*cZ -tz*sX + tx*sZ + oy;
            z = ty*sX + tz*cX*cY - tx*sY + oz;
            s = 1-(-z)/fL;
            bx_ = x/s;
            by_ = y/s;
            tx = tin.cx - ox;
            ty = tin.cy - oy;
            tz = zSpecial - oz;
            x = tx*cY*cZ + tz*sY - ty*sZ + ox;
            y = ty*cX*cZ -tz*sX + tx*sZ + oy;
            z = ty*sX + tz*cX*cY - tx*sY + oz;
            s = 1-(-z)/fL;
            cx_ = x/s;
            cy_ = y/s;
            tout.ax = ax_;
            tout.ay = ay_;
            tout.bx = bx_;
            tout.by = by_;
            tout.cx = cx_;
            tout.cy = cy_;
            tout.windingAdjusted = tout.adjustWinding();
            if( tout.windingAdjusted ){
                tout.ax = ax_;
                tout.ay = ay_;
                tout.bx = cx_;
                tout.by = cy_;
                tout.cx = bx_;
                tout.cy = by_;
            }
        }
    }
}