#!/bin/bash
# 1. Abre o app forçando a camada XWayland (essencial para automação)
env OZONE_PLATFORM=x11 youtube-music-desktop-app --ozone-platform=x11 --disable-accelerated-video-decode --disable-features=VaapiVideoDecoder &

# 2. Aguarda a janela abrir completamente
sleep 12

# 3. Procura o ID da janela
WINDOW_ID=$(xdotool search --name "YouTube Music" | head -n 1)

if [ ! -z "$WINDOW_ID" ]; then
    
    xdotool windowminimize "$WINDOW_ID"
    
    # Envia o comando de fechar a janela atual (enviando para a bandeja se o app estiver configurado)
    wmctrl -i -c "$WINDOW_ID"

else
    echo "Não foi possível encontrar a janela."
fi

pactl set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo 100%

sleep 10

# 4 Aumenta o Volume do YouTube Music
pactl set-sink-input-volume $(pactl list short sink-inputs | awk '{print $1}') 120%

sleep 5

google-chrome-stable --password-store=basic https://calendar.google.com/calendar/u/0/r
