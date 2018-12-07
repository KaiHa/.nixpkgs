{-# LANGUAGE CPP #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE LambdaCase #-}

module Main (main) where

import           Paths_myxmonad
import           Adapt2Environment
import           Numeric
import           XMonad
import           XMonad.Actions.CycleWS (toggleWS)
import           XMonad.Actions.GridSelect
import           XMonad.Actions.UpdatePointer
import           XMonad.Actions.WindowBringer (gotoMenuArgs)
import           XMonad.Actions.WindowGo
import           XMonad.Hooks.FadeInactive (fadeInactiveLogHook)
import           XMonad.Hooks.ManageDocks (AvoidStruts, docksEventHook)
import           XMonad.Hooks.ManageHelpers
import           XMonad.Hooks.UrgencyHook
import           XMonad.Layout.Grid
import           XMonad.Layout.LayoutModifier (ModifiedLayout)
import           XMonad.Layout.Magnifier (magnifiercz)
import           XMonad.Util.EZConfig (additionalKeys)
import           XMonad.Util.Loggers (logCmd)
import           XMonad.Util.Paste (sendKeyWindow)
import           XMonad.Util.SpawnOnce
import           XMonad.Util.WorkspaceCompare (getSortByXineramaPhysicalRule)
import qualified XMonad.Actions.TagWindows as W
import qualified XMonad.Hooks.DynamicLog as L
import qualified XMonad.StackSet as W


main :: IO ()
main = xmonad . withHook =<< myxmobar defaults
  where
    withHook = withUrgencyHook (BorderUrgencyHook {urgencyBorderColor = "gold"})


--defaults :: XConfig _
defaults = def
  { borderWidth        = 2
  , focusFollowsMouse  = True
  , handleEventHook    = mconcat [docksEventHook, handleEventHook def]
  , layoutHook         = Tall 1 (3/100) (1/2) ||| Full ||| Grid
                         ||| Mirror (Tall 1 (3/100) (1/2))
                         ||| magnifiercz 1.5 (Tall 1 (3/100) (1/2))
  , logHook            = do
                         fadeInactiveLogHook 0.9
                         updatePointer (0.5, 0.5) (0.9, 0.9)
                         L.dynamicLogString rightPP >>= L.xmonadPropLog
                         logHook def
  , manageHook         = composeAll
                           [ (className =? "Firefox")  --> doShift "web"
                           , (className =? "Nightly")  --> doShift "web"
                           , (className =? "Emacs")    --> doShift "emacs"
                           , (appName   =? "gimp")     --> doFloat
                           , (title     =? "kuake")    --> doSideFloat NC -- <+> doShift "hidden"
                           , (appName   =? "pinentry") --> doFloat
                           , (appName   =? "wttr.in")  --> doFloat
                           ]
  , modMask            = mod4Mask
  , startupHook        = startup
  , terminal           = "alacritty -e tmux"
  , workspaces         = ["1", "2", "3", "4", "5", "6", "7", "8", "emacs", "web", "hidden"]
  } `additionalKeys` shortcuts


startup :: X ()
startup = do
  adapt2environment
  spawn "xset b off dpms 300 300 300"
  spawnOnce "xcompmgr"
  spawn     "alacritty --title kuake --dimensions 140 40 -e tmux new-session -s Q"
  --spawnOnce "nitrokey-app"
  spawnOnce "blueman-applet"
  spawnOnce "usermount"  -- automount of removable media
  spawnOnce "unclutter --timeout 3"
  windows $ W.view "1"
  spawn "xsetroot -cursor_name left_ptr"


myxmobar :: LayoutClass l Window => XConfig l -> IO (XConfig (ModifiedLayout AvoidStruts l))
myxmobar conf =
  getDataFileName "xmobarrc" >>= \cfg ->
  L.statusBar ("xmobar " ++ cfg) leftPP toggleStrutsKey conf
  where
    toggleStrutsKey XConfig{modMask = modm} = (modm, xK_b )


leftPP :: L.PP
leftPP = def { L.ppCurrent = L.xmobarColor "black" "yellow" . L.wrap "[<fn=1>" "</fn>]"
             , L.ppSep     = "<fc=#888888> | </fc>"
#if MIN_VERSION_xmonad_contrib(0,14,0)
             , L.ppSort    = getSortByXineramaPhysicalRule def
#else
             , L.ppSort    = getSortByXineramaPhysicalRule
#endif
             , L.ppTitle   = L.wrap "<fn=3>" "</fn>" . L.xmobarColor "black"  "" . L.shorten 100
             , L.ppTitleSanitize = \xs -> [if x `elem` "\n\r\\^<>" then ' ' else x | x <- xs]
             , L.ppVisible = L.xmobarColor "#cccccc" "#666600". L.wrap ".<fn=1>" "</fn>."
             , L.ppHidden  = \case
                                "hidden" -> ""
                                a'       -> L.wrap "<fn=1>" "</fn>" a'
             , L.ppUrgent  = L.xmobarColor "yellow" "red" . L.wrap "<fn=1>" "*</fn>"
             , L.ppOrder   =  \(w:_:t:_) -> [w, t]
             }


rightPP :: L.PP
rightPP = def { L.ppSep     = " "
              , L.ppExtras  = [ notmuch, load ]
              , L.ppOrder   = drop 3
              }


notmuch :: X (Maybe String)
notmuch = do
  count <- logCmd "notmuch count tag:inbox and tag:unread"
  return $ case count of
    Just "0" -> Nothing
    Just a   -> Just $ "<fc=#AA0000><fn=5>📨</fn>" ++ a ++ "</fc>"
    Nothing  -> Nothing


load :: X (Maybe String)
load = do
  l <- logCmd "awk '{print $1, $2, $3}' /proc/loadavg"
  icon <- liftIO $ getDataFileName "cpu.xbm" >>= pure . \a -> "<icon=" ++ a ++ "/>"
  return $ case l of
    Just load' -> Just $ icon ++ unwords (map (colorize . read) $ words load')
    Nothing    -> Nothing
  where
    limit = 0.8 :: Double
    colorize a =
      if a < limit
      then "<fc=black>" ++ showFFloat (Just 2) a "" ++ "</fc>"
      else "<fc=red>"   ++ showFFloat (Just 2) a "" ++ "</fc>"


shortcuts :: [((KeyMask, KeySym), X ())]
shortcuts =
  [ ((mod4Mask,                 xK_0),          windows $ W.greedyView "web")
  , ((mod4Mask .|. shiftMask,   xK_0),          windows $ W.shift "web")
  , ((mod4Mask,                 xK_i),          goToSelected def)
  , ((controlMask .|. mod1Mask, xK_l),          spawn "sudo physlock -d")
  , ((mod4Mask,                 xK_o),          gotoMenuArgs ["-i", "-nf", "black", "-nb", "#99FF99"])
  , ((mod4Mask,                 xK_p),          spawn "dmenu_run -i -nf black -nb '#FFFF66'")
  , ((mod4Mask .|. shiftMask,   xK_p),          spawn "gmrun")
  , ((mod4Mask,                 xK_Escape),     toggleWS)
  , ((noModMask,                xK_Mute),       spawn "amixer sset Master toggle")
  , ((noModMask,                xK_LowerVol),   spawn "amixer sset Master 2%-")
  , ((noModMask,                xK_RaiseVol),   spawn "amixer sset Master 2%+")
  , ((noModMask,                xK_BrightUp),   spawn "xbacklight -inc 5")
  , ((noModMask,                xK_BrightDown), spawn "xbacklight -dec 5")
  -- , ((mod4Mask .|. mod1Mask,    xK_Return),     spawn "urxvtc -bg black -fg white")
  , ((noModMask,                xK_Launch6),    runOrRaise "firefox" (className =? "Firefox"))
  , ((noModMask,                xK_Launch5),    raiseMaybe (spawn "emacsclient -c") (className =? "Emacs"))
  , ((noModMask,                xK_Launch1),    raiseMaybe (spawn "emacsclient -c") (className =? "Emacs"))
  , ((noModMask,                xK_Mail),       runOrRaiseAndDo "emacsclient -c" (className =? "Emacs")
      (\a -> sendKeyWindow controlMask xK_x a >> sendKeyWindow noModMask xK_n a))
  , ((mod4Mask,                 xK_space),      liftIO (getDataFileName "togglekb") >>= spawn)
  , ((noModMask,                xK_Display),    adapt2environment)
  , ((noModMask,                xK_F12),        ifWindows (title =? "kuake")
                                                  (mapM_ (\win -> withDisplay
                                                           (\dsp ->
                                                              withWindowAttributes dsp win
                                                              (\attr ->
                                                                 if wa_map_state attr == waIsViewable
                                                                 then windows $ W.shiftWin "hidden" win
                                                                 else windows $ W.shiftHere win
                                                              )))
                                                  )
                                                  (pure ())
    )
  ]
  where
    xK_LowerVol    = stringToKeysym "XF86AudioLowerVolume"
    xK_RaiseVol    = stringToKeysym "XF86AudioRaiseVolume"
    xK_Mute        = stringToKeysym "XF86AudioMute"
    xK_ScreenSaver = stringToKeysym "XF86ScreenSaver"
    xK_Launch1     = stringToKeysym "XF86Launch1"
    xK_Launch5     = stringToKeysym "XF86Launch5"
    xK_Launch6     = stringToKeysym "XF86Launch6"
    xK_Mail        = stringToKeysym "XF86Mail"
    xK_BrightUp    = stringToKeysym "XF86MonBrightnessUp"
    xK_BrightDown  = stringToKeysym "XF86MonBrightnessDown"
    xK_Display     = stringToKeysym "XF86Display"
