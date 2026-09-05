FROM debian:11-slim

# Instala o ambiente gráfico estável e o Chromium
RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    chromium \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Configura as definições de ecrã virtual estáveis
ENV DISPLAY=:1
ENV RESOLUTION=1280x800x16

# Cria a configuração do Supervisor para iniciar os serviços em paralelo na porta 7860
RUN echo '[supervisord]\nnodaemon=true\n\n[program:xvfb]\ncommand=Xvfb :1 -screen 0 1280x800x16\n\n[program:x11vnc]\ncommand=x11vnc -display :1 -forever -nopw -listen localhost -shared\n\n[program:novnc]\ncommand=/usr/share/novnc/utils/launch.sh --vnc localhost:5900 --listen 7860\n\n[program:chromium]\ncommand=chromium --no-sandbox --disable-gpu --display=:1 --start-maximized https://google.com\nuser=root' > /etc/supervisord.conf

# Expõe a porta que o sistema de visualização do ModelScope lê por defeito
EXPOSE 7860

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
