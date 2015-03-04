-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- Load Debian menu entries
require("debian.menu")

naughty.config.presets.normal.font = "Verdana 12"


-- Override awesome.quit when we're using GNOME
_awesome_quit = awesome.quit
awesome.quit = function()
    if os.getenv("DESKTOP_SESSION") == "awesome-gnome" then
       os.execute("/usr/bin/gnome-session-quit")
    else
  _awesome_quit()
    end
end

-- Start xcompmgr for tiling
awful.util.spawn_with_shell("xcompmgr &")




-- Begin misc widgets
-- *******************************************************
-- *******************************************************
-- *******************************************************

-- Pomodoro
-- Obtained at http://blog.nistu.de/2011/08/19/a-pomodoro-timer-for-the-awesome-window-manager

-- pomodoro timer widget
pomodoro = {}
-- tweak these values in seconds to your liking
pomodoro.pause_duration = 300
pomodoro.work_duration = 1200

pomodoro.pause_title = "Pause finished."
pomodoro.pause_text = "Get back to work!"
pomodoro.work_title = "Pomodoro finished."
pomodoro.work_text = "Time for a pause!"
pomodoro.working = true
pomodoro.left = pomodoro.work_duration
pomodoro.widget = widget({ type = "textbox" })
pomodoro.timer = timer { timeout = 1 }

function pomodoro:settime(t)
  if t >= 3600 then -- more than one hour!
    t = os.date("%X", t-3600)
  else
    t = os.date("%M:%S", t)
  end
  self.widget.text = string.format("Pomodoro: <b>%s</b>", t)
end

function pomodoro:notify(title, text, duration, working)
  naughty.notify {
    bg = "#ff0000",
    fg = "#aaaaaa",
    title = title,
    text  = text,
    timeout = 10
  }

  pomodoro.left = duration
  pomodoro:settime(duration)
  pomodoro.working = working
end

pomodoro:settime(pomodoro.work_duration)

pomodoro.widget:buttons(
  awful.util.table.join(
    awful.button({ }, 1, function()
      pomodoro.last_time = os.time()
      pomodoro.timer:start()
    end),
    awful.button({ }, 2, function()
      pomodoro.timer:stop()
    end),
    awful.button({ }, 3, function()
      pomodoro.timer:stop()
      pomodoro.left = pomodoro.work_duration
      pomodoro:settime(pomodoro.work_duration)
    end)
))

pomodoro.timer:add_signal("timeout", function()
  local now = os.time()
  pomodoro.left = pomodoro.left - (now - pomodoro.last_time)
  pomodoro.last_time = now

  if pomodoro.left > 0 then
    pomodoro:settime(pomodoro.left)
  else
    if pomodoro.working then
      pomodoro:notify(pomodoro.work_title, pomodoro.work_text,
        pomodoro.pause_duration, false)
    else
      pomodoro:notify(pomodoro.pause_title, pomodoro.pause_text,
        pomodoro.work_duration, true)
    end
    pomodoro.timer:stop()
  end
end)




-- Battery
-- Obtained at https://github.com/koentje/awesome-batteryInfo

function batteryInfo(adapter)
  local fh = io.open("/sys/class/power_supply/"..adapter.."/present", "r")
  if fh == nil then
    battery = "A/C"
    icon = ""
    percent = ""
  else
    local fcur = io.open("/sys/class/power_supply/"..adapter.."/energy_now")  
    local fcap = io.open("/sys/class/power_supply/"..adapter.."/energy_full")
    local fsta = io.open("/sys/class/power_supply/"..adapter.."/status")
    local cur = fcur:read()
    local cap = fcap:read()
    local sta = fsta:read()
    fcur:close()
    fcap:close()
    fsta:close()
    battery = math.floor(cur * 100 / cap)
  
    if sta:match("Charging") then
      icon = "⚡"
      percent = "%"
    elseif sta:match("Discharging") then
      icon = ""
      percent = "%"
      if tonumber(battery) < 15 then
        naughty.notify({ title    = "Battery Warning"
               , text     = "Battery low!".."  "..battery..percent.."  ".."left!"
               , timeout  = 5
               , position = "top_right"
               , fg       = beautiful.fg_focus
               , bg       = beautiful.bg_focus
        })
      end
    end
  end
  return " "..icon..battery..percent.." "
end
-- *******************************************************
-- *******************************************************
-- *******************************************************
-- End misc widgets





-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init(awful.util.getdir("config") .. "/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}



-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}


-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4 }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
my_misc_menu = {
  { "Restart Awesome", awesome.restart },
  { "CUPS", "xdg-open http://localhost:631" },
}

my_accessories_menu = {
  { "Calculator", "gnome-calculator" } 
}

my_internet_menu = {
  { "Chrome", "google-chrome" }
}

my_system_menu = {
  { "Logout", awesome.quit},
  { "Reboot", "gksudo 'reboot now'" },
  { "Shutdown", "gksudo 'shutdown -P now'"}
}



mymainmenu = awful.menu({ items = { 
        { "Terminal", terminal },
        { "Accessories", my_accessories_menu },
        { "Internet", my_internet_menu },
        { "Misc", my_misc_menu },
        --{ "Multimedia", my_multimedia_menu },
        { "System", my_system_menu }
                                  }, width="150" 
})

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })



-- Create an ACPI widget for battery info 
mybatterywidget = widget({ type = "textbox" }) 
mybatterywidget.text = " | Battery | "                                    
mybatterywidgettimer = timer({ timeout = 5 })                                
mybatterywidgettimer:add_signal("timeout",     
  function()                                      
    fh = assert(io.popen("acpi | cut -d, -f 2,3 -", "r"))
    mybatterywidget.text = " |" .. fh:read("*l") .. " | "
    fh:close()                       
  end                       
)
mybatterywidgettimer:start()




-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        pulseWidget,        
        mylayoutbox[s],
        mytextclock,
        mybatterywidget,
        pomodoro.widget,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings

-- ***** Changed to fit Norman keyboard layout *****
-- s/"n"/"p"
-- s/"j"/"n"
-- s/"k"/"i"
-- s/"l"/"o"
-- Change awful.client.movetoscreen from "o" to "l"
-- Leaving the "r" keybindings
globalkeys = awful.util.table.join(
awful.key({ modkey }, "Escape", awful.tag.history.restore),
awful.key({ modkey }, "Next",  function () awful.client.moveresize( 20,  20, -40, -40) end),
awful.key({ modkey }, "Prior", function () awful.client.moveresize(-20, -20,  40,  40) end),
awful.key({ modkey }, "Up",    function () awful.client.moveresize(  0, -20,   0,   0) end),
awful.key({ modkey }, "Down",  function () awful.client.moveresize(  0,  20,   0,   0) end),
awful.key({ modkey }, "Left",  function () awful.client.moveresize(-20,   0,   0,   0) end),
awful.key({ modkey }, "Right", function () awful.client.moveresize( 20,   0,   0,   0) end),
   
   -- Configure the hotkeys.
--awful.key({ }, "XF86AudioRaiseVolume",  pulseWidget.Up),
--awful.key({ }, "XF86AudioLowerVolume",  pulseWidget.Down),
--awful.key({ }, "XF86AudioMute",         pulseWidget.ToggleMute),

awful.key({ modkey,           }, "n",
    function ()
        awful.client.focus.byidx( 1)
        if client.focus then client.focus:raise() end
    end),
awful.key({ modkey,           }, "i",
    function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),
awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

-- Layout manipulation
awful.key({ modkey, "Shift"   }, "n", function () awful.client.swap.byidx(  1)    end),
awful.key({ modkey, "Shift"   }, "i", function () awful.client.swap.byidx( -1)    end),
awful.key({ modkey, "Control" }, "n", function () awful.screen.focus_relative( 1) end),
awful.key({ modkey, "Control" }, "i", function () awful.screen.focus_relative(-1) end),
awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
awful.key({ modkey,           }, "Tab",
    function ()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end),

-- Standard program
awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
awful.key({ modkey, "Control" }, "r", awesome.restart),
awful.key({ modkey, "Shift"   }, "q", awesome.quit),

awful.key({ modkey,           }, "o",     function () awful.tag.incmwfact( 0.05)    end),
awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
awful.key({ modkey, "Shift"   }, "o",     function () awful.tag.incnmaster(-1)      end),
awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
awful.key({ modkey, "Control" }, "o",     function () awful.tag.incncol(-1)         end),
awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

awful.key({ modkey, "Control" }, "p", awful.client.restore),

-- Prompt
-- awful.key({ modkey },            "r",    function () mypromptbox[mouse.screen]:run() end),
awful.key({ modkey },  "r", function () awful.util.spawn("dmenu_run") end),

awful.key({ modkey }, "x",
          function ()
              awful.prompt.run({ prompt = "Run Lua code: " },
              mypromptbox[mouse.screen].widget,
              awful.util.eval, nil,
              awful.util.getdir("cache") .. "/history_eval")
          end)
)

clientkeys = awful.util.table.join(
awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
awful.key({ modkey,           }, "l",      awful.client.movetoscreen                        ),
awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
awful.key({ modkey,           }, "p",
    function (c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
    end),
awful.key({ modkey,           }, "m",
    function (c)
        c.maximized_horizontal = not c.maximized_horizontal
        c.maximized_vertical   = not c.maximized_vertical
    end)
)






-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
