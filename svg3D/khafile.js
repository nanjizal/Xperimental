let project = new Project('Empty');

project.addSources('Sources');
project.addShaders('Shaders');
project.addLibrary('iron');
project.addLibrary('trilateral');
project.addLibrary('trilateralXtra');
project.addLibrary('hxPolyK');
//project.addLibrary('poly2trihx');
project.addLibrary('hxGeomAlgo');
project.addAssets('Assets/**');

resolve(project);
