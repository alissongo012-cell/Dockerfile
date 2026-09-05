#!/bin/bash

# Inicia o VNC interno (usa a senha /root/.vnc/passwd criada no Dockerfile)
vncserver :1 -geometry 1280x720 -depth 24

# Pega a porta automática do Back4app (se não existir, usa a 8080 padrão deles)
PORTA_WEB=${PORT:-8080}

# Inicializa o noVNC apontando para o arquivo de senha (tranca o acesso externo)
websockify --web=/usr/share/novnc/ "$PORTA_WEB" localhost:5901 --vnc /root/.vnc/passwd &

# Mantém o container rodando
tail -f /dev/null
