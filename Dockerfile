# Usa uma imagem estável que já vem com Chromium e VNC prontos de fábrica
FROM selenium/standalone-chrome:120.0-20231129

USER root

# Instala apenas o noVNC de forma local e segura para rodar na porta 7860
RUN apt-get update && apt-get install -y novnc websockify supervisor && rm -rf /var/lib/apt/lists/*

# SENHA OBRIGATÓRIA: Exigida pelo painel do ModelScope
ENV VNC_PW=123456
ENV DISPLAY=:99
ENV RESOLUTION=1280x800x16

# Configura o gerenciador de processos de forma compatível
RUN printf "[supervisord]\nnodaemon=true\n\n" > /etc/supervisord.conf
RUN printf "[program:novnc]\ncommand=websockify --web /usr/share/novnc 7860 127.0.0.1:4444\n\n" >> /etc/supervisord.conf

# FLAGS ANTI-DETEÇÃO: Abre o Chromium da imagem com as camuflagens necessárias no Dropcoins
RUN printf "[program:chromium]\ncommand=google-chrome --no-sandbox --disable-gpu --start-maximized --disable-blink-features=AutomationControlled --user-agent=\"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36\" --window-size=1280,800 https://dropcoins.xyz\n" >> /etc/supervisord.conf

EXPOSE 7860

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
