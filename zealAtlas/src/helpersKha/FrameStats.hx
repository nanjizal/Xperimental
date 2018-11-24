package helpersKha;
import kha.Scheduler;
import kha.graphics2.Graphics;
import helpersKha.Interaction;
import kha.Color;
import kha.Font;
import kha.Assets;
class FrameStats{
    public var bgColor:     Color;
    public var foreColor:   Color;
    public var subColor:    Color;
    public var bgAlpha      = 0.15;
    public var foreAlpha    = 0.70;
    var font:               Font;
    var lastFps:            Float = 0;
    var hide:               Bool = false;
    var previous:           Float;
    var realTime:           Float;
    var interaction:        Interaction;
    public var update:      Void -> Void;
    public function new( interaction_: Interaction ){
        bgColor     = Color.Blue;
        foreColor   = Color.White;
        subColor    = Color.Cyan;
        interaction = interaction_;
        font        = Assets.fonts.OpenSans_Regular;
        previous    = 0.0;
        realTime    = 0.0;
        Scheduler.addTimeTask( updateInternal, 0, 1 / 60 );
    }
    inline
    function updateInternal(): Void {
        previous = realTime;
        realTime = Scheduler.realTime();
        if( update != null ) update();
    }
    var cacheFps: String = '';
    var cacheStat: String = '';
    var count = 0;
    inline public
    function render( g2: Graphics ){
        if( hide ) return;
        calculateStat();
        g2.font = font;
        g2.fontSize = 22;
        //var dh = font.height( g2.fontSize );
        g2.color = bgColor;
        g2.opacity = bgAlpha;
        g2.fillRect( 2, 2, 255, 37 );
        g2.color = subColor;
        g2.drawRect( 0, 0, 259, 39, 2 );
        g2.opacity = foreAlpha;
        g2.color = foreColor;
        g2.drawString( cacheFps, 10, 10 );
        g2.fontSize = 15;
        g2.color = subColor;
        g2.drawString( cacheStat, 92, 10 );
        g2.color = foreColor;
        g2.opacity = 1.;
    }
    inline
    function calculateStat(){
        var interactionStat = ( interaction != null )? interaction.stats(): '';
        var fps = 1.0 / ( realTime - previous );
        if( fps != Math.POSITIVE_INFINITY ){
            fps = twoPlaces( fps );
            lastFps = fps;
        } else {
            fps = lastFps;
        }
        if( count++ % 10 == 0 ) {
            cacheFps = 'fps: ' + Std.string( fps + ( lastFps - fps )/4 );
            cacheStat = interactionStat;
            count = 1;
        } else {
        }
    }
    inline
    function twoPlaces( val: Float ): Float {
        var v = Math.round( ( val ) * 100 );
        return ( v == 0 )?0: v/100;
    }
}