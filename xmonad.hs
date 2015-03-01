import XMonad

--import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Util.EZConfig
--import XMonad.Actions.CopyWindow
import XMonad.Actions.CycleWS
import qualified XMonad.StackSet as W

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks

import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.PerWorkspace(onWorkspace)
import XMonad.Layout.Tabbed

import XMonad.Prompt
import XMonad.Prompt.Shell
-- import XMonad.Prompt.Ssh

import XMonad.Util.Dmenu (dmenu)
import System.Exit (exitWith, ExitCode(..))
-- import System.Posix.User
-- import Network.BSD hiding (hostName)


import Control.Monad

-- term = "urxvt -fn 'xft:Monospace:pixelsize=13' -bg black -fg white -sr -scrollstyle plain"
term :: String
term = "gnome-terminal --disable-factory"

my_workspaces :: [(String, String)]
my_workspaces =
  map (\n -> (show n, show n)) [0 .. 9 :: Int]
  ++ map (\n -> (show n, "C-" ++ show (n - 10))) [10 .. 19 :: Int]
  ++ [("mail", "m"), ("pers", "p"), ("irc", "i"), ("web", "f"), ("dev", "d"), ("rss","r")]
my_workspace_names :: [String]
my_workspace_names = map fst my_workspaces

-- From https://bbs.archlinux.org/viewtopic.php?id=120298
quitWithWarning :: X ()
quitWithWarning = do
  let m = "confirm quit"
  s <- dmenu [m]
  when (m == s) (io (exitWith ExitSuccess))

myKeys :: [(String, X ())]
myKeys =
  [ ("C-M-q",       restart "xmonad" True)
  , ("M-<Left>",    prevWS)
  , ("M-<Right>",   nextWS)
  , ("M-S-<Left>",  shiftToPrev >> prevWS)
  , ("M-S-<Right>", shiftToNext >> nextWS)
  , ("M-S-q", quitWithWarning)
  ] ++
  concatMap
  (\(name, key) ->
  [ ("M-" ++ key, windows $ W.greedyView name)
  , ("M-S-" ++ key, windows $ W.shift name)
  ]
  )
  my_workspaces
  ++
  [ ("M-S-l",     spawn "xscreensaver-command -lock")
  , ("M-<Esc>",   spawn "xkill")
  , ("M-;",       shellPrompt defaultXPConfig)
  ]

myManageHook = composeAll 
                [ isFullscreen --> doFullFloat 
                , title =? "Gloss"  --> doFloat
                , className =? "Pidgin" --> doShift "irc"
                -- , className =? "Firefox" --> doShift "web"
                ]
------------------------------------------------------------------------
-- Layouts
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
-- 
-- The available layouts. Note that each layout is separated by |||,
-- which denotes layout choice.
-- 
myLayouts = avoidStruts (
    Tall 1 (3/100) (1/2)          |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    tabbed shrinkText tabConfig   |||
    Full                          |||
    spiral (6/7))                 |||
    noBorders (fullscreenFull Full)
------------------------------------------------------------------------
tabConfig = defaultTheme
    { activeBorderColor   = "#7C7C7C"
    , activeTextColor     = "#CEFFAC"
    , activeColor         = "#000000"
    , inactiveBorderColor = "#7C7C7C"
    , inactiveTextColor   = "#EEEEEE"
    , inactiveColor       = "#000000"
    }

myConfig = 
    defaultConfig {
                modMask = mod4Mask,
                terminal = term,
                workspaces = my_workspace_names,
                manageHook = myManageHook <+> manageHook defaultConfig,
                -- layoutHook = tall ||| reflectHoriz tall ||| Mirror tall ||| Full,
                layoutHook = myLayouts,
                normalBorderColor = "#002b36",
                -- normalBorderColor = "#657b83",
                focusedBorderColor = "#657b83",
                -- focusedBorderColor = "#d33692",
                borderWidth = 2
              } `additionalKeysP` myKeys

myPP = xmobarPP
        { ppCurrent = xmobarColor "#b58900" "" . wrap "[" "]"
        , ppTitle   = xmobarColor "#859900"  "" . shorten 40
        , ppUrgent  = xmobarColor "#6c71c4" "#b58900"
        -- , ppUrgent  = xmobarColor "#dc322f" "#b58900"
        }
        {-{ ppCurrent = xmobarColor "yellow" "" . wrap "[" "]"
        , ppTitle   = xmobarColor "green"  "" . shorten 40
        , ppUrgent  = xmobarColor "red" "yellow"
        }-}

main :: IO ()
main = do
  -- xmonad =<< xmobar cfg
  xmonad =<< statusBar "xmobar" myPP toggleStrutsKey cfg
  where cfg = withUrgencyHook NoUrgencyHook myConfig 

-- 
--
-- xmobar :: LayoutClass l Window
--        => XConfig l -> IO (XConfig (ModifiedLayout AvoidStruts l))
-- xmobar conf = statusBar "xmobar" xmobarPP toggleStrutsKey conf
-- |
-- Helper function which provides ToggleStruts keybinding
--
toggleStrutsKey :: XConfig t -> (KeyMask, KeySym)
toggleStrutsKey XConfig{modMask = modm} = (modm, xK_b )
