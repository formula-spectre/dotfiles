{-# LANGUAGE PostfixOperators #-}
{-# OPTIONS_GHC -Wall -Werror -O3 #-}
import           System.Environment        (getEnv)
import           System.IO.Unsafe          (unsafeDupablePerformIO)
import           Theme.Theme               (myFont)
--import           XMonad.Hooks.StatusBar.PP (wrap)

import           Xmobar

black, white :: String
black  = "#000000"
white  = "#FFFFFF"
wrap :: String -> String -> String -> String
wrap _ _ "" = ""
wrap l r m = l ++ m ++ r
-- | Configures how things should be displayed on the bar
config :: Config
config =
  defaultConfig
    { font =
        concatMap
          fontWrap
          [ myFont
          , "xft:LispM Nerd Font:italic:pixelsize=12:antialias=true:hinting=true"
          ]
    , additionalFonts =
        [ "xft:LispM Nerd Font:size=12"
        , "xft:LispM Nerd Font:size=14"
        ]
    , bgColor = black
    , fgColor = white
    , border = FullB
    , borderColor = white
    , position = TopH 20
    , lowerOnStart = True
    , hideOnStart = False
    , allDesktops = True
    , persistent = True
    , overrideRedirect = False
    , iconRoot = xmonadConfigHome <> "/xpm"
    , commands = myCommands
    , sepChar = "%"
    , alignSep = "}{"
    , template =
        wrap "" "" "<icon=haskell_20.xpm/> "
          <> wrap " <box type=Bottom width=2 mb=4>" "</box>" "Metroplex: %online%"
--M          <> wrap " :|: " " :|: " "%catfile%"
          <> wrap " " " " "%_XMONAD_LOG_0%"
          <> wrap " <!" "!>}" "%tiramisu%"
          <> wrap "" "" "%date%"
          <> wrap " " "{" "%locks%"
          <> wrap "[" "]" "%battery%"
--          <> wrap "[<action=`pavucontrol`>" "</action>]" "%default:Master%"
          <> wrap "[" "]" "%thermal0%"
          <> wrap "[" "]" "%cpu%"
          <> wrap "[" "] " "%memory%"
          -- <> wrap "[" "]" "%date%"
          <> wrap "" "" "%tray%"
    }
 where
  fontWrap :: String -> String
  fontWrap = wrap "" ","

-- | Commands to run xmobar modules on start
myCommands :: [Runnable]
myCommands =
  [ Run $ Cpu
    [ "-t"
    , "CPU:(<total>%)"
    , "-H"
    , "50"
    , "--high"
    , "white"
    ]
    ( 2 `seconds`)
    , Run $ Memory
    [ "-t"
    , "RAM: <used>M (<usedratio>%)"
    ]
    (2 `seconds`)
  , Run $ ThermalZone 0
    [
      "-t"
    , "TEMP:<temp>"
    ]
    (3 `seconds`)
  , Run $ BatteryP ["BAT0"]
    [
    "-t"
    , "BAT:<acstatus> <left>% (<timeleft>)"
    , "-L", "21", "-l", "yellow"
    ]
    (10 `seconds`)
--  , Run $ Volume  "default" "Master" []
--   (3 `seconds`)
  , Run $ Date ("%b %a %d (%H:%M:%S)") "date" (1 `seconds`)
  , Run $ Com( xmonadConfigHome <> "/scripts/online.sh") [] "online" 90
  , Run $ Com (xmonadConfigHome <> "/scripts/trayer-padding-icon.sh") [] "tray" 5
  , Run $ Com( xmonadConfigHome <> "/scripts/catfile.sh") []  "catfile" (300 `seconds`)
  , Run $ CommandReader (xmonadConfigHome <> "/scripts/tiramisu.sh")  "tiramisu"
  , Run $ Locks
  ]
  where
    -- Convenience functions
    seconds :: Int -> Int
    seconds = (* 10)
    -- minutes = (60 *). seconds

-- | Get home directory
xmonadConfigHome:: String
xmonadConfigHome = unsafeDupablePerformIO (getEnv "XMONAD_CONFIG_HOME")


main :: IO ()
main = xmobar config
