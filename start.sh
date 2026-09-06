#!/bin/bash

# Inicia o servidor VNC
vncserver :1 -geometry 1280x720 -depth 24

# Porta que o Fly.io exige (usa a variável PORT ou 8080 como padrão)
PORT=${PORT:-8080}

# Inicia o noVNC apontando para a porta correta
websockify --web=/usr/share/novnc/ ${PORT} localhost:5901 &

# Mantém o container rodando
tail -f /dev/null
