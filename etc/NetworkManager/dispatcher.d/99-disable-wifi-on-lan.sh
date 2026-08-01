#!/bin/bash
INTERFACE=$1
ACTION=$2

# Substitua enp8s0 pelo nome correto da sua placa se necessário
LAN_INT="enp8s0"

# Função para checar se o cabo está conectado e com link ativo
check_lan_and_disable_wifi() {
    if ip link show "$LAN_INT" | grep -q "LOWER_UP"; then
        nmcli radio wifi off
    else
        nmcli radio wifi on
    fi
}

# Monitora eventos da interface ou a inicialização do sistema
if [ "$INTERFACE" = "$LAN_INT" ]; then
    case "$ACTION" in
        up)
            nmcli radio wifi off
            ;;
        down)
            nmcli radio wifi on
            ;;
    esac
elif [ "$ACTION" = "hostname" ] || [ "$ACTION" = "up" ]; then
    # Executa a verificação na inicialização do NetworkManager
    check_lan_and_disable_wifi
fi
