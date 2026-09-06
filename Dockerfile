FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

# Instala o ambiente gráfico + VNC + noVNC + Firefox
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    firefox \
    dbus-x11 \
    net-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configura a senha do VNC (mude se quiser)
ARG VNC_PASSWORD=password
RUN mkdir -p /root/.vnc && \
    echo "$VNC_PASSWORD" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Copia e configura o script de inicialização
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Porta que o Fly.io vai usar
EXPOSE 8080

CMD ["/start.sh"]
