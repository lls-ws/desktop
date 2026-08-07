#!/bin/bash

# Aguarda 5 segundos para o ambiente gráfico carregar completamente
sleep 5

while true; do
    # Obtém a hora atual (00 a 23)
    HORA=$(date +%H)

    if [ "$HORA" -ge 21 ] || [ "$HORA" -lt 6 ]; then
        # Período Noturno (21:00 às 06:00): Brilho em 10%
        # Se preferir usar o comando do LXQt, mude para: lxqt-config-brightness -s 10
        sudo brightnessctl set 0%
    else
        # Período Diurno: Brilho em 50%
        # Se preferir usar o comando do LXQt, mude para: lxqt-config-brightness -s 50
        sudo brightnessctl set 30%
    fi

    # Verifica a hora a cada 5 minutos (300 segundos) para atualizar o brilho
    sleep 300
done
