FROM accetto/ubuntu-vnc-xfce-chromium-g3:latest

# Define que o sistema vai rodar na porta 7860 exigida pelo ModelScope
ENV VNC_PORT=5901
ENV NO_VNC_PORT=7860

# Desativa a necessidade de senha para facilitar o seu acesso inicial
ENV VNC_PW=

# Força a resolução leve para carregar rápido no celular
ENV VNC_RESOLUTION=1280x800

# Expõe a porta de visualização web
EXPOSE 7860

# Comando padrão da imagem que já inicia o ambiente gráfico e o navegador automaticamente
CMD [ "/headless/vnc_startup.sh", "--wait" ]
