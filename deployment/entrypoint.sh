#!/bin/bash

# Display 1 reserved for deployed games
export DISPLAY=:1
Xvfb :1 -screen 0 800x600x24 &

# Display 0 for SKGM
Xvfb :0 -screen 0 800x600x24 &
exec "DISPLAY=:0 $@"