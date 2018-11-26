# Xperimental

Nanjizal has grown. Lot of the projects are graphical and experimental testing and abusing some boundaries of technologies, but there is no central point to collate some of the more interesting aspects or to store smaller tests, so I will collate them here for now.

## Animation

### Zeal of Zebra
Using my **Leaf** offset rotations, **folders** image/file **helper** and my port of **RectPack2D**. 

#### Main Demos

 - [WebGL] https://nanjizal.github.io/Xperimental/zealAtlas/bin/index.html
 - [Canvas] https://nanjizal.github.io/Zeal/deploy/index.html

#### Zeal Development 
From the Canvas version to the WebGL, with some Texture packing and Ascii art diversions.

##### Canvas
I initially explored using two canvas to draw a Zeal of Zebra. Using lots of trig and pythag to calculate the offset rotation maths, it was possible to create structure that could be animated crudely with just a sine wave - with different weightings applied to each rotation joint. 
I drew a Zebra in Flash, cut it up and then exported as png images. With canvas each png is drawn rotated on a reused canvas to and then copied to the main canvas. Quite a bit of maths was needed since when rotating the image dimensions, offset pivot virtual child nested structure gets complex.

<img width="300" alt="zeal canvas" src="https://user-images.githubusercontent.com/20134338/49017821-b2583300-f181-11e8-8e91-8a79fb2ffa59.png">

##### WebGL is slower!
More recently I tried reusing the code but changing to render in WebGL using Kha, I first tried rendering each png with two graphics4 UV texture triangles using some matrix transformations for render and the previous maths for calculating pivots etc. Since WebGL does not have canvas I used Trilateral my triangle drawing engine to create debug rounded rectangles around the shapes.

<img width="300" alt="zealKha" src="https://user-images.githubusercontent.com/20134338/49017990-13800680-f182-11e8-9a5a-c6617bb37960.png">

But performance was terrible, swapping images ( flush ) was very heavy and also the change between the gradient/color and image shaders. 

##### hxRectPack2D port to the rescue
So I ported RectPack2D a **c** and **js** library used for efficient rectangle packing.

<img width="300" alt="hxrectpack2d" src="https://user-images.githubusercontent.com/20134338/47865415-0cb8da80-ddf4-11e8-9eb1-2593002da4f7.png">

Got that working visually.

<img width="300" alt="rectpack2x2" src="https://user-images.githubusercontent.com/20134338/49018134-85585000-f182-11e8-8b6c-abfdb42a582f.png">

##### Texture Packing JSON parser needed

Then I needed to implement a JSON format for Using the Atlas, Texture Packer seemed fairly standard.

<img width="300" alt="texturepackerformat" src="https://user-images.githubusercontent.com/20134338/49018351-1a5b4900-f183-11e8-9c0a-5dfeed8e34ff.png">

For switching between versions I ended up building simple generic array of option/combo box solution, so I could check stuff on screen.

<img width="300" alt="rectpack2doptions" src="https://user-images.githubusercontent.com/20134338/49019230-5db6b700-f185-11e8-92ca-839c6019fff6.png">

##### Neko Terminal Atlas generation
Using **hxPixels** friends library developed to help with our join hxDeadalus, **folder** file/image loading helper.
 
Now the next task was to save the Atlas to a **png**, although Kha compiles to c++ that is quite slow for debug, and the Krom ( webgl browser ) target uses totally different api and I felt really this could be a terminal app. So I rebuild the code using Neko for terminal. Needed to draw without a context I used my friends hxPixels to help with pixel abstraction. Created a mini project 'folder' to help with all aspects of 'sys' file browsing image files and saving with format to png or bmp abstracting that out of the project to something more generically useful. HxPixels was great but it still required some manipulation for othogonal rotation.

<img width="300" alt="zebraParts" src="https://user-images.githubusercontent.com/20134338/49020394-3dd4c280-f188-11e8-8d3a-1ebf251b46bb.png">

##### Ansi and Ascii/hxPixels art diversions 

Debugging via trace was a bit tricky, and I thought it might be interesting to actually see what I was drawing without opening the file by using Ansi.  Ansi can draw characters to teriminal but only in a few colors, after a look on google I found some information on character sets that provide different brightness levels often used in ascii art, and a true greyscale convertion equation.  Then added some faux color approximation. Results were fun, scaling to fit and not crash was fiddly but was very exciting it's now in it's own project here is one of the results.

<img width="200" alt="jlmansismall2" src="https://user-images.githubusercontent.com/20134338/49019946-14676700-f187-11e8-9080-a183483d2570.png">

##### Texture Packing format ugly, reflection and secondary typedef format.

Anyway getting back to the Zebras I had an Atlas, but the texture packer JSON was fiddly because I had to use strings to create the file since the format assumes nodes to be named after images so not generically.  Unparsing the format required reflection prior to then re packaging in a sensible typed typedef structure and then drawing to screen.

Had to totally rebulid my render approach to work with subscaled images and take all the drawing code outside of the original canvas algorithm nodel recursive render structure, I started to get some good results eg: 3000 zebras kind of all animating but getting feeling for speed was trick so had to build a fps counter and some mouse and keyboard stuff to help with testing.

<img width="300" alt="zeal3000" src="https://user-images.githubusercontent.com/20134338/49016476-1e389c80-f17e-11e8-97b4-ffb280bdccfd.png">

##### Creating a JSON format for offset rotations.

Was really excited but the code was too convoluted to easily use for say a Tigers or Giraffe. So need to abstract the hard coded offset rotation and position data by inventing a Json structure that for the moment manually populate.  So to build the Zebras I now have to merge the two JSON files to provide the information required to access parts of the sprite sheet and render.  Drawing was decoupled so that each 'leaf' was drawn in isolation. For the many Zebra's different positions were pre randomly generated along with scales and simple z depth emulation. Positioning via matrix from the calculated offsets allowed easy adjustment of scale and it was possible to randomly flip the zebra and get them running at different speeds in different directions on x-plane.  Now only 100 I lost some speed along the way.

<img width="300" alt="zealrendering" src="https://user-images.githubusercontent.com/20134338/49021570-ceac9d80-f18a-11e8-9cb7-defa7615b3a9.png">

###### Future

The tools in Zeal need to be improved to allow the placement JSON to be created by dragging around limbs and rotation cross hairs, the project may extend.

Next I am looking at recreating some IK and a tool to build the offset rotation JSON.
Multiple Arc Tan with rotation limits might be enough perhaps with some tween softening. Recreating an arm... the hassle of getting vector art out of flash perhaps I can parse the illustrator export.. that's the beauty of Opensource you can explore some tangents they normally turn out useful later.

## JigsawX
### demos
- ( WebGL )      https://nanjizal.github.io/TrilateralBazaar/jigsawX/bin/index.html
- ( Canvas/Dom ) https://nanjizal.github.io/JigsawX/bin/JigsawDivtastic.htm

## Trilateral drawing contours with WebGL ( GL ).



## Spiro








