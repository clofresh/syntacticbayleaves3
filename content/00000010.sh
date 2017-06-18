export BLOG_ID=00000010
export BLOG_TITLE="Making a simple AwesomeWM widget"
export BLOG_BODY=$(cat <<TEXT
<p>It's been a long time since I <a href="00000002.html">switched to Linux</a>,
but I've been running Arch Linux instead of Mint for a few years now. My current
workstation is a <a href="https://www.dell.com/developers">Dell XPS 13</a>,
which is a really lightweight, pleasantly designed device whose hardware is all
well-supported on Linux.</p>

<p>The main weak point is its integrated graphics card, which I found couldn't
drive an external 1080p monitor on its own without stuttering. I bought the
<a href="https://www.amazon.com/gp/product/B06XN6XWD7/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&tag=sbl24601-20&camp=1789&creative=9325&linkCode=as2&creativeASIN=B06XN6XWD7&linkId=087842c220a58a8edfab34d274cc8a43">Dell TB16 Dock</a>
to drive the monitor, which fixed the problem nicely with <a href="https://wiki.archlinux.org/index.php/Dell_XPS_15_(9550)#Thunderbolt_3_Docks">minimal fuss</a>.
Now I can use an external monitor like a normal person!</p>

<p>But! The fans are always on high when I'm plugged into the dock and using the external monitor.
I got concerned about the cpu temperature, so started monitoring it with a
simple watch command:</p>

<pre><code class="language-bash">$ watch -n 1 sensors
Every 1.0s: sensors                       xps13-arch: Sun Jun 18 14:47:16 2017
coretemp-isa-0000
Adapter: ISA adapter
Package id 0:  +53.0°C  (high = +100.0°C, crit = +100.0°C)
Core 0:        +52.0°C  (high = +100.0°C, crit = +100.0°C)
Core 1:        +52.0°C  (high = +100.0°C, crit = +100.0°C)

acpitz-virtual-0
Adapter: Virtual device
temp1:        +25.0°C  (crit = +107.0°C)
temp2:        +27.8°C  (crit = +105.0°C)
temp3:        +29.8°C  (crit = +105.0°C)

iwlwifi-virtual-0
Adapter: Virtual device
temp1:        +37.0°C

pch_skylake-virtual-0
Adapter: Virtual device
temp1:        +49.5°C
</code></pre>

<p>I thought it would be cool to see temperature in a more minimal way on my
taskbar. Since I used <a href="https://awesomewm.org/">Awesome</a> as my window
manager, I have pretty fine-grained control over the UI, so instead of installing
a standalone app just for the temperature, I decided to learn a little bit about
Awesome's text widget api so I can translate my command line call into data that
drives a text widget. This is what I came up with:</p>

<pre><code class="language-lua">-- Instantiate a new textbox widget
local tempwidget = wibox.widget.textbox()

-- The shell command to run. In this case, we call sensors in a for loop,
-- sleeping 5s in between each call. We pass -u to sensors to get raw
-- unformatted data from it, and coretemp-isa-0000 tells it to get just
-- my cpu's temperature. We pipe that output into awk to get just the
-- numeric value.
local cmd = [[bash -c "
while true; do
    sensors -u coretemp-isa-0000 | awk '/temp1_input/ { print $2 }'
    sleep 5
done
"]]

-- The shell command is a blocking call but we don't want to block
-- the rest of the UI waiting on it, so we use Awesome's
-- awful.spawn.with_line_callback() to spawn a subprocess for the
-- command and call our callback whenever there's new stdout data.
-- Awesome handles this subprocess communication in a nonblocking
-- way so the rest of the UI stays responsive.
awful.spawn.with_line_callback(cmd, {
    stdout = function(line)
        -- This callback gets called whenever there's a new stdout line,
        -- so in our command's case, every new temperature sample.
        -- We do some simple string formatting on the value and update
        -- the widget's value. Note that tempwidget is a closure on
        -- the widget we instantiated earlier.
        tempwidget:set_markup(string.format(' CPU: %.0f°C ', tonumber(line)))
    end,
    stderr = function(line)
        -- Here we just post Awesome notifications if there's anything in stderr
        -- in case the sensors command writes some errors to stderr.
        naughty.notify({ text = "ERR:"..line})
    end,
})

-- I'm omitting a lot of other layout code that probably already exists in your
-- theme, but I'm assuming there's a layout for the right side of your taskbar
right_layout:add(tempwidget)

</code></pre>

<p>This all feels nicely Linuxly. I didn't have to spin up a new app with
complicated GUI dependencies just to get a simple value that I could
already get from command line.</p>
TEXT


)
export BLOG_DATE="2017-06-18T18:09 PDT"
