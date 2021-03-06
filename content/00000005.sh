export BLOG_ID=00000005
export BLOG_TITLE="Adventure game prototype 1 - new art, better editor integration"
export BLOG_BODY=$(cat <<TEXT
<p>I updated the art I was using with free-er as in speech art from the <a href="http://lpc.opengameart.org/">Liberated Pixel Cup</a>. The grass, trees and bee are all from the very excellent <a href="http://lpc.opengameart.org/static/lpc-style-guide/assets.html">base assests</a> they provide, and the player sprite is from <a href="http://opengameart.org/content/steampun-a-fy-with-concept-art">Emilio J. Sanchez-Sierra's entry</a>. Here's what it looks like now:</p>

<iframe width="640" height="480" src="https://www.youtube.com/embed/D9DcTqnf8wg?rel=0" frameborder="0" allowfullscreen></iframe>

<p>A lot of the LPC assests are in .xcf, so I had to install <a href="http://www.gimp.org/">GIMP</a> to work with them. Luckily, the OS X version can run mostly natively and doesn't need X11 anymore (though it still uses GTK-style dialogues! &lt;/nitpick&gt;). The LPC assets let you mix and match hair, facial features and clothing by just switching up the layers, which is pretty freakin awesome, though I'm having a little trouble with basic operations with GIMP, arg.</p>

<p>I also updated the code to pull more data about the dynamic sprites from the .tmx map file in addition to the background tiles. Since the <a href="http://www.mapeditor.org/">Tiled</a> is such a great free standards-based .tmx map editor, having my game engine read object data from .tmx files will let me focus on map design instead of technical details. It would also let me collaborate on maps with people who may not know how to code, which is helpful.</p>

<p>There's still some work to be done to fix my collision handling code, it makes my character warp around when colliding with a tree. I also need to get the melee attacks going, probably going to have placeholder animations for individual attacks since the sprites aren't meant for fighting games. I'd also like to have a scriptable camera so that I can do interesting things with it, like panning and zooming across the scenery instead of always focusing on the player.</p>
TEXT
)
export BLOG_DATE="2012-09-29T00:00 EST"
