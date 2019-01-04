package iron.helper;
import iron.data.SceneFormat;
import iron.helper.CameraHelper;
import iron.object.Object;
import iron.data.*;
class SceneHelper {
    static function world( name: String = 'MyWorld' ){
        return {    name: name,
					type: 'object',
					data_ref: '',
					transform: null,
					children: [],
				};
    }
    public static function setup( sceneName:  String = 'MyScene'
                                , cameraName: String = 'MyCamera'
                                , cameraData: String = 'MyCameraData'
                                /*, images: Array<String>*/ ): TSceneFormat {
        var raw: TSceneFormat = { name:         sceneName
                                , camera_ref:   cameraName
                                , camera_datas: [ CameraHelper.cameraData(cameraData) ]
                                , shader_datas: []
                                , material_datas: []
                                , mesh_datas:     []
                                /*, embedded_datas: images */
                                , objects: [  cast SceneHelper.world()
                                            , cast CameraHelper.cameraObj( cameraName, cameraData, CameraHelper.transform() ) ]
                                };
        Data.cachedSceneRaws.set( raw.name, raw );
        return raw;
    }

}