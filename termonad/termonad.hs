{-# LANGUAGE OverloadedStrings #-}
-- | This is an example Termonad configuration that shows how to use the
-- Dracula colour scheme https://draculatheme.com/

module Main where

import Data.Maybe (fromMaybe)
import Termonad
  ( CursorBlinkMode(CursorBlinkModeOn)
  , Option(Set)
  , ShowScrollbar(ShowScrollbarNever)
  , TMConfig
  , confirmExit
  , cursorBlinkMode
  , defaultConfigOptions
  , defaultTMConfig
  , options
  , showMenu
  , showScrollbar
  , start
  , FontConfig
  , FontSize(FontSizePoints)
  , defaultFontConfig
  , fontConfig
  , fontFamily
  , fontSize
  )
import Termonad.Config.Colour
  ( AlphaColour
  , ColourConfig
  , Palette(ExtendedPalette)
  , addColourExtension
  , createColour
  , createColourExtension
  , defaultColourConfig
  , defaultStandardColours
  , defaultLightColours
  , backgroundColour
  , foregroundColour
  , palette
  , List8
  , mkList8
  )

-- This is our main 'TMConfig'.  It holds all of the non-colour settings
-- for Termonad.
--
-- This shows how a few settings can be changed.
myTMConfig :: TMConfig
myTMConfig =
  defaultTMConfig
    { options =
        defaultConfigOptions
          { showScrollbar = ShowScrollbarNever
          , confirmExit = False
          , showMenu = False
          , cursorBlinkMode = CursorBlinkModeOn
          , fontConfig = fontConf
          }
    }

-- This is our Dracula 'ColourConfig'.
greyscale :: ColourConfig (AlphaColour Double)
greyscale =
  defaultColourConfig
    -- Set the default background & foreground colour of text of the terminal.
    { backgroundColour = Set (createColour  0  0  0)  -- black.0
    , foregroundColour = Set (createColour 255 255 255)  -- white.7
    -- Set the extended palette that has 2 Vecs of 8 Dracula palette colours
    , palette = ExtendedPalette greyScale greyScaleBright
    }
  where
    greyScale :: List8 (AlphaColour Double)
    greyScale = fromMaybe defaultStandardColours $ mkList8
      [ createColour  16  16  16    -- black.0
      , createColour 124 124 124    -- red.1
      , createColour 142 142 142    -- green.2
      , createColour 160 160 160    -- yellow.3
      , createColour 104 104 104    -- blue.4
      , createColour 116 116 116    -- magenta.5
      , createColour 134 134 134    -- cyan.6
      , createColour 185 185 185    -- white.7
      ]

    greyScaleBright :: List8 (AlphaColour Double)
    greyScaleBright = fromMaybe defaultStandardColours $ mkList8
      [ createColour 82 82 82 -- black.8
      , createColour 124 124 124 -- red.9
      , createColour 142 142 142 -- green.10
      , createColour 160 104 104 -- yellow.11
      , createColour 104 104 104 -- blue.12
      , createColour 116 116 116-- magenta.13
      , createColour 134 134 134 -- cyan.14
      , createColour 247 247 247 -- white.15
      ]

fontConf =
  defaultFontConfig
    { fontFamily = "LispM Nerd Font"
    , fontSize = FontSizePoints 10
    }

main :: IO ()
main = do
  -- First, create the colour extension based on either PaperColor modules.
  myColourExt <- createColourExtension greyscale

  -- Update 'myTMConfig' with our colour extension.
  let newTMConfig = addColourExtension myTMConfig myColourExt

  -- Start Termonad with our updated 'TMConfig'.
  start newTMConfig
