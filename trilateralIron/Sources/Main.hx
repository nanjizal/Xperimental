package;

import iron.App;
import iron.Scene;
import iron.RenderPath;
import iron.data.*;
import iron.data.SceneFormat;
import iron.object.Object;
import trilateralXtra.iron.IronMesh;    
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
import kha.Assets;
class Main {
    public static var wid = 800;
    public static var hi  = 600;
    var raw: TSceneFormat;
    var fillDraw: FillDraw;
    public static function main() {
        kha.System.init({title: "Iron with Trilateral", width: wid, height: hi, samplesPerPixel: 4}, function() {
            new Main();
        });
    }
    public function new(){
        fillDraw = new FillDrawPolyK( wid, hi );
        Assets.loadEverything( loadAll );
    }
    function loadAll(){
        var svgStr = Assets.blobs.salsaLogo_svg.toString();
        var nodule: Nodule  = ReadXML.toNodule( svgStr );
        var svg: Svg = new Svg( nodule );
        svg.render( fillDraw );
        var tri: Triangle;
        var triangles   = fillDraw.triangles;
        var colors      = fillDraw.colors;
        var ironMesh    = new IronMesh( "Scene", 'mesh' );
        ironMesh.create( wid, hi, triangles, colors );
    }
}
