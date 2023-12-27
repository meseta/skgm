#!/bin/bash

# Display 0 reserved for deployed games
Xvfb :0 -screen 0 800x600x24 &

# Display 0 for SKGM
Xvfb :1 -screen 0 800x600x24 &
exec env DISPLAY=:1 "$@"