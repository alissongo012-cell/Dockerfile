FROM ubuntu:20.04

# Evita perguntas interativas durante a instalação
ENV DEBIAN_FRONTEND=noninteractive

# Instala as ferramentas gráficas, dbus, fontes e o Chromium de forma correta
RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    supervisor \
    chromium-browser \
    dbus-x11 \
    fonts-liberation \
    fonts-freefont-ttf \
    && rm -rf /var/lib/apt/lists/*

# SENHA OBRIGATÓRIA: Exigida pelo painel do ModelScope
ENV VNC_PW=123456
ENV DISPLAY=:1
ENV RESOLUTION=1280x800x16

# Cria a configuração do gerenciador de processos (supervisor)
RUN printf "[supervisord]\nnodaemon=true\n\n" > /etc/supervisord.conf
RUN printf "[program:xvfb]\ncommand=Xvfb :1 -screen 0 1280x800x16\n\n" >> /etc/supervisord.conf
RUN printf "[program:x11vnc]\ncommand=x11vnc -display :1 -forever -passwd 123456 -listen 127.0.0.1 -shared\n\n" >> /etc/supervisord.conf
RUN printf "[program:novnc]\ncommand=websockify --web /usr/share/novnc 7860 127.0.0.1:5900\n\n" >> /etc/supervisord.conf

# FLAGS ANTI-DETEÇÃO: Ajustado o comando para chamar "chromium" ou buscar o binário correto
RUN printf "[program:chromium]\ncommand=chromium --no-sandbox --disable-gpu --display=:1 --start-maximized --disable-blink-features=AutomationControlled --user-agent=\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36\" --window-size=1280,800 https://dropcoins.xyz\n" >> /etc/supervisord.conf

EXPOSE 7860

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
