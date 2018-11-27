# Xperimental

**Nanjizal** has grown. Here I collate smaller projects and provide an overview narative on the development of concepts through experiments and libraries within Nanjizal ( and hxDaeadlus ). 

<sup>Currently only Haxe code, as OOP language with functional typing, designed to cross compile to many languages.  Haxe targets including **c++** and **js** ideal for - mobile, web, desktop and console. Haxe **js** is often faster than handwritten javascript.<sup>

###### Click on the table image to go to the project section

| Projects |  |  |  |
| :-----------: | :-----------: | :-----------: | :-----------: |
| Zeal of Zebra | L-Systems     | Ascii terminal  | JigsawX  |
| [<img width="150" alt="zeal canvas" src="https://user-images.githubusercontent.com/20134338/49017821-b2583300-f181-11e8-8e91-8a79fb2ffa59.png">](/README.md#zeal-of-zebra) | [<img width="150" alt="lsystem2" src="https://user-images.githubusercontent.com/20134338/49053899-04cd3a00-f1ea-11e8-98dd-b5b016090081.png">](/README.md#l-systems) | [<img width="100" alt="haxeansi3" src="https://user-images.githubusercontent.com/20134338/49052755-18c26d00-f1e5-11e8-845a-9b4e29f4c114.png">](/README.md#ascii-art-hxpixel-and-ansi)|[<img width="150" align="left" alt="jigsawximage" src="https://user-images.githubusercontent.com/20134338/49057707-a65b8800-f1f8-11e8-93af-f4f92a86ecbc.png">](/README.md#jigsawx)|
| Letters | LED display | Ellipse SVG parsing | FXG Parrot |
| [<img width="150" alt="lettersgrab" src="https://user-images.githubusercontent.com/20134338/49061470-b9765400-f208-11e8-800f-776aab0cc710.jpg">](/README.md#letters)| [<img width="150" alt="backtothefuture" src="https://user-images.githubusercontent.com/20134338/49062686-e7f62e00-f20c-11e8-9eb3-185faab51182.jpg">](/README.md#LED) | [<img width="150" alt="elipse" src="https://user-images.githubusercontent.com/20134338/49062944-af0a8900-f20d-11e8-9e1e-031eec3164d2.jpg">](README.md#ellipse-svg-parsing) | [<img width="150" alt="parrot" src="https://user-images.githubusercontent.com/20134338/49063282-c26a2400-f20e-11e8-897e-9980f11712c9.jpg">](/README.md#parrot-fxg-with-trilateral)|
| Dot matrix | Trilateral ( Vectors for GPU ) | PolyminoTriangles ( tetris ) | |
| [<img width="150" alt="dotmatrix" src="https://user-images.githubusercontent.com/20134338/49063654-ec701600-f20f-11e8-8b35-6cc60027bedd.jpg">](/README.md#dot-matrix-with-trilateral)| [<img height="150" alt="trilateralkiwi" src="https://user-images.githubusercontent.com/20134338/49064013-4fae7800-f211-11e8-8308-0a9bc75c871c.jpg">](/README.md#trilateral) | [<img width="150" alt="polyminokha" src ="https://user-images.githubusercontent.com/20134338/49080453-987b2680-f23b-11e8-8666-3df3bd9bf7fd.jpg">](/README.md#tetris-triangle-crazy) | |

*****

| Ports |  |  |  |
| :-----------: | :-----------: | :-----------: | :-----------: |
| jsgl | hxSpiro     | hxDaedalus  | hxRectPack2D  |
| [<img width="150" alt="jsgl" src="https://user-images.githubusercontent.com/20134338/49060532-d5c4c180-f205-11e8-8fec-d0e28266ffd1.jpg">]()| [<img width="150" alt="spiro" src="https://user-images.githubusercontent.com/20134338/49060726-a9f60b80-f206-11e8-8eb6-68bca429720e.png">](/README.md#spiro) |[<img width="150" alt="hxdaedalusimg" src="https://user-images.githubusercontent.com/20134338/49061204-09085000-f208-11e8-9672-8dea3cd4303e.png">](/README.md#hxDaedalus) | [<img width="150" alt="rectpack2d" src="https://user-images.githubusercontent.com/20134338/49061637-2a1d7080-f209-11e8-832c-6870dade4c1c.jpg">](/README.md#hxRectPack2D)|
| triangulations | hxPolyK | | |
| [<img width="150" alt="ruppert" src="https://user-images.githubusercontent.com/20134338/49060882-356f9c80-f207-11e8-98d4-66c23021acb9.png">](#/README.md#triangulations)|[<img width="150" alt="polykdivtastic" src="https://user-images.githubusercontent.com/20134338/49060993-a1520500-f207-11e8-8e60-13e357b8b2c4.png">](/README.md#hxpolyk) | |

## Zeal of Zebra
Using my **Leaf** offset rotations, **folders** image/file **helper** and my port of **RectPack2D**.

<img width="300" align="left" alt="zeal canvas" src="https://user-images.githubusercontent.com/20134338/49017821-b2583300-f181-11e8-8e91-8a79fb2ffa59.png"> 

 - [ WebGL ](https://nanjizal.github.io/Xperimental/zealAtlas/bin/index.html)
 - [ Canvas ](https://nanjizal.github.io/Zeal/deploy/index.html)

#### Zeal Development 
From the Canvas version to the WebGL, with some Texture packing and Ascii art diversions.  [read more.. > ](/information/ZealOfZebra.md)

## Ascii Art, hxPixel and Ansi

<img width="10" align="left" src="https://user-images.githubusercontent.com/20134338/49057102-1e747e80-f1f6-11e8-9040-ff3f0ddefe85.png"><img width="150" align="left" alt="haxeansi3" src="https://user-images.githubusercontent.com/20134338/49052755-18c26d00-f1e5-11e8-845a-9b4e29f4c114.png">
<img width="80" align="left" src="https://user-images.githubusercontent.com/20134338/49057102-1e747e80-f1f6-11e8-9040-ff3f0ddefe85.png">

In my exploration of Zeal, and and creating a console Neko texture packer. Was curious about a quick display of images within the terminal window - Ansi and ascii. 
[read more.. > ](https://github.com/nanjizal/Xperimental/blob/master/information/ZealOfZebra.md#ansi-and-asciihxpixels-art-diversions)

<br>
<br>
<br>
<br>

## JigsawX

Flexible jigsaw engine where you can adjust aspects of the curve generation and number of rows and columns.

<img width="280" align="left" alt="jigsawximage" src="https://user-images.githubusercontent.com/20134338/49057707-a65b8800-f1f8-11e8-93af-f4f92a86ecbc.png">

WebGL Kha uses Trilateral mapping textures to the triangulation fill generated, rotation via arrow keys when mouse down. Canvas version uses one per Div piece.

- [ WebGL ](https://nanjizal.github.io/TrilateralBazaar/jigsawX/bin/index.html) _mouse down and <- -> to rotate piece._
- [ Canvas/Dom ](https://nanjizal.github.io/JigsawX/bin/JigsawDivtastic.htm)

_Flash, Swing Java, OpenFL, NME ( + android ), Kha and Canvas versions, some with webcam or video._
<br>
<br>

## Trilateral drawing contours with WebGL ( GL ).

Trilateral converts drawing commands into contours built with triangles suitable for rendering vector graphics on the GPU.
Mostly tested with Kha's Haxe toolkit with WebGL examples. Trilateral is Haxe toolkit agnostic, but additional features are to be found both in **trilateralXtra** library and in **trilateralBazaar** the examples library.

Features:

- Different contour rendering from basic overlapping lines, basic triangle corner to complex rounded corners.
- Contour thickness control.
- Simple **moveTo**, **lineTo**, **quadTo**, **curveTo**.
- Support for basic 2 triangle shapes: **line**, **quad**, **star**.
- Support for basic multiple triangle shapes: **polygon**, **star**, **diamond**, **square**, **rounded rectangle**, **circle**, **ellipse**. 
- Integration with shape fill algorithms basic fill **hxPolyK**, **poly2trihx** and **hxGeomAlgo's Tess2**.
- **SVG** path parsing, encluding Ellipses, and support for some simple SVG images.
- **FXG**, a depreciated adobe Vector format typically used with Flash.
- Complex **linear gradient** fill of arbitary shapes.
- **Image** fill of arbitary shapes.
- **Dot matrix** 5x7 character scrolling.
- Seven Segment **LED** and 16 Segment LED.
- Triangle **HitTesting** allowing shape perfect hit testing.
- Tools for scaling, rotating and translating drawings, also useful for manipulating SVG paths.
- Indexing for easy extraction and manipulation of triangulated structures.

<img width="300" align="left" alt="twolineswithlines" src="https://user-images.githubusercontent.com/20134338/49059216-b88cf480-f1ff-11e8-9d52-a82b7c07ae20.png"><img height="225" align="left" src="https://user-images.githubusercontent.com/20134338/49059509-40273300-f201-11e8-8437-559dd4f1cd79.jpg"><img height="225" align="left" alt="trilateralkiwi" src="https://user-images.githubusercontent.com/20134338/49064013-4fae7800-f211-11e8-8308-0a9bc75c871c.jpg">

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

## Letters
<img width="300" align="left" alt="lettersgrab" src="https://user-images.githubusercontent.com/20134338/49061470-b9765400-f208-11e8-800f-776aab0cc710.jpg">
<img width="300" align="left" alt="haxeletters" src="https://user-images.githubusercontent.com/20134338/49061486-c4c97f80-f208-11e8-9ddc-919684efe8ef.jpg">

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

## Tetris, triangle crazy.
I was asked if I could make Tetris, implemented it with triangles not an MVC framework! You can define your own shapes in the code easily and it runs on all Haxe toolkits, did add SVG target but meh, also emscriptem via NME. Two versions below.
_Arrow keys to play._
- [ WebGL ](https://nanjizal.github.io/PolyominoTriangles/binHeaps/index.html)
- [ Canvas ](https://nanjizal.github.io/PolyominoTriangles/binCanvas/index.html?2)

## hxSpiro
Port of Spiro a fancy tool for making intuative curves.
- [ code pen demo ](https://codepen.io/Nanjizal/pen/qReLLR)

_TODO: upload better version to github as the code pen one move points is broken._

## L-Systems 
greatly improved this project adding cool examples, animation and implementing color and abstracting for use with both Kha and Luxe rendering or possibly other toolkits.
- [ L-System animation ](https://nanjizal.github.io/L-System/bin/web/) _wait for 2nd page spoiler alert below:_

<img width="300" alt="lsystem2" src="https://user-images.githubusercontent.com/20134338/49053899-04cd3a00-f1ea-11e8-98dd-b5b016090081.png">

## jsgl

<img width="300" alt="jsgl" align="left" src="https://user-images.githubusercontent.com/20134338/49060532-d5c4c180-f205-11e8-8fec-d0e28266ffd1.jpg">

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>


## Ellipse SVG parsing
<img width="300" align="left" alt="elipse" src="https://user-images.githubusercontent.com/20134338/49062944-af0a8900-f20d-11e8-9e1e-031eec3164d2.jpg">

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

## hxRectPack2D

<img width="300" align="left" alt="rectpack2d" src="https://user-images.githubusercontent.com/20134338/49061637-2a1d7080-f209-11e8-832c-6870dade4c1c.jpg">

<br>
<br>
<br>
<br>
<br>

## Parrot FXG with Trilateral

<img width="300" align="left" alt="parrot" src="https://user-images.githubusercontent.com/20134338/49063282-c26a2400-f20e-11e8-897e-9980f11712c9.jpg">

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

## Dot matrix with Trilateral

<img width="300" align="left" alt="dotmatrix" src="https://user-images.githubusercontent.com/20134338/49063654-ec701600-f20f-11e8-8b35-6cc60027bedd.jpg">

<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
