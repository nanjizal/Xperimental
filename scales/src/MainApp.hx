package;
import kha.System;
import kha.Scheduler;
import kha.Assets;
import kha.Framebuffer;
import kha.Color;
import kha.Font;
import kha.Assets;
import kha.audio1.Audio;
import kha.audio1.AudioChannel;
import kha.Sound;
import kha.arrays.Float32Array;
// Based on 
// https://github.com/lewislepton/kha-tutorial-series/blob/master/095_sineWaveDSP/Sources/Project.hx
class MainApp {

    public static var WIDTH = 1024;
    public static var HEIGHT = 768;

    public static function main(){
        System.start( 
            {
                title:"Scales",
                width:WIDTH,
                height:HEIGHT
            },
            function(_){
                Assets.loadEverything( 
                    function(){
                        var m = new MainApp();
                        Scheduler.addTimeTask( m.update, 0, 1/60 );
                        System.notifyOnFrames( function( framebuffer ){ m.render( framebuffer[ 0 ] ); });
                    }
                );
            }
        );
    }
    var sound = new Sound();
    var sndSineWave: AudioChannel;
    var A4 = 440;
    var maxNode = 16;
    var minNode = -16;
    var sampleRate = 48000;
    var frequency = 440.;
    var n = 0;
    var count = 0;
    var direction = 1;
    var onTime = 15;
    var offTime = 2;
    var noteUp: Array<String>;
    var noteDn: Array<String>;
    var font: Font;
    var x: Float = 350.0;
    var dx: Float = .3;
    var dy: Float = 14.;
    var y: Float = 500.;
    var lastY: Float = 300.;
    var lines = new Array<{x0:Float, y0: Float, x1: Float, y1: Float }>();
    public function new(){
        noteUp = [ 'C','C#','D','Eb','E','F','F#','G','G#','A','A#','B'];
        noteDn = [ 'C','Db','D','E','F','Gb','G','Ab','A','Ab','B'];
        font   = Assets.fonts.OpenSans_Regular;
        sound.uncompressedData = new Float32Array( sampleRate );  
        var sampleFrequency = sampleRate / frequency;
        for (i in 0 ... sound.uncompressedData.length){
            sound.uncompressedData[i] = Math.sin(i / (sampleFrequency / (Math.PI * 2)));
        }
        sndSineWave = Audio.play(sound, true);
        sndSineWave.volume = 0.1;
    }

    public function update():Void {
        if( count == onTime ) {
            sndSineWave.stop();
        }
        if( count == offTime + onTime ){
            if( n > maxNode-1 ) {
            direction = -1;
            }
            if( n < minNode+1 ){
                direction = 1;
            }
            n += direction;
            count = 0;
            frequency = Math.pow( 2, n/12 ) * A4;
            var sampleFrequency = sampleRate / frequency;
            for (i in 0 ... sound.uncompressedData.length){
                sound.uncompressedData[ i ] = Math.sin(i / (sampleFrequency / (Math.PI * 2)));
            }
            sndSineWave = Audio.play(sound, true);
            sndSineWave.volume = 0.1;
        }
        count++;
    }
    public function render( framebuffer: Framebuffer ):Void {
        var g2 = framebuffer.g2;
        g2.begin( Color.fromValue(0xFF26004d) );
        var n_: Int = cast Math.abs( n );
        var note = ( direction > 0 )? noteUp[ n_ % 11 ]: noteDn[ n_ % 11 ];
        g2.fontSize = 40;
        g2.font = font;
        g2.color = Color.fromValue( 0xFFFF0000 );
        var f = Math.round( frequency*100 )/100;
        g2.drawString( "Note " + note + ' - ' + f +  " Hz" , 30, 30 );
        var nextX = x + dx;
        var nextY = y - n * dy;
        lines[ lines.length ] = { x0: x, y0: lastY, x1: nextX, y1: nextY };
        var l: { x0: Float, y0: Float, x1: Float, y1: Float };
        g2.drawLine( 10., y, 1000., y, 0.5 );
        for( i in 1...lines.length ){
            l = lines[ i ];
            l.x0 = l.x0 - dx/2;
            l.x1 = l.x1 - dx/2;
            g2.drawLine( l.x0, l.y0, l.x1, l.y1, 1. );
        }
        x = nextX;
        lastY = nextY;
        g2.end();
    }
}