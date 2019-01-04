package iron.helper;
import iron.data.*;
import kha.Color;
import iron.data.SceneFormat;
import iron.object.Object;
import trilateral.tri.Triangle;
import trilateral.tri.TriangleArray;
import trilateral.parsing.FillDraw;
typedef TMaterialMesh = {
    function draw( triangle: TriangleArray
                 , contour: Array<Array<Float>>
                 , color: Array<Color>
                 , contourColors: Array<Int> ): Void;
    function triangleMeshCreate():  TMeshData;
    function materialDataCreate():  TMaterialData;
    function meshObjectCreate( name: String ): TObj; 
    function shaderDataCreate():    TShaderData;
}
class MaterialMeshHelper {
    public var ready: Object -> Void;
    var raw:         TSceneFormat;
    var meshWrapper: TMaterialMesh;
    var colors:      Array<Color>;
    var contours:    Array<Array<Float>>;
    var contourColors: Array<Int>;
    var triangles:   TriangleArray;
    var objName:     String;
    public function new( raw_: TSceneFormat
                       , meshWrapper_: TMaterialMesh
                       , triangles_:   TriangleArray
                       , contours_:    Array<Array<Float>>
                       , colors_:      Array<Color>
                       , contourColors_:Array<Int>
                       , objName_:     String ){
        raw         = raw_;
        meshWrapper = meshWrapper_;
        objName     = objName_;
        triangles   = triangles_;
        contours    = contours_;
        colors      = colors_;
        contourColors = contourColors_;
    }
    public function create(){
        if( ready == null ) return;
        meshBuild();
    }
    function meshBuild(){
        meshWrapper.draw( triangles, contours, colors, contourColors );
        var mesh            = meshWrapper.triangleMeshCreate();
        raw.mesh_datas.push( mesh );
        MeshData.parse( raw.name, mesh.name, materialSetup );
    }
    function materialSetup( res: MeshData ){
        raw.shader_datas.push( meshWrapper.shaderDataCreate() );
        var md = meshWrapper.materialDataCreate();
        raw.material_datas.push( md );
        MaterialData.parse( raw.name, md.name, meshAdd );
    }
    function meshAdd( res: MaterialData ) {
        var tri = meshWrapper.meshObjectCreate( objName );
        // TODO: use parent instead
        raw.objects[ 0 ].children.push( tri );
        Scene.active.parseObject( raw.name, tri.name, null, ready ); 
    }
}