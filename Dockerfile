FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies \
    tigervnc-standalone-server tigervnc-common \
    novnc websockify \
    firefox \
    dbus-x11 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Configura senha do VNC (pode mudar depois)
RUN mkdir -p /root/.vnc && \
    echo "password" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Script de inicialização
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 6080

CMD ["/start.sh"]
