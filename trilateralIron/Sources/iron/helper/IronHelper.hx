package iron.helper;
import iron.App;
import iron.Scene;
import iron.RenderPath;
import iron.data.*;
import iron.data.SceneFormat;
import iron.object.Object;
import iron.object.CameraObject;
import iron.data.CameraData;
import kha.arrays.Float32Array;
import kha.arrays.Uint32Array;
import trilateral.tri.Triangle;
import trilateral.tri.TriangleArray;
import iron.math.Vec4;
import iron.math.Mat4;
import kha.math.FastMatrix4;
import kha.math.FastVector3;
import kha.Color;
import iron.helper.CameraHelper;
import iron.helper.DataHelper;
import iron.helper.SceneHelper;
import iron.helper.MultiColorMesh;
class IronHelper {
    public var raw:        TSceneFormat;
    public var sceneName:  String;
    public var ready:      Object->Void;
    var cameraName:        String;
    var cameraDataName:    String;
    var meshName:          String;
    var bgColor:           Color;
    public function new(  sceneName_:       String
                        , cameraName_:      String
                        , cameraDataName_:  String
                        , meshName_:        String
                        , bgColor_:         Color ){
        sceneName      = sceneName_;
        cameraName     = cameraName_;
        cameraDataName = cameraDataName_;
        // NOT IDEAL RETHINK!!!
        meshName       = meshName_;
        bgColor        = bgColor_;
    }
    public function create(){
        App.init( init );
    }
    function init(){
        createPath();
        raw = SceneHelper.setup( sceneName, cameraName, cameraDataName );
        Scene.create( raw, ready );
        return raw;
    }
    function createPath(){
        var path = new RenderPath();
        path.commands = function() {
            path.setTarget( "" );
            path.clearTarget( bgColor, 1.0 );
            path.drawMeshes( meshName );
        };
        RenderPath.setActive( path );
    }
}