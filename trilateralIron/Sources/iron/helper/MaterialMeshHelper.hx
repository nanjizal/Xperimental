package iron.helper;
import iron.data.*;
import kha.Color;
import iron.data.SceneFormat;
import iron.object.Object;
import trilateral.tri.Triangle;
import trilateral.tri.TriangleArray;
import trilateral.parsing.FillDraw;
typedef TMaterialMesh = {
    function draw( triangle: TriangleArray, color: Array<Int> ): Void;
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
    var triangles:   TriangleArray;
    var objName:     String;
    /* var parent:      Object; */
    public function new( raw_: TSceneFormat
                       , meshWrapper_: TMaterialMesh
                       , triangles_:   TriangleArray
                       , colors_:      Array<Color>
                       , objName_:     String
                       /* , parent_:      Object */ ){
        raw         = raw_;
        meshWrapper = meshWrapper_;
        objName     = objName_;
        triangles   = triangles_;
        colors      = colors_;
        /* parent      = parent_; */
    }
    public function create(){
        if( ready == null ) return;
        meshBuild();
    }
    function meshBuild(){
        meshWrapper.draw( triangles, colors );
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