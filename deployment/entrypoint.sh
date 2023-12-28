#!/bin/bash

Xvfb :0 -screen 0 800x600x24 &
exec env DISPLAY=:0 "$@"