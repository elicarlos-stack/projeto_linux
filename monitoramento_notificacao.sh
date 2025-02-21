#!/bin/bash

# Verificar se a pasta que criamos monitoramento.log se não cria em log
if [ ! -f "$LOGFILE" ]; then
    sudo touch "$LOGFILE"
    sudo chmod 666 "$LOGFILE"
fi

LOGFILE="/var/log/monitoramento.log"
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/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" #Substituir pela URL do webhook do Slack 

# Token para obter o IP público da instância AWS
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
PUBLIC_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/public-ipv4)

# Nesta parte verificar se o IP público foi obtido com sucesso
if [ -z "$PUBLIC_IP" ]; then
    echo "$(date): erro ao obter o IP público da instância" >> $LOGFILE
    exit 1
fi

# Definir a URL do site
SITE_URL="http://$PUBLIC_IP"

# Função para enviar notificação para o Slack
send_slack_notification() {
    message="$1"
    payload="{\"text\": \"$message\"}"
    curl -X POST -H "Content-type: application/json" --data "$payload" "$SLACK_WEBHOOK_URL"
}

# Obter o código HTTP da resposta
response=$(curl -o /dev/null -s -w "%{http_code}" -I --connect-timeout 5 "$SITE_URL")

# Verifica se o status é 000 ou diferente de 200
if [ "$response" -eq 000 ] || [ "$response" -ne 200 ]; then
    # Se o status for 000, define uma mensagem especial
    if [ "$response" -eq 000 ]; then
        response_message="Indisponível ou erro na requisição"
    else
        response_message="HTTP status: $response"
    fi

    log_message="$(date -u): $SITE_URL Site está fora do ar ($response_message)"
    
    # Registra no log
    echo "$log_message" >> "$LOGFILE"
    
    # Envia alerta para o Slack
    send_slack_notification "$log_message"
fi