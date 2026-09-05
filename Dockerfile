FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies \
    # Adicionado net-tools para ajudar o script a gerenciar conexões internas
    tigervnc-standalone-server tigervnc-common net-tools \
    novnc websockify \
    firefox \
    dbus-x11 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Configura senha do VNC de forma dinâmica (usa 'password' se nenhuma for enviada)
ARG VNC_PASSWORD=password
RUN mkdir -p /root/.vnc && \
    echo "$VNC_PASSWORD" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# Script de inicialização
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Removeu a porta fixa EXPOSE 6080 para o Back4app gerenciar dinamicamente

CMD ["/start.sh"]
