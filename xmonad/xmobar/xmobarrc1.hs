-- http://projects.haskell.org/xmobar/

Config { font    = "xft:Iosevka Nerd Font:italic:pixelsize=9:antialias=true:hinting=true"
       , additionalFonts = [ "xft:Mononoki Nerd Font:pixelsize=11:antialias=true:hinting=true"
                           , "xft:Font Awesome 5 Free Solid:pixelsize=12"
                           , "xft:Font Awesome 5 Brands:pixelsize=12"
                           ]
       , bgColor = "#000000"
       , fgColor = "#FFFFFF"
       , border = FullB
       , borderColor = "#FFFFFF"
       , position = Static { xpos = 1366 , ypos = 0, width = 1920, height = 24 }
       , lowerOnStart = True
       , hideOnStart = False
       , allDesktops = True
       , persistent = True
       , iconRoot = "/home/zgentoo-cloud/.config/xmonad/xpm/"  -- default: "."
       , commands = [
                    -- Time and date
                      Run Date "%b %d (%H:%M:%S)" "date" 1
                      -- Cpu usage in percent
                    , Run Cpu ["-t", "CPU:(<total>%)","-H","50"] 20
                      -- Ram used number and percent
                    , Run Memory ["-t", "RAM: <used>M (<usedratio>%)"] 20
                    --Battery
                    , Run BatteryP ["BAT0"] ["-t", "BAT:<acstatus> <left>%"]  10
                    --CPU temp
                    , Run ThermalZone 0 ["-t","TEMP:<temp>"] 30
                    --Trayer Padding
                    , Run Com "/home/zgentoo-cloud/.config/xmonad/xmobar/trayer-padding-icon.sh" [] "trayerpad" 20
                    , Run Com "/home/zgentoo-cloud/.config/xmonad/xmobar/online.sh" [] "online" 80
                      --Workspaces
                    , Run UnsafeStdinReader
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       --, template = " <icon=haskell_20.xpm/> }%UnsafeStdinReader%{ %battery%|%thermal0%|%cpu%|%memory%|%date%|%trayerpad%"
       --, template = " <icon=haskell_20.xpm/> <box type=Bottom width=2 mb=4 color=#51afef><fc=#51afef> Metroplex: online </fc> </box>}%UnsafeStdinReader%{ %battery%|%thermal0%|%cpu%|%memory%|%date%|%trayerpad%"
       , template = " <icon=haskell_20.xpm/> <box type=Bottom width=2 mb=4>Metroplex: %online% </box>}%UnsafeStdinReader%{ %battery%|%thermal0%|%cpu%|%memory%|%date%|%trayerpad%"
       }
