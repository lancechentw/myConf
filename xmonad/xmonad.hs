import XMonad
import System.Exit
 
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.EwmhDesktops
import System.IO ( Handle, hFlush, hPutStrLn, IOMode(AppendMode), hClose, openFile )
import Dzen

import Graphics.X11.ExtraTypes.XF86 as XF86

import XMonad.Hooks.SetWMName

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "urxvt"
 
-- Width of the window border in pixels.
--
myBorderWidth   = 3
 
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask
 
-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2        Num_Lock (0x4d)
--
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
--
myNumlockMask   = mod2Mask
 
-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9","0","-","="]
 
-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#000000"
myFocusedBorderColor = "#88a470"
 
------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
 
    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    , ((modm,               xK_d     ), spawn "xrandr --output HDMI1 --off --output HDMI2 --off --output DP1 --off --output DP2 --off")

    , ((modm .|. shiftMask, xK_d     ), spawn "/home/lance/bin/screen.sh")

    -- volume control
    , ((0           , 0x1008FF12 ), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")

    , ((0           , 0x1008FF13 ), spawn "pactl -- set-sink-volume @DEFAULT_SINK@ +1%")

    , ((0           , 0x1008FF11 ), spawn "pactl -- set-sink-volume @DEFAULT_SINK@ -1%")

    , ((0           , 0x1008FF2F ), spawn "/usr/bin/systemctl suspend")

    , ((0           , 0x1008FFA7 ), spawn "/usr/bin/systemctl hibernate")

    , ((0           , 0x1008FF2D ), spawn "/usr/bin/slimlock")

    , ((modm .|. shiftMask, xK_l ), spawn "/usr/bin/slimlock")

    , ((0           , 0x1008ff93 ), spawn "xset dpms force off")

    , ((0           , XF86.xF86XK_MonBrightnessUp ), spawn "xbacklight +10")

    , ((0           , XF86.xF86XK_MonBrightnessDown ), spawn "xbacklight -10")

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "/usr/bin/dmenu_run")
 
    -- launch gmrun
    -- , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")
 
    -- close focused window 
    , ((modm .|. shiftMask, xK_c     ), kill)
 
     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
 
    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)
 
    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)
 
    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)
 
    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )
 
    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )
 
    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)
 
    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )
 
    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )
 
    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)
 
    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)
 
    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

     -- 
    , ((modm .|. shiftMask, xK_t     ), spawn "thunar")

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
 
    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
 
    -- toggle the status bar gap (used with avoidStruts from Hooks.ManageDocks)
    , ((modm , xK_b ), sendMessage ToggleStruts)
 
    -- Quit xmonad
    -- , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
 
    -- Restart xmonad
    -- , ((modm              , xK_q     ), restart "xmonad" True)
    , ((modm .|. shiftMask   , xK_q     ), restart "xmonad" True)
    ]
    ++
 
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0, xK_minus, xK_equal])
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
 
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
 
 
------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
 
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))
 
    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))
 
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))
 
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]
 
------------------------------------------------------------------------
-- Layouts:
 
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
-- myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full) ||| Full
myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full)

  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
 
     -- The default number of windows in the master pane
     nmaster = 1
 
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
 
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
 
------------------------------------------------------------------------
-- Window rules:
 
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "URxvt"           --> doFloat
    , className =? "Thunar"           --> doFloat
    , className =? "PPStream"           --> doFloat
    , className =? "feh"            --> doFloat
    , resource  =? "sun-awt-X11-XFramePeer" --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]
 
-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True
 
 
------------------------------------------------------------------------
-- Status bars and logging
 
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--
-- myLogHook = return ()
-- myLogHook = dynamicLogWithPP dzenPP
myLogHook h = dynamicLogWithPP $ def
    -- display current workspace as darkgrey on light grey (opposite of default colors)
    { ppCurrent         = dzenColor "#303030" "#909090" . pad 

    -- display other workspaces which contain windows as a brighter grey
    , ppHidden          = dzenColor "#909090" "" . pad 

    -- display other workspaces with no windows as a normal grey
    , ppHiddenNoWindows = dzenColor "#606060" "" . pad 

    -- display the current layout as a brighter grey
    , ppLayout          = dzenColor "#909090" "" . pad 

    -- if a window on a hidden workspace needs my attention, color it so
    , ppUrgent          = dzenColor "#303030" "#3eec90" . pad . dzenStrip

    -- shorten if it goes over 100 characters
    , ppTitle           = shorten 100  

    -- no separator between workspaces
    , ppWsSep           = ""

    -- put a few spaces between each object
    , ppSep             = "  "

    , ppOutput          = hPutStrLn h -- ... must match the h here
    }

-- 
-- StatusBars
-- 
myLeftBar :: DzenConf
myLeftBar = defaultDzen
    -- use the default as a base and override width and
    -- colors
    { width   = Just $ Percent 70
    , fgColor = Just "#909090"
    , bgColor = Just "#303030"
    -- , font = Just "-*-monaco-medium-r-normal-*-12-*-*-*-*-*-*-*"
    , font = Just "WenQuanYi Micro Hei Mono-12"
    }

myRightBar :: DzenConf
myRightBar = myLeftBar
    -- use the left one as a base and override just the
    -- x position and width
    { xPosition = Just $ Percent 70
    , width     = Just $ Percent 30
    , alignment = Just LeftAlign
    }
 
------------------------------------------------------------------------
-- Startup hook
 
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = setWMName "LG3D"
 
------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.
 
-- Run xmonad with the settings you specify. No need to modify this.
--
main = do 
d <- spawnDzen myLeftBar
spawnToDzen "conky -c ~/.conkyrc" myRightBar
xmonad $ withUrgencyHook NoUrgencyHook $ ewmh $ docks def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        -- numlockMask        = myNumlockMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
 
      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,
 
      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        logHook            = myLogHook d,
        startupHook        = myStartupHook
    }

 
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will 
-- use the defaults defined in xmonad/XMonad/Config.hs
-- 
-- No need to modify this.
--
-- defaults = defaultConfig {
--       -- simple stuff
--         terminal           = myTerminal,
--         focusFollowsMouse  = myFocusFollowsMouse,
--         borderWidth        = myBorderWidth,
--         modMask            = myModMask,
--         -- numlockMask        = myNumlockMask,
--         workspaces         = myWorkspaces,
--         normalBorderColor  = myNormalBorderColor,
--         focusedBorderColor = myFocusedBorderColor,
--  
--       -- key bindings
--         keys               = myKeys,
--         mouseBindings      = myMouseBindings,
--  
--       -- hooks, layouts
--         layoutHook         = myLayout,
--         manageHook         = myManageHook,
--         logHook            = myLogHook d,
--         startupHook        = myStartupHook
--     }
-- 
