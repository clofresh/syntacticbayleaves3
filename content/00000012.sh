export BLOG_ID=00000012
export BLOG_TITLE="Using an egpu on Linux"
export BLOG_BODY=$(cat <<TEXT
<p>I've written previously about <a href="00000010.html">getting a Thunderbolt
dock</a> to power my external monitor and it's been mostly fine. I can plug
my monitor, speakers and usb devices into it and just have one Thunderbolt
cable to plug into my XPS 13 and get access to all the good stuff.</p>

<p>My one complaint is that even though my external monitor doesn't stutter
anymore, performance wasn't as good as it could be. General windowing operations
still had noticable lag, my laptop got super hot when it was driving the monitor,
and games were still pretty much unplayable on due to poor framerate.</p>

<p>I've been following the progress of <a href="https://egpu.io/">external graphics cards</a>
(egpus), and it sounded like they're pretty much plug and play, at least for Windows,
and more and more OS X. There haven't been too many reports of it working on Linux,
but emboldened by my excellent experience running Arch, I took the plunge and
bought a <a href="https://www.amazon.com/dp/B072L9QTZT/">Sonnet eGFX Breakaway Box</a>
and a secondhand <a href="https://www.geforce.com/hardware/desktop-gpus/geforce-gtx-660">Nvidia GTX 660</a>.</p>

<div class="text-center"><img src="img/00000012-sonnet-egfx.png" alt="Sonnet eGFX Breakaway Box" /></div>

<p>After I got everything and plugged the graphics card into the Sonnet enclosure,
I installed the <code>nvidia-dkms</code> package and dependencies, plugged the egpu into my
dock's Thunderbolt port, plugged my XPS into my dock and everything just worked!</p>

<p>X found the second gpu just fine and rendered the second monitor as an extension
of the laptop monitor the same way I had it with the single integrated gpu.</p>

<p>General windowing performance was snappy. Full screen YouTube videos on the
monitor didn't burn up my laptop. Framerate on simpler games like Don't Starve
and Rimworld was excellent, in the 60s, and games like XCOM2 and Everspace were
playable in the 20s. Everything was just how it should be for the most part.</p>

<p>The only annoying thing now is that I can't hotunplug the egpu out. I have to
poweroff my laptop before unplugging it from the egpu, which is kind of a drag.
If I don't, everything just freezes. Hopefully as more people get egpus on Linux,
kernel/driver/xorg devs will fix this issue. If you're working on it, drop me a
line, I'm happy to test stuff!</p>

<p>Besides hotplugging, everything was great. Until I got a dreaded breaking
change in the nvidia drivers 😱</p>

<p>Upgrading from nvidia driver version 390.48 to 396.24 caused my X to crash
on bootup. After digging in the X logs (<code>/var/log/Xorg.0.log</code>) I found:</p>

<pre><code class="language-config">[    23.631] (WW) NVIDIA(GPU-0): This device is an external GPU, but external GPUs have not
[    23.631] (WW) NVIDIA(GPU-0):     been enabled with AllowExternalGpus. Disabling this device
[    23.631] (WW) NVIDIA(GPU-0):     to prevent crashes from accidental removal.
[    23.694] (EE) NVIDIA(0): Failing initialization of X screen 0
</code></pre>

<p>Kind of ironic that it did end up causing a crash anyway.</p>

<p>I was kind of annoyed that I had to add this new X option because I had 0 X
config. Everything was configured dynamically, and I set my desktop
resolution and positioning using an xrandr script at startup.</p>

<p>At first I thought I had to configure EVERY. SINGLE. THING statically
in xorg config and was super frustrated that I couldn't get X to merge
my two monitors with static config.</p>

<p>Eventually I figured out that I can still let xrandr do most of the work,
I just needed to define my devices. This is the config I ended up with:</p>

<pre><code class="language-config">Section "Monitor"
	Identifier   "Laptop"
	VendorName   "Dell"
	Option "Below" "External"
	Option "DPMS" "true"
EndSection

Section "Monitor"
	Identifier   "External"
	VendorName   "Asus"
	Option "Above" "Laptop"
	Option "DPMS" "true"
EndSection

Section "Device"
	Identifier  "gtx660"
	Driver      "nvidia"
	BusID       "PCI:12:0:0"
	Option      "AllowExternalGpus" "True"
	Option      "Monitor-HDMI-0" "External"
EndSection

Section "Device"
	Identifier  "iris"
	Driver      "modesetting"
	BusID       "PCI:0:2:0"
	Option      "Monitor-eDP-1-1" "Laptop"
EndSection
</code></pre>

<p>And then everything was fine again! Unfortunately, hotswapping still didn't
work even with the new AllowExternalGpus option. But I could upgrade to the
latest packages and everything was back to normal!</p>

<div class="text-center"><img src="img/00000012-egpu-workstation.jpg" alt="My workstation with the dual monitors and egpu" /></div>

<p>Hooray for Linux continuing to be a great option as an everyday workstation.</p>

TEXT
)
export BLOG_DATE="2018-05-24T10:43 PST"
