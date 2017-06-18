export BLOG_ID=00000002
export BLOG_TITLE="Switching from OS X to Linux Mint 12"
export BLOG_BODY=$(cat <<TEXT
<div class="cover"><a href="img/00000002-desktop.png"><img src="img/00000002-desktop.png" /></a></div>

<p>I've been an OS X user since Tiger's launch in 2005. I got a G4 Powerbook as a graduation present from my parents, and I loved how coherent an operating system it was. The biggest win for me was that it was unix-y enough to be a nice programming environment (Aquaemacs ftw) while at the same time having nice apps for normal day life things like Quicksilver, iTunes, iPhoto and Adium.  I was coming from the frankenstein user experience of Windows XP + Cygwin environment, so OS X was a breathe of fresh air. I messed a bit with Gnome desktop on Fedora Core 3, but either I was still too much of a Linux n00b, or it still sucked too much to be useful (hello recompiling the kernel on video driver updates).</p>

<p>Fast forward to 2012, where my workstation is an iMac running OS X Snow Leopard, my music player of choice is Spotify, my editor is Sublime Text 2 and I spend a large portion of my time in iTerm2 in fullscreen mode with 3 or 4 terminal tabs split into 6 panes each. I refuse to upgrade to Lion because I hate the one-app-per-virtual-desktop-but-never-quite-knowing-the-order-of-the-desktops paradigm. The scrolling/scrollbars, and Mail.app are nicer, but not worth losing out on the virtual desktop issue. Also, the App Store can go to hell and die.</p>

<p>When Apple announced Mountain Lion, I could see that they were pushing for more iPadification and not much else to get excited about, so on a whim, I decided to give Linux desktop another shot. Apparently <a href="http://linuxmint.com/">Linux Mint</a> became the hot new distro in town when Ubuntu pushed out the much-maligned Unity desktop onto everyone, so I torrented the Linux Mint 12 "Lisa" iso, partitioned off a 20GB piece of my hard drive and gave it a go.</p>

<p>The install was pretty painless. It discovered the partition right away and started installing in the background while the wizard asked me the usual install questions, which I thought was a nice touch. It installed GRUB on my Windows partition, which threw me off for a bit, but nothing a little Googling couldn't unearth.</p>

<p> But yeah, everything installed fine, and after a <a href="http://community.linuxmint.com/software/view/software-center">Software Center</a> package upgrade, I was running the latest and greatest Gnome 3 desktop. The things that you normally feared would fail on Linux worked fine: sound, video, wifi, builtin volume/brightness buttons, suspend, Flash, they all worked without any intervention on my part. Had to enable two-finger scrolling in the settings pane, but that's about it. I proceeded to get the same apps that I had worked with on OS X: Chrome, <a href="http://www.spotify.com/us/blog/archives/2010/07/12/linux/">Spotify</a> (sadly, doesn't have Spotify Apps yet), Sublime Text 2 (boo, no apt repo!), Dropbox. There's no shortage of terminals on Linux but I settled with <a href="http://community.linuxmint.com/software/view/terminator">Terminator</a> for the split panes (not quite ready for <a href="http://xmonad.org/">Xmonad</a>). I couldn't find a particularly nice Twitter client, which is surprisingly coming from OS X/iOS land where there's dozens of clients that was decent. I ended up settling on <a href="http://community.linuxmint.com/software/view/gwibber">Gwibber</a>, even though it had a comically low score of -81 in Software Center.
</p>

<p>Also, can I just say, apt-get for the muthaf'ing win? Apt-get is great not just for getting all your development dependencies with zero fuss (homebrew on OS X is mostly good enough for that), but for all your system updates. Instead of getting annoying updater popups from Apple that require a system reboot, or every single app trying to do their own updates when opening the app, or the App Store where you need to explicitly go out of your way to discover if there are new updates and install them yourself. That is one paradigm that Apple definitely should not have copied from iOS. Nope, apt-get just goes and does its thing. You might get a notification from Software Center to run your updates, which is just a wrapper around apt-get, but for the most part you could probably just cron an <code>apt-get upgrade &amp;&amp; apt-get update</code> every week and you'll be fine.</p>

<p>Gnome Shell is a pretty nice desktop environment. I like that they've created a (Mission Control + Quicksilver)-like view when you press the super key. They've managed to show all your open windows on the current workspace, plus a high level preview of all your workspaces, plus a search-as-you-type app search without it being a visual overload. I like it much more than OS X's Mission Control, though I do miss being able to search for songs from Quicksilver. I'm sure there's a shell extension that can do that, just haven't found it.</p>

<p>Speaking of shell extensions, I love that I can install or disable extensions right from the <a href="https://extensions.gnome.org/">extensions website</a>. My favorite extension so far is <a href="https://extensions.gnome.org/extension/28/gtile/">gTile</a>, a nice way to resize your windows into fixed grid sizes (again, not ready for Xmonad). Apparently shell extensions are still bleeding edge, as there aren't great documentation on them. There's <a href="http://live.gnome.org/GnomeShell/Extensions">a brief intro</a> on the Gnome wiki, but it doesn't try to help you with the GUI API, just on setup. It's nice that the extensions are Javascript and CSS, but the GUI API just looks like a thin wrapper around the <a href="http://www.clutter-project.org/">Clutter</a> API, which is C++, and doesn't look any prettier in Javascript. Still, it's a start. I'd like to create a nice Twitter shell extension at some point.</p>

<p>So, this is day 4 of me switching from OS X to Linux Mint 12, and I am loving it. My next steps are to figure out a nice cross-platform notetaking replacement for Evernote, which I'm leaning towards plain Markdown files + Dropbox, and to set up my Datadog dev environment, which should be a cinch since our prod environment also uses apt-get. Maybe also trying out a native email client, though the Gmail web app plus a shell extension for email notifications are working out fine.</p>

<p>Hooray for the Linux community!</p>

<h4>Thumbnails</h4>
<ul class="thumbnails">
  <li class="span2"><a href="img/00000002-desktop.png"><img src="img/00000002-desktop.png" /></a></li>
  <li class="span2"><a href="img/00000002-gwibber-software-center.png"><img src="img/00000002-gwibber-software-center.png" /></a></li>
  <li class="span2"><a href="img/00000002-gnome-shell.png"><img src="img/00000002-gnome-shell.png" /></a></li>
  <li class="span2"><a href="img/00000002-gtile.png"><img src="img/00000002-gtile.png" /></a></li>
</ul>
TEXT
)
export BLOG_DATE="2012-02-20T00:00 EST"
