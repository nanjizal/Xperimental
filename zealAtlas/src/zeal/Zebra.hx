package zeal;
import leaf.Leaf;
typedef ZebraAttributes = {
    x: Int, y: Int, scale: Float, speed: Float, direction: Bool
}
class Zebra {
    var angle:           Float = 0.0;
    public var body:     Leaf;
    var frontLegTop2:    Leaf;
    var frontLegBottom2: Leaf;
    var frontLegTop:     Leaf;
    var frontLegBottom:  Leaf;
    var frontHoff:       Leaf;
    var frontHoff2:      Leaf;
    var backLegTop2:     Leaf;
    var backLegBottom2:  Leaf;
    var backLegTop:      Leaf;
    var backLegBottom:   Leaf;
    var backHoff:        Leaf;
    var backHoff2:       Leaf;
    var tail:            Leaf;
    var neck:            Leaf;
    var chin:            Leaf;
    public var leaves:   Array<Leaf>;
    public var attributes: ZebraAttributes;
    public function new( leaves_: Array<Leaf> ){
        leaves = leaves_; 
        for( leaf in leaves ){
           switch( leaf.name ){
                case 'body':
                    body = leaf;
                case 'frontLegTop2':
                    frontLegTop2 = leaf;
                case 'frontLegBottom2':
                    frontLegBottom2 = leaf;
                case 'frontLegTop':
                    frontLegTop = leaf;
                case 'frontLegBottom':
                    frontLegBottom = leaf;
                case 'frontHoff':
                    frontHoff = leaf;
                case 'frontHoff2':
                    frontHoff2 = leaf;
                case 'backLegTop2':
                    backLegTop2 = leaf;
                case 'backLegBottom2':
                    backLegBottom2 = leaf;
                case 'backLegTop':
                    backLegTop = leaf;
                case 'backLegBottom':
                    backLegBottom = leaf;
                case 'backHoff':
                    backHoff = leaf;
                case 'backHoff2':
                    backHoff2 = leaf;
                case 'tail':
                    tail = leaf;
                case 'neck':
                    neck = leaf;
                case 'chin':
                    chin = leaf;
                case _:
                    //
                }
        }
    }
    public function rotation( speed: Float = 0.3 ){
        angle += speed;
        // adjust angle of limbs, if not adjusted they assume to be just down
        // thier default rotation is not effected by their parent, only the position.
        var sin                 = Math.sin( angle );            
        var cos                 = Math.cos( angle );
        var cos2                = Math.cos( -angle );
        var pi                  = Math.PI;
        var spi                 = sin*pi;
        var cpi                 = cos*pi;
        //body.updatePosition(); // use if not setting body rotation to make sure updates.
        body.theta              = -pi/50*sin;
        frontLegTop2.theta      = cpi/7 + pi/14;
        frontLegBottom2.theta   = -pi/10 - cpi/20 ;
        frontLegTop.theta       = pi/7*sin + pi/14;
        frontLegBottom.theta    = -pi/10 - pi/10*sin/2;
        frontHoff.theta         = ( cpi - spi )/10 - pi/10;
        frontHoff2.theta        = spi/10 -pi/10;
        backLegTop2.theta       = pi/10*cos2;
        backLegBottom2.theta    = pi/10 - pi/10*cos2/2 ;
        backLegTop.theta        = spi/10;
        backLegBottom.theta     = pi/10 - pi/10*sin/2 ;
        backHoff.theta          = ( spi + cpi )/15;
        backHoff2.theta         = -( spi + cpi )/15;
        tail.theta              = spi/30;
        neck.theta              = -spi/25;
        chin.theta              = spi/20 - pi/10;
        body.calculate();
    }
}