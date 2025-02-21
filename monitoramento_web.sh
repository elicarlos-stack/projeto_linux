#!/bin/bash

SERVICE="nginx"

#ver se o Nginx está rodando
if ! systemctl is-active --quiet $SERVICE; then
        echo "$(date): Nginx parou! reiniciando..." >> /var/log/monitoramento.log
        systemctl restart $SERVICE

        # verificar novamente se o Nginx foi reiniciado
        if systemctl is-active --quiet $SERVICE; then
                echo "$(date): Nginx reiniciado com sucesso!" >> /var/log/monitoramento.log
        else
                echo "$(date): Falha ao reiniciar o Nginx!" >> /var/log/monitoramento.log  
        fi
fi