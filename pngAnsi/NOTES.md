## Setup

1) Install haxe and set haxelib library path.

2) clone repo

3) To run you need to install libraries
haxelib git libraryName gitRepo
requires

format from hxFoundation
ansi from smilyOrg
folders on my github.

4) Make sure the libraries are setup right either create haxelib.json or just make sure that library code is directly in the folder and not src folder.

5) haxe compile.hxml

## Experimental options.

1) You can add your own png, gif or bmp just change the fileName in main ( line 16 ), jpg is not supported.

2) color equations can be adjusted to get different feel ( line 44-46 ).

3) grey scale equation line 42, adjusts based on relative brightness of colors.

4) scale can be adjusted ( line 17 ), hopefully it should protect you from drawing outside of area or using the buffer up.

5) Only tested on mac ( and may have modified standard char width of my terminal ) you may need to change line 32 & 33 if your terminal / cmd has different character settings, currently set to width = 100, height = 80.

6) You can swap the character brightness set used on line 20 from CharSimple to CharComplex.

7) Some terminals support more colors but the named colors are common standard.

8) Can adjust the brightness scale on line 29 at moment it's set to length of character set, it would probably be unwise to make it greate than the character set, no protection currently.
