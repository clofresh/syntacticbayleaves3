export BLOG_ID=00000008
export BLOG_TITLE="Making animated gifs from command line"
export BLOG_BODY=$(cat <<TEXT
<p><img src="http://media.tumblr.com/e25cefe03c15ac186ef40869cb5f2ade/tumblr_inline_mipkz3mxjb1qz4rgp.gif"/></p>

<p>Sometimes when you're watching your favorite show, a perfect moment comes along that you just gotta capture and share with everyone. That's where the animated gif comes in. Though they're really popular with the kids these days, they're surprisingly hard to make. Luckily there's some powerful open source command line tools that can help you: <a href="http://www.ffmpeg.org/">ffmpeg</a>, <a href="http://www.imagemagick.org/">ImageMagick</a> and <a href="http://www.lcdf.org/gifsicle/">gifsicle</a>. If you're on OS X and have <a href="http://mxcl.github.com/homebrew/">Homebrew</a> set up, all you have to do is run:</p>

<blockquote>
brew install ffmpeg imagemagick gifsicle
</blockquote>

<p>Boom. So the first thing you'll need is a video file. They're getting quite rare these days since everything's streaming now, but assuming you've got one, you'll wanna find the start time of the moment you wanna capture, and how long the moment is.</p>

<p>Once you've know those two things, you'll wanna fire up <code>ffmpeg</code> to extract the moment from the video into a series of gif images. For example, if I wanted 5 seconds from <code>myvideo.avi</code>, starting at 9 minutes and 52 seconds in, I'd run:</p>

<blockquote>
ffmpeg -ss 00:09:52 -t 5 -i /path/to/myvideo.avi myanim-%3d.gif
</blockquote>

<p>This will output a series of <code>myanim-001.gif, myanim-002.gif</code>, etc images to the current directory, with one image per frame in the video.</p>

<p>From here, you could just compile these images into an animated gif with <code>gifsicle</code>:</p>

<blockquote>
gifsicle --delay=4 --loop myanim-*.gif > myanim.gif
</blockquote>

<p>That will create an animated gif <code>myanim.gif</code> from all of the frames that ffmpeg extract with a delay of 4 hundreths of a second between each frame, looped forever. You can view it in a browser like Chrome this:</p>

<blockquote>
open -a /Applications/Google\ Chrome.app myanim.gif
</blockquote>

<p>Most of the time though, this will generate an image file that's way to large for you to post or others to view in a timely manner, so you'll wanna crop and scale down the image using ImageMagick, specifically ImageMagick's <code>mogrify</code> tool.</p>

<blockquote>
  mogrify -crop 1024x1024+200+0 +repage -resize 480 myanim-*.gif
</blockquote>

<p>This will crop the images to 1024 by 1024 with a horizontal offset of 200 pixels, remove the cropped portion from the image, then resize it proportionally to 480 by 480. Now you can rerun the <code>gifsicle</code> command and you'll have a nice and svelte animated gif file on your hands!</p>

<p>Note that <code>gifsicle</code> has some options to crop and scale the animation, but I found that it doesn't preserve the quality of the images as well as <code>mogrify</code> does. Also be careful with <code>mogrify</code> because it modifies the image files you point it at, so you may want to make a copy of the first frame and test your mogrify command on it before applying the command to all the frames. Though if you mess up, you can always run <code>ffmpeg</code> again.</p>

<p>Enjoy!</p>

<p><img src="http://media.tumblr.com/4962cbe71edd812d8df1093672870888/tumblr_inline_miqgu6Dwiw1qz4rgp.gif" /></p>
TEXT
)
export BLOG_DATE="2013-02-27T00:00 EST"
