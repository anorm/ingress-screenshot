#!/bin/bash

# Firefox settings
FF_PROFILE="ingress_fredrikstad"
FF_PROFILE_DIR="1i9rkt4s.ingress_fredrikstad"
FF_WAIT=200
FF_URL="http://www.ingress.com/intel?ll=59.209271,10.934658&z=15"

# Virtual X Server Settings
XVFB_RES_WIDTH=2560
XVFB_RES_HEIGHT=1600
XVFB_DISPLAY=23

# Interval between screenshots
SCREENSHOT_INTERVAL=5

# Dimensions of screenshot (cropped)
SCREENSHOT_WIDTH=1920
SCREENSHOT_HEIGHT=1080

# Crop offset for screenshot
SCREENSHOT_OFFSET_LEFT=335
SCREENSHOT_OFFSET_TOP=245

echo "Staring XVFB on $XVFB_DISPLAY"
Xvfb :${XVFB_DISPLAY} -screen 0 ${XVFB_RES_WIDTH}x${XVFB_RES_HEIGHT}x24 -noreset -nolisten tcp 2> /dev/null &
XVFB_PID=$!

while true
do
    # Remove parent lock to prevent error message "firefox has been shutdown unexpectly..."
    rm ~/.mozilla/firefox/${FF_PROFILE_DIR}/.parentlock

    echo "Running firefox -P $FF_PROFILE on $XVFB_DISPLAY "
    DISPLAY=:${XVFB_DISPLAY} firefox -P $FF_PROFILE -width $XVFB_RES_WIDTH -height $XVFB_RES_HEIGHT "$FF_URL" > /dev/null &
    FF_PID=$!

    echo "firefox running o PID $FF_PID"

    echo "Waiting $FF_WAIT seconds before screenshot"
    sleep $FF_WAIT;

    echo "Taking screenshot. Please smile!"
    HAM_DATE=`date +"%Y-%m-%d_%H-%M-%S"`
    DISPLAY=:${XVFB_DISPLAY} import -window root -crop ${SCREENSHOT_WIDTH}x${SCREENSHOT_HEIGHT}+${SCREENSHOT_OFFSET_LEFT}+${SCREENSHOT_OFFSET_TOP} "ingr-$HAM_DATE".png

    echo "Killing firefox on PID $FF_PID"
    kill $FF_PID

    echo "Waiting $SCREENSHOT_INTERVAL for next screenshot"
    sleep $SCREENSHOT_INTERVAL

done

echo "Killing XVFB on $XVFB_PID"
kill $XVFB_PID
