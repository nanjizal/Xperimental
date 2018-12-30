package iron.helper;
import iron.data.SceneFormat;
import kha.math.FastMatrix4;
import iron.helper.DataHelper;
class CameraHelper{
    public static var camera_object = 'camera_object';
    public static function cameraData( dataName: String = 'MyCameraData' ): TCameraData {
        return {  name:       dataName
                , near_plane: 0.1
                , aspect:     kha.System.windowWidth() / kha.System.windowHeight()
                , far_plane:  1000.0
                , fov:        Math.PI / 4 }
    }
    public static function cameraObj( name:      String = 'MyCamera'
                                    , dataName:  String = 'MyCameraData'
                                    , transform: kha.arrays.Float32Array ) /*: CameraObject  */ {
		return { name:      name
               , type:      camera_object
               , data_ref:  dataName
               , transform: { values: transform }  };
    }
    public static function transformIdent(){
        return DataHelper.m4to32Arr( FastMatrix4.identity() );
    }
    public static function transform(){
        return DataHelper.m4to32Arr( new FastMatrix4(  4/2,  0.,           0,  0.25/2
                                                    ,   0.,  3/2, -Math.PI/2, -1
                                                    ,   0.,   0.,          1,  2
                                                    ,   0.,   0.,          0., 1 ) ); 
    }
}