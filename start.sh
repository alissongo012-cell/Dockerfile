#!/bin/bash

# Inicia o VNC
vncserver :1 -geometry 1280x720 -depth 24

# Inicia o noVNC
websockify --web=/usr/share/novnc/ 6080 localhost:5901 &

# Mantém o container rodando
tail -f /dev/null
