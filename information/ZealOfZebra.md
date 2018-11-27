# Zeal of Zebra

Using my **Leaf** offset rotations, **folders** image/file **helper** and my port of **RectPack2D**. 

 - [ WebGL ](https://nanjizal.github.io/Xperimental/zealAtlas/bin/index.html) _mouse down and <- -> to rotate piece._
 - [ Canvas ](https://nanjizal.github.io/Zeal/deploy/index.html)

#### Zeal Development 
From the Canvas version to the WebGL, with some Texture packing and Ascii art diversions.

##### Canvas, and a tree of Leaf Entities.
I initially explored using two canvas to draw a Zeal of Zebra. Using lots of trig and pythag to calculate the offset rotation maths, it was possible to create structure that could be animated crudely with just a sine wave - with different weightings applied to each rotation joint. 
When you rotate an image the bounding box that contains it changes and the rotation is normally from the top left corner so it needs to be moved by it's changing centre rotated and moved back, now if your hanging a leg off your body image then that as a join point that also rotates with the image and it's real position relative to the corner changes.

Initially this project started with me drawing a blue stripped Zebra in Flash, which I cut it up and exported as png images. 

To render I found it ideal to draw each png rotated on a reused canvas and then copied to the main canvas, because child limbs were recursively drawn I could reuse the first canvas reducing the need for creation of canvas to only the main one and a vertial one. Quite a bit of maths was needed since when rotating the image dimensions, offset pivot virtual child nested structure gets complex. I also calculated and drew the pivot points and changing bounding boxes in a debug mode.

The concept was that every limb was a **Leaf** or branch which could have children, so kind of a Entity Tree or Virtual display list structure.  To build you would add **Leaf** drawing you would only call draw on the top leaf and it would draw it's children and they thier grandchildren. 

<img width="300" alt="zeal canvas" src="https://user-images.githubusercontent.com/20134338/49017821-b2583300-f181-11e8-8e91-8a79fb2ffa59.png">

##### WebGL is slower!
More recently I tried reusing the code but changing to render in WebGL using Kha, I first tried rendering each png with two graphics4 UV texture triangles using some matrix transformations for render and the previous maths for calculating pivots only. Since WebGL does not have canvas I used Trilateral my triangle drawing engine to create debug rounded rectangles around the shapes, because I can, but results were not great performance wise.

<img width="300" alt="zealKha" src="https://user-images.githubusercontent.com/20134338/49017990-13800680-f182-11e8-9a5a-c6617bb37960.png">

Performance was terrible, swapping images ( flush ) was very heavy and also the repeated changing between the gradient/color and image shaders was bad.  The issues was that each Leaf.

##### hxRectPack2D port to the rescue
So I ported RectPack2D a **c** and **js** library used for efficient rectangle packing.

<img width="300" alt="hxrectpack2d" src="https://user-images.githubusercontent.com/20134338/47865415-0cb8da80-ddf4-11e8-9eb1-2593002da4f7.png">

Great works with Rectangles but rotated Images, bit of Matrix maths and head scratching, even went over board in Kha with adding the file names as a layover useful in debug.

<img width="300" alt="rectpack2x2" src="https://user-images.githubusercontent.com/20134338/49018134-85585000-f182-11e8-8b6c-abfdb42a582f.png">

##### Texture Packing JSON parser needed

Then I needed to implement a JSON format for Using the Atlas, Texture Packer seemed fairly standard.

<img width="300" alt="texturepackerformat" src="https://user-images.githubusercontent.com/20134338/49018351-1a5b4900-f183-11e8-9c0a-5dfeed8e34ff.png">

For switching between versions I ended up building simple generic array of option/combo box solution, so I could check stuff on screen. This can be easily used on any project.

<img width="300" alt="rectpack2doptions" src="https://user-images.githubusercontent.com/20134338/49019230-5db6b700-f185-11e8-92ca-839c6019fff6.png">

##### Neko Terminal Atlas generation
Using **hxPixels** friends library developed to help with our joint hxDeadalus port, **folder** file/image loading helper.
 
Now the next task was to save the Atlas to a **png**, although Kha compiles to c++ that is quite slow for debug, and the Krom ( webgl browser ) target uses totally different api, pluse I really felt this could be a terminal app. So I rebuild the code using Neko for terminal. Needed to draw without a context I used my friends hxPixels to help with pixel abstraction. Created a mini project 'folder' to help with all aspects of 'sys' file browsing and image files. By handling file loading and folder reading in standalone helper project it kept all the internal code better structured. 'folder' was roughly developed from an old 'finda' project but with all graphics removed. 'folder' provided saving with 'format' library to png or bmp. HxPixels was great but it still required some manipulation for othogonal rotation.

<img width="300" alt="zebraParts" src="https://user-images.githubusercontent.com/20134338/49020394-3dd4c280-f188-11e8-8d3a-1ebf251b46bb.png">

##### Ansi and Ascii/hxPixels art diversions 

Debugging via trace was a bit tricky with no graphics to see what was happening with pixels.  Mad thought...it would be interesting to actually see what I was drawing within console! I knew this was kind of possible using Ansi.  Ansi can draw characters to teriminal but only in a few colors, after a look on google I found some information on character sets that provide different brightness levels often used in ascii art so I setup to allow switching between sets. Then I would need to convert the pixels to grey but I knew that just an average would not account for differences in brightness between Red, Blue and Green so I found a true greyscale convertion equation.  Then rather naughtly added some faux color approximation, just fiddling with applying color weightings to the characters. Often it would over run the minimal screen dimensions of terminal so initially I copped images, later I added scaling.  To render correctly you need to skip vertical rows to look correct. Results were fun, scaling to fit and not crash was fiddly but was very exciting it's now in it's own project here is one of the results.

<img width="200" alt="jlmansismall2" src="https://user-images.githubusercontent.com/20134338/49019946-14676700-f187-11e8-9080-a183483d2570.png">

##### Texture Packing format ugly, reflection and secondary typedef format.

Anyway getting back to the Zebras I had an Atlas, but the texture packer JSON was fiddly because the file assumes nodes to be named after images so not generically.  Unparsing the format required reflection of the frames, then I re packed in a sensible typed typedef structure that could be generically traversed, and then drawing to screen.

Had to totally rebulid my render approach to work with subscaled images and take all the drawing code outside of the original canvas algorithm nodel recursive Leaf render structure, I started to get some good results eg: 3000 zebras! Well kind of some crazy amounts of zebras did crash the browser, but with them all animating it was pretty cool.  Getting a feeling for when it was struggling was tricky so had to build a fps counter, Kha does not have one, and some mouse and keyboard stuff to help with testing. The fps implementation is not perfect but it's something I can reuse.

<img width="300" alt="zeal3000" src="https://user-images.githubusercontent.com/20134338/49016476-1e389c80-f17e-11e8-97b4-ffb280bdccfd.png">

##### Creating a JSON format for offset rotations.

Was really excited but the code was too convoluted to easily use for say a Tigers or Giraffe. So need to abstract the hard coded offset rotation and position data for each "Leaf" by inventing a Json structure that for the moment manually populate.

So to build the Zebras into a Zebra Leaf tree, I now have to merge the two JSON files data to provide the information required to access parts of the sprite sheet and to achieve a render.  Drawing was decoupled so that each 'leaf' was drawn in isolation from an array rather than via it's recursive tree this gave a lot more control over the render and shader use. For the many Zebra's different positions were pre randomly generated along with scales and simple z depth emulation. Positioning via matrix from the calculated offsets allowed easy adjustment of scale and it was possible to randomly flip the zebra and get them running at different speeds in different directions on x-plane.  Now only 100 Zebras in a Zeal, I lost some speed along the way but gained a lot of flexibility for real case use, I could probably build a Zoo.

<img width="300" alt="zealrendering" src="https://user-images.githubusercontent.com/20134338/49021570-ceac9d80-f18a-11e8-9cb7-defa7615b3a9.png">

###### Future

The tools in Zeal need to be improved to allow the placement JSON to be created by dragging around limbs and rotation cross hairs, the project may extend. But as dev tools it's kind of acceptable and the step to making it into an application others use for animating is much bigger, but who knows...
