package;
import kha.Framebuffer;
import kha.System;
import kha.Image;
import kha.Color;
import kha.Assets;
import kha.Scaler;
import kha.Font;
import kha.Color;
import kha.Assets;
import kha.Scheduler;
import kha.graphics2.Graphics;
import kha.graphics4.DepthStencilFormat;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.KeyCode;
import kha.math.FastMatrix3;
import kha.math.FastMatrix4;
import kha.WindowOptions;
import kha.WindowMode;
import helpersKha.Interaction;
import helpersKha.FrameStats;
import hxRectPack2D.output.BodyFrames;
import kha.math.FastMatrix3;
import kha.math.FastVector2;
import haxe.ds.StringMap;
import leaf.Leaf;
import leaf.Multiped;
import zeal.Zebra;
#if js
import js.Browser;
import js.html.CanvasElement;
#end
class MainApp {
    var frameStats:      FrameStats;
    var interaction:     Interaction;
    var bodyFrames:      BodyFrames;
    var zeal:            Array<Zebra>;
    var showAtlas:       Bool = false;
    var zebraSkin:       Image;
    var scaleZebra:      Float = 0.3;
    var zealSize:        Int = 100;
    var scales =         new Array<Float>();
    public static 
    function main() {
        browserCrap();
        System.init( { title: "demo"
                    ,  width: 1024, height: 768
                    ,  samplesPerPixel: 4 }
                    ,  function(){ new MainApp();
        } );
        // DO NOT REMOVE:
        /*System.start( {  title: "demo" /* newer kha setup *//*
                             ,  width: 1024, height: 768
                             ,  window: { windowFeatures:    FeatureResizable }
                             , framebuffer: { samplesPerPixel: 4 } }
                             , function( window: Window ){
                                new Main();
        } );*/
    }
    public function new(){ Assets.loadEverything( loadAll ); }
    public 
    function loadAll(){
        trace( 'loadAll' );
        Browser.window.dispatchEvent( new js.html.Event('resize') );
        bodyFrames           = spriteSheetData();
        zeal                 = buildZebras( zealSize, bodyFrames );
        zebraSkin            = Assets.images.zebraAtlas;
        interaction          = new Interaction();
        frameStats           = new FrameStats( interaction );
        frameStats.bgColor   = Color.White;
        frameStats.foreColor = Color.fromValue( 0xFF000c00 );
        frameStats.subColor  = Color.fromValue( 0xFF0000aa );
        frameStats.bgAlpha   = 0.7;
        frameStats.foreAlpha = 0.9; 
        var positions        = initPositions();
        for( i in 0...zealSize ) zeal[ i ].attributes = positions[ i ];
        positionZeal();
        frameStats.update    = animateZebra;
        startRendering();
    }
    inline
    function buildZebras( no: Int, bodyFrames: BodyFrames ): Array<Zebra>{
        var arr = new Array<Zebra>();
        var multi = bonesData();
        for( i in 0...no ){
            var multiped    = new Multiped( 250, 250, multi.leaf, bodyFrames );
            arr[ i ]        = new Zebra( multiped.leaves );
        }
        return arr;
    }
    inline
    function initPositions(){
        var dist          = 2000;
        var attributes    = new Array<ZebraAttributes>();
        for( i in 0...zealSize ) {
            var y = Math.round( Math.random()*dist-(dist/2) );
            var direction = ( Math.random() < 0.5 )?true: false;
            attributes.push( { x:     Math.round( Math.random()*dist-(dist/2) )
                            , y:     y - 30
                            , scale: scaleZebra * 150/( 150 - y )
                            , speed: 0.2 + 0.1*Math.random()
                            , direction: direction } );
        }
        depthSort( attributes );
        return attributes;
    }
    inline
    function positionZeal(){
        for( zebra in zeal ){
            var leaf = zebra.body;
            leaf.x   = zebra.attributes.x;
            leaf.y   = zebra.attributes.y;
            leaf.calculate();
        }
    }
    inline
    function spriteSheetData(){
        return new BodyFrames( Assets.blobs.zebra_Atlas_json.toString() );
    }
    inline
    function bonesData(): { leaf: MultipedNode } {
        return haxe.Json.parse( Assets.blobs.zebra_Leaf_json.toString() );
    }
    inline
    function depthSort( attributes: Array<ZebraAttributes> ){
        haxe.ds.ArraySort.sort( attributes, function(a, b):Int {
                                              if( a.y < b.y )      return -1;
                                              else if( a.y > b.y ) return  1;
                                                                   return  0;   });
    }
    inline
    function animateZebra(){
        var leaf: Leaf;
        for( zebra in zeal ){
            var speed = zebra.attributes.speed;
            leaf      = zebra.body;
            leaf.x    = Math.round( leaf.x - speed * 4 );
            leaf.calculate();
            zebra.rotation( speed );
        }
    }
    function startRendering(){
        // DO NOT REMOVE:
        //System.notifyOnFrames( function ( framebuffer ) { render( framebuffer[0] ); } ); // newer Kha setup
       System.notifyOnRender( function ( framebuffer ) { render( framebuffer ); } );
    }
    inline
    function render( framebuffer: Framebuffer ){
        var g2 = framebuffer.g2;
        g2.begin( Color.fromValue( 0xFF222200 ) );
        g2.color = Color.White;
        // if( showAtlas ) g2.drawImage( Assets.images.zebraAtlas, 250, 250 );
        var scaled: Float = 0.5;
        var direction: Bool;
        for( zebra in zeal ){
            var leaves = zebra.leaves;
            scaled     = zebra.attributes.scale;
            direction  = zebra.attributes.direction;
            for( leaf in leaves ) renderLeaf( g2, zebraSkin, leaf, scaled, direction );
        }
        frameStats.render( g2 );
        g2.end();
    }
    inline
    function renderLeaf( g2: Graphics, skin: Image, leaf: Leaf, scale: Float, direction: Bool ){
        var limb    = bodyFrames.limbByName( leaf.textureName );
        var flipped = limb.flipped;
        var cx;
        var cy;
        var rotation;
        if( flipped ){
            rotation =  -Math.PI/2 + leaf.theta;
            cx = leaf.cy;
            cy = leaf.cx;
        } else {
            rotation = leaf.theta;
            cx = leaf.cx;
            cy = leaf.cy;
        }
        var xScale    = ( direction )? scale: -scale;
        var px        = leaf.left + cx;
        var py        = leaf.top  + cy;
        var mScreen   = FastMatrix3.translation( scale*1024, scale*768 );
        var mScale    = FastMatrix3.scale( xScale, scale );
        var mPosition = FastMatrix3.translation( px, py );
        var mRotation = FastMatrix3.rotation( rotation );
        var mCentre   = FastMatrix3.translation( -leaf.w/2, -leaf.h/2 );
        g2.color      = Color.White;
        g2.opacity    = leaf.alpha;
        g2.transformation = mScreen.multmat( mScale    ).multmat( mPosition )
                                   .multmat( mRotation ).multmat( mCentre   );
        g2.drawSubImage( skin, 0, 0, limb.x, limb.y, limb.realW, limb.realH );
        g2.transformation = FastMatrix3.identity();
    }
    //
    //
    //-----------------------------------------------------------------------------------------------
    public static
    function browserCrap(){
        #if js
        var win            = Browser.window;
        var document       = win.document;
        var doc            = document;
        var docElement     = doc.documentElement;
        var docStyle       = docElement.style;
        var bodyStyle      = doc.body.style;
        docStyle.padding   = "0";
        docStyle.margin    = "0";
        bodyStyle.padding  = "0";
        bodyStyle.margin   = "0";
        bodyStyle.color    = "0x9B7031";
        var canvas         = cast( doc.getElementById( "khanvas" ), CanvasElement );
        var canvaStyle     = canvas.style;
        canvaStyle.display = "block";
        var resize = 
        function() {
            var dpRatio     = win.devicePixelRatio;
            canvas.width    = Std.int( win.innerWidth * dpRatio );
            canvas.height   = Std.int( win.innerHeight * dpRatio );
            var nWid        = Std.int( canvas.width  / dpRatio );
            var nHi         = Std.int( canvas.height / dpRatio );
            if( nHi != hi || nWid != wid ){
                wid         = nWid;
                hi          = nHi;
                var size    = ( hi > wid )? wid: hi;
                scale       = size/768;
                canvaStyle.width  = docElement.clientWidth + "px";
                canvaStyle.height = docElement.clientHeight + "px";
                transform         = FastMatrix3.scale( scale, scale );
            }
        }
        win.onresize = resize;
        resize();
        #end
    }
    // more browser crap not used much on this.
    public static var wid:        Int  = 0;
    public static var hi:         Int  = 0;
    public static var transform:  FastMatrix3;
    public static var resize:     Void->Void;
    public static var scale:      Float = 1.;
}