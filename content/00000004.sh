export BLOG_ID=00000004
export BLOG_TITLE="Adventure game prototype"
export BLOG_BODY=$(cat <<TEXT
<p>Somewhere along the way, I came up with a desire to do a 2D adventure game. I wanted it to be a top down game similar to the SNES Legend of Zelda, but with a Tekken-style combat system. I wrote up a a bunch of backstory and the initial quests which I'll share later, but I needed to verify that mashing Zelda with Tekken would make for a fun game, or if it were even possible.</p>

<p>So I whipped up a prototype using the <a href="https://love2d.org">Lua Löve</a> framework, tiles from Mozilla's HTML5 tech demo/lovefest, <a href="http://browserquest.mozilla.org/">BrowserQuest</a> that I found on <a href="http://opengameart.org/content/browserquest-sprites-and-tiles">Open Game Art</a>, and some <a href="https://www.youtube.com/watch?v=gwU_NupaT-s&amp;feature=related">River City Ransom</a> sprites that I had lying around. Check it out:</p>

<iframe width="640" height="480" src="https://www.youtube.com/embed/YE89_vCIkKg?rel=0" frameborder="0" allowfullscreen></iframe>

<p>I took Tekken's rock-scissor-paper style attacking/blocking/dodging scheme where high attacks were blockable blocking high and dodgable crouching low, mid attacks were blockable blocking high, but hit when blocking low, and low attacks were blockable blocking low but hit when blocking high. This leads to interesting guessing games where two attacks might have similar starting animations but one hits mid and the other hits low. I wanted combat in my game to be challenging, even against non-boss enemies, so you felt accomplished when you beat them.</p>

<p>I'll need to figure out what actual attacks will be available for the player and for the first few enemies and do my own art for it instead of ripping River City Ransom. Also gotta implement mundane things like getting obstructed by objects in the background, losing health and dying, tracking and improving player stats, etc.</p>

<p>I'll keep you posted.</p>
TEXT
)
export BLOG_DATE="2012-09-22T00:00 EST"
