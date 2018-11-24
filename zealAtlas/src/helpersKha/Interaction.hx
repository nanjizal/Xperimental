package helpersKha;
import kha.input.Keyboard;
import kha.input.KeyCode;
import kha.input.Mouse;
import kha.input.KeyCode;
typedef Dragable = {
    var x: Float;
    var y: Float;
    var width: Float;
    var height: Float;
}
class Interaction {
    public var angle:       Float = 0;
    public var left:        Bool;
    public var right:       Bool;
    public var up:          Bool;
    public var down:        Bool;
    public var wheelDelta:  Int;
    public var mouseX:      Int;
    public var mouseY:      Int;
    public var lettersDown: String;
    public var depress =    false; // mouse
    public var dnMouse:     Void -> Void;
    public var move:        Void -> Void;
    public var upMouse:     Void -> Void;
    public var over:        Void -> Void;
    public var keyDepressed: Void -> Void;
    public var wheel:       Void -> Void;
    public var canTrace     = true;
    public var dragCentre   = true;
    var dragOffX:           Float;
    var dragOffY:           Float;
    public var dragItem( default, set ): Dragable;
    public function set_dragItem( dragAble: Dragable ): Dragable {
        dragOffX = dragAble.x - mouseX;
        dragOffY = dragAble.y - mouseY;
        this.dragItem = dragAble;
        return dragAble;
    }
    public function new(){
        traceListeners();
        initInputs();
    }
    function traceListeners(){
        move = function(){
            if( canTrace ) trace( 'mouse ' + mouseX + ', '+ mouseY );
        }
        over = function(){
            // if( canTrace ) trace( 'mouse over' + mouseX + ', '+ mouseY );
        }
        upMouse = function(){
            if( canTrace ) trace( 'mouse up ' + mouseX + ' ' + mouseY );
        }
        dnMouse = function(){
            if( canTrace ) trace( 'mouse down ' + mouseX + ' ' + mouseY );
        }
        wheel = function(){
            if( canTrace ) trace( 'mouse wheel ' + wheelDelta );
        }
        keyDepressed = function(){
            if( canTrace ) {
                trace( 'letters ' + lettersDown );
            }
        }
    }
    function initInputs() {
        if (Mouse.get() != null) Mouse.get().notify( mouseDown, mouseUp, mouseMove, mouseWheel );
        if( Keyboard.get() != null ) Keyboard.get().notify( keyDown, keyUp, null );
    }
    function keyDown( keyCode: Int ): Void {
        addKey( keyCode );
        keyDepressed();
    }
    function keyUp( keyCode: Int ): Void { 
        removeKey( keyCode );
    }
    function mouseDown( button: Int, x: Int, y: Int ): Void {
        mouseX = x;
        mouseY = y;
        if( button == 0 && depress == false ){
            dnMouse();
            depress = true;
        }
    }
    function mouseUp( button: Int, x: Int, y: Int ): Void {
        mouseX = x;
        mouseY = y;
        if( button == 0 ) {
            upMouse();
            depress = false;
        }
    }
    function mouseMove( x: Int, y: Int, movementX: Int, movementY: Int ): Void {
        mouseX = x;
        mouseY = y;
        if( depress ){
            move();
            drag();
        } else {
            over();
        }
    }
    inline function drag(){
        if( dragItem == null ) return;
        dragItem.x = mouseX + dragOffX;
        dragItem.y = mouseY + dragOffY;
        if( dragCentre ){
            var cx = dragItem.x + dragItem.width/2;
            var cy = dragItem.y + dragItem.height/2;
            dragOffX += ( cx - dragOffX )/4;
            dragOffY += ( cy - dragOffY )/4;
        }
    }
    function mouseWheel( delta: Int ): Void {
        wheelDelta = delta;
        wheel();
    }
    function addKey( keyCode: Int ){
        angleByKey( keyCode );
        /*var abc = keyCode < ( 'a'.code - 1 ) && keyCode > ( 'z'.code + 1 );
        var ABC = keyCode < ( 'A'.code - 1 ) && keyCode > ( 'Z'.code + 1 );
        var number = keyCode < ( '0'.code - 1 ) && keyCode > ( '9'.code + 1 );
        var letter = abc && ABC;
        if( letter ) lettersDown += String.fromCharCode( keyCode );*/
    }
    function angleByKey( keyCode: Int ){
        switch( keyCode ) {
            case KeyCode.Left:
                left = true;
                right = false;
                if( up ) {
                    angle = -(3/4)*Math.PI;
                } else if( down ){
                    angle = (3/4)*Math.PI; 
                } else {
                    angle = Math.PI;
                }
            case KeyCode.Right:
                right = true;
                left = false;
                if( up ){ 
                    angle = -(1/4)*Math.PI;
                } else if( down ) {
                    angle = (1/4)*Math.PI; 
                } else {
                    angle = 0;
                }
            case KeyCode.Up:
                up = true;
                down = false;
                if( left ) {
                    angle = -(3/4)*Math.PI;
                } else if( right ) {
                    angle = -(1/4)*Math.PI;
                } else {
                    angle = -Math.PI/2;
                }
            case KeyCode.Down:
                down = true;
                up = false;
                if( left ) {
                    angle = (3/4)*Math.PI;
                } else if( right ) {
                    angle = (1/4)*Math.PI;
                } else {
                    angle = Math.PI/2;
                }
        }
    }
    function removeKey( keyCode: Int ){
        /*var abc = keyCode < ( 'a'.code - 1 ) && keyCode > ( 'z'.code + 1 );
        var ABC = keyCode < ( 'A'.code - 1 ) && keyCode > ( 'Z'.code + 1 );
        var number = keyCode < ( '0'.code - 1 ) && keyCode > ( '9'.code + 1 );
        var letter = abc && ABC;
        if( letter ) lettersDown = StringTools.replace( lettersDown, String.fromCharCode( keyCode ), '' );
        */
        switch( keyCode ) {
            case KeyCode.Left:
              left = false;
            case KeyCode.Right:
              right = false;
            case KeyCode.Up:
              up = false;
            case KeyCode.Down:
              down = false;
          }
        
    }
    inline
    public function stats():String {
        return if( mouseX != null ){
            'x: ' + mouseX + ', y: ' + mouseY + ', direction: ' + threePlaces( angle );
        } else {
            '';
        }
    }
    inline
    function threePlaces( val: Float ): Float {
        var v = Math.round( ( val ) * 1000 );
        return ( v == 0 )?0: v/1000;
    }
}