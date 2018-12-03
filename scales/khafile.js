let project = new Project('Sound Test');
project.addAssets('assets/**');
project.addShaders('Shaders/**');
project.addSources('src');
project.addParameter('-main MainApp');
//project.addParameter('-dce no');
project.windowOptions.width = 1024;
project.windowOptions.height = 768;
resolve( project );