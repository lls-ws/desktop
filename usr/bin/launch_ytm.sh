#!/bin/bash
#

# Launch the application in the background
youtube-music-desktop-app &

# Wait briefly for the Electron window to actually render
sleep 3



# Search for the window named 'YouTube Music' and send it to the tray
WINDOW_ID=$(xdotool search --onlyvisible --class "youtube-music-desktop-app" | head -n 1)
if [ ! -z "$WINDOW_ID" ]; then
    xdotool windowminimize "$WINDOW_ID"
fi


#!/bin/bash
# 1. Abre o app forçando a camada XWayland (essencial para automação)
env OZONE_PLATFORM=x11 youtube-music-desktop-app --ozone-platform=x11 &

# 2. Aguarda a janela abrir completamente
sleep 3.5

# 2.1 Aumenta o Volume
pactl set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo 100%

# 3. Procura o ID da janela
WINDOW_ID=$(xdotool search --onlyvisible --name "YouTube Music" | head -n 1)

if [ ! -z "$WINDOW_ID" ]; then
    # Traz a janela para o foco principal
    xdotool windowactivate "$WINDOW_ID"
    sleep 0.5
    # Envia o comando de fechar a janela atual (enviando para a bandeja se o app estiver configurado)
    xdotool key --window "$WINDOW_ID" ctrl+w
else
    echo "Não foi possível encontrar a janela."
fi
