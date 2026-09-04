FROM debian:11-slim

# Evita perguntas interativas na instalação
ENV DEBIAN_FRONTEND=noninteractive

# Instala todas as ferramentas necessárias no Debian
RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    supervisor \
    chromium \
    && rm -rf /var/lib/apt/lists/*

# SENHA OBRIGATÓRIA: Define a senha que o ModelScope exige
ENV VNC_PW=123456

# Configurações do ecrã virtual
ENV DISPLAY=:1
ENV RESOLUTION=1280x800x16

# Cria o arquivo do supervisor de forma limpa e segura linha por linha
RUN printf "[supervisord]\nnodaemon=true\n\n" > /etc/supervisord.conf
RUN printf "[program:xvfb]\ncommand=Xvfb :1 -screen 0 1280x800x16\n\n" >> /etc/supervisord.conf
RUN printf "[program:x11vnc]\ncommand=x11vnc -display :1 -forever -passwd 123456 -listen 127.0.0.1 -shared\n\n" >> /etc/supervisord.conf
RUN printf "[program:novnc]\ncommand=/usr/share/novnc/utils/launch.sh --vnc 127.0.0.1:5900 --listen 7860\n\n" >> /etc/supervisord.conf
RUN printf "[program:chromium]\ncommand=chromium --no-sandbox --disable-gpu --display=:1 --start-maximized https://google.com\n" >> /etc/supervisord.conf

# Abre a porta do painel
EXPOSE 7860

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
