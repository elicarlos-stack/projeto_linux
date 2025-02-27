# 🙋‍♂️ Olá, meu nome é Elicarlos, Bem-vindo ao Meu Perfil no GitHub! 

## Sobre Mim
Sou estudante de Segurança da Informação, e atualmente estou desenvolvendo habilidades em Linux, AWS e automação de processos na Compass.Uol.

## Projetos
- Configuração de Servidor Web Monitorado com Automação de Processos com Scripts Bash.

## Contato
- <a href="https://www.linkedin.com/in/elicarlos-amorim"><img src="https://github.com/user-attachments/assets/f29b36c0-ca83-4864-8e95-d8d27506b274" width="20"> LinkedIn</a>
- <a href="https://github.com/elicarlos-stack"><img src="https://github.com/user-attachments/assets/e2064dea-f32c-4782-a75d-2273f010e24f" width="20"> GitHub</a>

<hr>

<div align="center">
 <img src="https://github.com/user-attachments/assets/eeb8aec4-21cc-454a-9c00-81d2b52d1ded" width="500px" hight="400">

 <img src="https://github.com/user-attachments/assets/5f1ff0b7-4dce-4a0b-b0f9-11de88c85c44" width="500px" hight="400">
</div>

# <h1 align="center">Configuração de Servidor Web com Monitoramento</h1>

<p align="center"><img src="http://img.shields.io/static/v1?label=STATUS&message=EM%20DESENVOLVIMENTO&color=GREEN&style=for-the-badge"/></p>


## :pushpin: Descrição do projeto:
<div style="text-align: justify">
Este projeto tem como objetivo desenvolver e testar habilidades em Linux, AWS e automação de processos por meio da configuração de um ambiente de servidor web monitorado. você irá utilizar os serviços da AWS para hospedar e gerenciar servidores em uma instância EC2. instalar e configurar um servidor web utilizando Linux. Também realizara a implementação de Serviços de Monitoramento utilizando técnicas para garantir a disponibilidade e o desempenho do servidor.</div>

## :hammer: Ferramentas e Tecnologias Utilizadas:
- **Linux (Debian12)**
- **AWS Cloud**
- **Vscode**
- **Slack**
- **Scripts Bash**

# Índice

1. [Etapa 1: Configuração do Ambiente](#etapa-1-configuração-do-ambiente)
2. [Configuração do Servidor](##etapa-2-configuração-do-servidor)
3. [Monitoramento e Notificações](##etapa-3-monitoramento-e-notificações)
4. [Automação e Testes](##etapa-4-automação-e-testes)


# Etapa 1: Configuração do Ambiente :hammer_and_wrench:
Antes de criarmos a nossa Instância EC2 primeiramente vamos criar uma VPC na AWS com 2 subnets públicas e 2 subnets privadas. A VPC é um serviço da AWS que permite criar uma rede virtual isolada dentro da infraestrutura da AWS, para isto com o console aberto da Amazon AWS localize na barra de pesquisar por VPC para criar a VPC logo após criaremos as subnets, depois clique em create VPC ou selecione Your VPCs (suas VPCs) e criar VPC.


<img src="img/img_vpc1.png" alt="Imagem inicial EC2" width="800px" hight="600px" />


Em VPC setting você pode escolher por criar através do VPC only ou VPC and more (Este modo permite criar a VPC junto com recursos adicionais necessários, como sub-redes, tabelas de rotas, gateways da Internet e gateways NAT). Neste exemplo escolheremos VPC only para criar de forma manual, após escolher informe um nome para vpc ex: "dev-web" e o bloco IPV4 CIDR para a VPC neste exemplo usei 172.16.0.0/20. as outras opções pode deixar como default e finalize clicando em criar VPC (Create VPC).

<img src="img/img_vpc2.png" alt="" width="800px" hight="600px" />

<div>Agora criaremos 2 subnets privadas e 2 subnets públicas conforme a imagem abaixo. Para isso, na console da AWS, vá para VPC e clique em Subnets -> Create Subnet. Selecione a VPC criada anteriormente com o nome "dev-web". Crie cada uma das subnets com os seguintes nomes: "dev-web-public01", "dev-web-public02", "dev-web-private01" e "dev-web-private02". Selecione a zona de disponibilidade para cada subnet, preferencialmente uma em cada zona. Informe o bloco CIDR da subnet IPv4. para criar outras subnets basta clicar adicionar nova subnet (em Add new subnet).</div>

- dev-web-public01 = 172.16.0.0/24
  
- dev-web-public02 = 172.16.1.0/24
  
- dev-web-private01 = 172.16.8.0/24
  
- dev-web-private02 = 172.16.9.0/24

> [!NOTE]
> As tags são opcionais, mas recomenda-se atribuir nomes a elas, pois ajudam a categorizar e organizar seus recursos na AWS.

<div>
<img src="img/img_privatesub1.pngg" alt="" />

<img src="img/img_privatesub2.png" alt="" />

<img src="img/img_privatesub3.png" alt="" />
</div>

Na imagem abaixo, você pode ver as subnets que foram criadas. Elas são duas subnets privadas e duas subnets públicas, nomeadas como "dev-web-public01", "dev-web-public02", "dev-web-private01" e "dev-web-private02", cada uma associada a uma zona de disponibilidade diferente.<br>

<img src="img/img_privatesub4.png" alt="" />

Quando uma VPC é criada, uma tabela de roteamento já vem configurada por padrão. No entanto, para que nossas subnets funcionem como subnets públicas, criaremos uma nova tabela de roteamento específica para as subnets públicas.

primeiramente criaremos um internet gateway. ir em internet gateway, informe um nome para seu internet gateway por exemplo "igw01" e clique em create internet gateway. apos a criação teremos que associar a uma vpc.

<img src="img/igw1.png" alt="" />

para associar selecione o internet gateway criado -> actions -> attach to VPC -> selecione a VPC e assossiar.

<img src="img/igw2.png" alt="" />

Agora, vamos criar a tabela de roteamento. Acesse a seção "Route Tables" na console da AWS e clique em "Create Route Table". Informe um nome, por exemplo, "rtb_public", selecione a VPC "dev-web" e clique em "Create Route Table".

<img src="img/rtb_public.png" alt="" />

Após a criação da tabela de roteamento, com a tabela de roteamento selecionada, vá para a aba "Subnet Associations". Clique em "Edit Subnet Associations", selecione as subnets públicas criadas e salve as alterações.

<img src="img/associate_subnet.png" alt="" />

Agora em Routes, vamos editar a tabela de roteamento (Edit Routes). Clique em Edit e adicione uma nova rota. Para isso, clique em Add Route, insira 0.0.0.0/0 no campo Destination e selecione o Internet Gateway criado anteriormente no campo Target. Salve as mudanças.

<img src="img/associate_private1.png" alt="" />

Agora para criar o NAT gateway para a subnet privada ter acesso a internet. para isto ir em NAT gateway informe um nome, selecione uma subnet public, aloque um Elastic Ip allocation ID. 
logo apos criaremos a tabela de roteamento para o NET gateway e assossiar as subnets privadas.

<img src="img/rtb_private.png" alt="" />

Agora assossiar a subnet privadas.

<img src="img/associate_private.png" alt="" />

Agora iremos editar em Routes para que elas tenham acesso a internet. ir em "edite routes" adicionar a rota para NAT gateway.

<img src="img/associate_private1.png" alt="" />

Vamos criar um grupo de segurança(Security group), nosso grupo de segurança irá atua como firewall virtual para as instâncias do EC2 para controlar o tráfego de entrada e de saída. 
Para criar na console da AWS pesquise por EC2 ou digite na barra de pesquisa, procure por "Network & Security na lateral esquerda depois "criar security group" (Create security group), 
Informe um nome, descrição é opcional e clique em criar.
<br>
<img src="img/securityGP.png" alt=""><br>
<img src="img/securityGP1.png" alt=""><br>
<img src="img/securityGP2.png" alt=""><br>


## :heavy_check_mark: Criar uma instancia EC2 :computer:

Para criar uma instância EC2 na AWS, acesse a console da AWS e pesquise por EC2 ou vá até "Instances". Em seguida, procure por "Launch instance".

<img src="img/ec2_instance1.png" alt="" />

Nesta etapa, adicione as Tags, caso necessário. Escolha a imagem AMI; neste projeto, usaremos o Debian 12. No tipo da instância, deixe como t2.micro.Crie uma key pair para acesso remoto via SSH. Selecione a VPC "dev-web" criada anteriormente e a subnet pública. Em Security Group, crie um caso não tenha. Para criar, vá em EC2 Security Group, clique em Create Security Group, informe um nome; por exemplo, "MyDevWeb". A descrição pode ser adicionada para facilitar a identificação, se necessário. Selecione a VPC "dev-web" e clique em Create Security Group. Deixe as outras opções como padrão por enquanto e clique em "Create Instance" (Launch Instance).

<img src="img/ec2_instance2.png" alt="" />

Em "Key pair" caso nao tenha criado uma chave clique para criar, usaremos esta chave para conectarmos a instancia via SSH. Escolha um nome para achave deixe o tipo criptografia como padrão (RSA) e formato do arquivo como <b>.pem</b> conforme a imagem abaixo e clique em criar chave (create key pair).
<img src="img/chave.png" alt="" />

Verifique se as informações estão corretas e clique em criar instância (Launch instance). 

<img src="img/ec2_instance3.png" alt="" />

<div>Agora para associar um Security Group que permita tráfego HTTP (porta 80) e SSH na (porta 22) 
edite o security group permitindo regras de entrada de SSH e HTTP. 
Em security group selecione o security group criado "MyDevWeb" na aba Inbound rules 
clique em Edite inbound rules. adicione o type como HTTP, source selecione MyIP, 
adicione novamente para type SSH source MyIP e Salve(save rules).</div>

<br>

❗ (Obs: como o IP da instância está publico ao selecionar o Source como MyIP pode estar diferente da imagem mostrada aqui).

<br>

<img src="img/securitygroupssh.png" alt="" />

Apos isto realize o teste acessando o servidor via SSH. Abra um cliente SSH como o PUTTY ou o VSCODE utilizando o terminal bash instalado. neste exemplo usei o Vscode. Localize a pasta com seu arquivo de chave privada **.pem**. A chave é usada para iniciar esta instância. Execute este comando, se necessário, para garantir que sua chave não seja visível publicamente.
```chmod 400 "chave01.pem"``` Na console da AWS selecione sua instância criada e com botão direito va em conect para conectar-se a instância. 

<img src="img/selecioneInstance.png" alt="">

Agora selecione a aba SSH e copie ou digite o comando para conetar a instancia via SSH no terminal. Conecte-se à sua instância usando seu IP público (Public IPv4 address).

<img src="img/acessossh2.png" alt="" />

Exemplo:

```
ssh -i "chave.pem" admin@"IP_Public_IPv4_da_instância"
```
na tela do terminal confirme com "yes" e acesse a maquina.

<img src="img/conectInstance.png" alt="">

<img src="img/acessossh.png" alt="">

<hr>

Na próxima etapa iremos realizar configurações e instalar o servidor de páginas web Nginx. O Nginx é um servidor web de código aberto e de alta performance que também funciona como proxy reverso e balanceador de carga.

## Etapa 2: Configuração do Servidor :computer:

### 1 - Instalar o Servidor Nginx

Agora que estamos acessando terminal da nossa instancia AWS vamos atualizar os pacotes para depois instalar o servidor NGINX, para isso digite o comando conforme imagem abaixo:
```
sudo apt update
```

<img src="img/nginx1.png" alt="">

Outra etapa é instalar as dependências necessárias e transferir dados para o servidor. Essas dependências incluem a chave GPG, ca-certificates e lsb-release, que fornecem informações sobre a distribuição Linux instalada. Para fazer isso, use o comando:</br>

```
sudo apt install -y curl gnupg2 ca-certificates lsb-release
```

Logo após execute o comando para adicionar a chave de assinatura e configurar o repositorio do Nginx, observe que ao adicionar criamos e salvamos o arquivo em "nginx.list". comando para baixar a assinatura: 

```
curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
```
 
depois execute: **echo "deb http://nginx.org/packages/debian $(lsb_release -cs) nginx" | sudo tee /etc/apt/sources.list.d/nginx.list** para que adicione o repositório oficial do Nginx ao arquivo de fontes de pacotes.

```
echo "deb http://nginx.org/packages/debian $(lsb_release -cs) nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
```

Atualize a lista de pacotes com **sudo apt update**.
```
sudo apt update
```

Exemplo demostrado na imagem:

<img src="img/nginx2.png" alt="">

Execute **sudo apt install nginx -y** para instalar o servidor. o **-y** irá confirmar automaticamente sem precisar perguntar se deseja instalar pacotes. 

```
sudo apt install nginx -y
```

<img src="img/nginx-install.png" alt="">

Consulte se o nginx foi instalado pesquisando sobre a versão com **sudo nginx -v**. ative o Nginx para iniciar:

```
sudo systemctl enable nginx
```

<img src="img/nginx3.png" alt="">
<br>

Verifique no navegador usando o Chrome, Edge ou outro navegador de preferencia e digitando o IP publico da Instância para vizualize a pagina padrão do Nginx ao carregar site.<br>
<img src="img/pg_nginx.png" alt="">

### 2 - Criar uma pagina HTML simples.

Agora, com o Nginx instalado, vamos criar nossa página HTML simples. Para isso, navegue até o diretório que serve a página HTML do nosso servidor com o comando **cd /usr/share/nginx/html**. Verifique o arquivo "index.html". Se quiser, salve o arquivo original com o nome "index.html.original" e crie um novo "index.html" com o comando sudo nano index.html. Digite ou cole o seu código HTML e depois salve o arquivo. Deixarei um exemplo de pagina html para teste na pasta "Site".

```
cd /usr/share/nginx/html
sudo nano index.html
```

<img src="img/criando_pg_html.png" alt="">

podemos usar o comando **cd /usr/share/nginx/html | cat index.html** para verificar se o conteudo foi criado.
```
cd /usr/share/nginx/html | cat index.html
```

Ative o nginx com **sudo systemctl enable nginx --now** depois verifique se o nginx está ativo e servindo a pagina corretamente.
```
sudo systemctl enable nginx --now
```

<img src="img/ativando-nginx.png" alt="">

Abra um navegador de preferência, pode ser Firefox, Chrome, Edge e digite o **http://"ip_da_instancia_publica"**

<img src="img/pg-html-ok.png" alt="">

<br>

Caso o servidor sofra uma parada repentina, podemos criar um serviço systemd para garantir que o Nginx reinicie automaticamente. Antes de criarmos um arquivo de serviço para garantir que o Nginx seja reiniciado automaticamente, vamos criar um arquivo que verifica se o Nginx está rodando. Para isso, navegue até o diretório **/bin** para criar o arquivo chamado "monitoramento_web.sh". Digite o comando "cd" para ir até o diretório, exemplo: **cd /usr/local/bin**. Em seguida, utilize o comando **sudo nano monitoramento_web.sh** para criar o arquivo de monitoramento.

```
cd /usr/local/bin
sudo nano monitoramento_web.sh
```

<img src="img/monitoramento_web1.png" alt="">

script de shell Bash que verifica se o Nginx está rodando:
```
#!/bin/bash

SERVICE="nginx"

# Verificar se o Nginx está em execução.
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
```

altere as permissoes de execução do script digitando o comando **sudo chmod +x /usr/local/bin/monitoramento_web.sh**, o "chmod +x" permite alterar para ter permissões de execução.
```
sudo chmod +x /usr/local/bin/monitoramento_web.sh
```
Agora criaremos um serviço systemd para garantir que o "Nginx" reinicie automaticamente. Para isso, vá até o diretório "/etc/systemd/system" com o comando **cd /etc/systemd/system**. Crie um arquivo com o nome "servico_monitoramento_nginx.service" digitando **sudo nano servico_monitoramento_nginx.service**. Em seguida, digite o código abaixo conforme a imagem:

```
cd /etc/systemd/system
sudo nano servico_monitoramento_nginx.service
```

<img src="img/servico_monitoramento_nginx1.png" alt="">

Esta configuração garante que o script monitoramento_web.sh será executado para verificar e reiniciar o Nginx automaticamente:
```
[Unit]
Description=Monitoramento do Nginx
After=network.target

[Service]
ExecStart=/usr/local/bin/monitoramento_web.sh
Type=simple
User=root
```

## Etapa 3: Monitoramento e Notificações Tarefas :mag_right:

Ter um site e não monitorar sua disponibilidade pode ser arriscado, pois você pode perder visitantes 
ao seu site e possíveis clientes sem perceber problemas em seu Servidor. Monitorar é essencial para 
garantir a estabilidade e resolver falhas rapidamente. Então vamos criar um script que verifique a 
disponibilidade do site.

Antes disso vamos criar uma conta no Slack que é uma plataforma de comunicação e colaboração projetada para equipes e empresas. para criar uma conta no Slack e instalar a API Webhook acesse o site do Slack clique em Começar para criar uma conta. informe um e-mail e será enviado um codigo no seu email, informe o codigo. ao acessar o site voçê pode criar um workspace.

<img src="img/slack1.png" alt=""></br>

Na proxima tela informe o nome da empresa ou equipe. Agora para instalar a API Webhooke acesse o site https://api.slack.com/apps . depois habilite Incoming Webhooks em features, 
e ative a opção Incoming Webhooks.

<img src="img/slack2.png" alt=""></br>

Adicione um novo Webhook ao workspace clique em "Add New Webhook to Workspace" e escolha o canal onde as mensagens serão postadas. No nosso exemplo crie um Channel com nome de "projetolinux". Copie a URL do Webhook para informar no script a variável "SLACK_WEBHOOK_URL". o webhook do Slack permite que o script envie notificações para um canal específico no Slack. Vamos criar também um log para armazenar logs das verificações de disponibilidade do site. para isto crie em **cd /var/log** o arquivo **monitoramento.log** execute o comando sudo com o <b>touch</b>, o touch irá criar um arquivo em branco. depois execute o comando abaixo para alterar permissões de leitura. 

```
sudo chmod 644 /var/log/monitoramento.log
```   

<img src="img/monitoramento_log1.png" alt="">
</br>

execute o comando para mudar a propriedade de um arquivo ou diretório para o usuário atual:

```
sudo chown $USER:$USER /var/log/monitoramento.log
```
<br>

<img src="img/monitoramento_log2.png" alt="">

</br>

Para confirmar se o site responde corretamente a uma requisição HTTP podemos usar o comando no terminal Debian na AWS, digite o comando curl como exemplo **curl -I http://"seu_ip"**, o comando "curl" é utilizado para obter o cabeçalho se combinado com a opção **-I** faz com que apenas seja mostrado o cabeçalho da resposta HTTP.

Para realizar apenas um teste temos que alterar as regras de saida em Outbound rules para permitir que façamos o teste afim de verificar se o site responde coretamente a uma requisição. então para isto devemos ir na console da AWS -> Security Groups selecionar nosso security group criado com o nome de "MyDevWeb", na aba de Outbound rules clique em editar outbound rules -> add role -> Type selecione "All trafique" -> Destination "My IP" e salve a regra.<br>

<img src="img/outbound.png" alt="">
<br>
<img src="img/outbound3.png" alt="">
<br>

De volta no terminal digite o comando  **curl -I http://"seu_ip"** mencionado acima e verifique se a consulta retorna "HTTP/1.1 200 OK"
conforme a imagem abaixo. 

<img src="img/outbound2.png" alt="">

### :page_with_curl: crie um script em Bash para monitorar a disponibilidade do site:

Agora vamos criar um script para monitorar e enviar notificações para o serviço Slack se detectar indisponibilidade. navegue ate o diretorio **/usr/local/bin** onde são armazenados os executáveis de programas. digite **sudo nano monitoramento_notificacao.sh** para criar o Script de envio e notificação. 
digite o script fornecido conforme a imagem abaixo e salve o arquivo:

```
sudo nano monitoramento_notificacao.sh
```

<img src="img/script-monitor.png" alt=""> 
<br>

script para monitorar e enviar notificações para o serviço Slack se detectar indisponibilidade:

```
#!/bin/bash

# Verificar se a pasta que criamos monitoramento.log se não criar em log
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
```

<img src="img/script-monitor.png" alt="">

Após criar e verificar o script salve o arquivo e execute o comando **sudo chmod +x /usr/local/bin/monitoramento_notificacao.sh** 
para tornar o script executavel.

```
sudo chmod +x /usr/local/bin/monitoramento_notificacao.sh
```

Agora vamos criar uma tarefa com o "Cron" para executar o script a cada minuto, para isto execute o comando: **sudo contrab -e** para editar as tarefas. por padrão o Cron não vem instalado em distribuições linux para instalar execute o comando **sudo apt install cron -y**. 

```
sudo contrab -e
```

```
sudo apt install cron -y
```
<img src="img/cron1.png" alt="">
<br>

Após a instalação, edite o "cron" com **crontab -e**. Isso abrirá a tela de seleção do editor; escolha um. Neste exemplo, escolhi o "nano" digitando 1. No editor, adicione a seguinte linha no final do arquivo:

```
* * * * * /usr/local/bin/monitoramento_web.sh
```    
Essa linha é representada por asteriscos que, na ordem, correspondem ao minuto, hora, dia do mês, mês e dia da semana. Juntos, significam que o script será executado a cada minuto, seguido do caminho do script criado "monitoramento_web.sh". Salve o arquivo. Para visualizar se o arquivo foi adicionado, execute **crontab -l**.<br>


<img src="img/crontab.png" alt="">

Execute o comando para iniciar o "Cron".
```
sudo service cron start
```

No diretorio systemd/system também criaremos um "timer" para executar o serviço a cada 1 minuto e garantir que o Script de serviço "servico_monitoramento_nginx.service" 
do Nginx reinicie automaticamente para executar o serviço a cada 1 minuto. Va até o diretorio **cd /etc/systemd/system** e crie o arquivo "monitoramento_nginx.timer" com **sudo monitoramento_nginx.timer**. conforme a imagem abaixo:


No diretório /etc/systemd/system, também criaremos um "timer" para executar o serviço a cada 1 minuto e garantir que o script de serviço "servico_monitoramento_nginx.service" reinicie automaticamente o Nginx. Para isso, vá até o diretório /etc/systemd/system com o comando **cd /etc/systemd/system** e crie o arquivo "monitoramento_nginx.timer" com **sudo nano monitoramento_nginx.timer**. Em seguida, digite o código abaixo conforme a imagem:

```
cd /etc/systemd/system
sudo nano monitoramento_nginx.timer
```

<img src="img/monitoramento_nginx_timer.png" alt="">
<br>

Script Bash que monitora o Nginx a cada 1 minuto:

```
[Unit]
Description=Executar o monitoramento do Nginx a cada 1 minuto

[Timer]
OnBootSec=1min
OnUnitActiveSec=1min
Unit=servico_monitoramento_nginx.service

[Install]
WantedBy=timers.target
```

logo após a criação recarregue as configurações do systemd com.

```
sudo systemctl daemon-reload**
```

também habilite o timer para iniciar automaticamente com o sistema
```
sudo systemctl enable monitoramento_nginx.timer
```

Agora digite o comando para iniciar o timer imediatamente com

```
sudo systemctl start monitoramento_nginx.timer**
```

## Etapa 4 - Automação e Testes: :robot:

Para testar a implementação e verificar se está funcional, vamos checar se o site está acessível via navegador. Copie o "Endereço IP Público IPv4" da nossa instância criada na AWS. Para encontrar o IP, vá em EC2, instâncias, selecione a instância criada e, na aba "Detalhes" (Details), procure pelo IP público IPv4. Copie e cole no navegador e verifique se o site está acessível. No nosso exemplo, o site é mostrado conforme a imagem abaixo, confirmando o funcionamento do Nginx em servir a página do site.
<br>

<img src="img/site.png" alt="">

Agora vamos fazer testes para verificar se ao parar o Nginx o nosso script detecta e envia alertas corretamente. para isto vamos chegar o status do Nginx digitanto **sudo systemctl status nginx** 

```
sudo systemctl status nginx
```
Imagem da verificação do Status do Nginx:
<img src="img/teste1.png" alt="">


Pare o Nginx para testar:
Agora pare o servidor com **systemctl stop nginx**. Espere 1 minuto e veja se ele foi reiniciado automaticamente:

```
sudo systemctl stop nginx
```

<img src="img/teste2.png" alt="">

Perceba que, ao parar o Nginx e checar o status, a mensagem "Active: inactive" indica que ele está inativo. Nosso servidor parou. Após 1 minuto, que foi o tempo definido para reiniciar no nosso script, se o script estiver funcional, ao digitar o comando de status novamente, ele deverá estar "ativo" e servindo a página (site) corretamente.

<img src="img/teste3.png" alt="">


### Verificar o Arquivo de Log:

Para validar, verifique se o arquivo de log está sendo criado e atualizado corretamente. Podemos analisar a pasta criada para armazenamento dos logs. Navegue pelo diretório onde são armazenados os logs com o comando **cd /var/log** e inspecione o arquivo "monitoramento.log" com o comando "cat" para mostrar o conteúdo do arquivo. Observe que, na imagem capturada dos nossos logs, o Nginx parou e, logo após, foi reiniciado, comprovando o funcionamento do nosso script.

Se tudo estiver funcionando, você verá registros indicando que o Nginx foi reiniciado.

```
cat /var/log/monitoramento.log
```
<img src="img/teste3.1.png" alt="">


Enquanto aguardamos o reinicio automatico do Servidor podemos analizar se o "Timers" criado está funcional e monitorando a cada 1 minuto com:
```
sudo systemctl list-timers --all
```
:eyes: Você deve ver nginx_monitor.timer na lista, com a próxima execução marcada para o próximo minuto. o horario pode estar difernete dos testes. mas o objetivo aqui é mostrar o funcionamento do monitoramento a cada 1 minuto pelo arquivo "monitoramento_nginx.timer";
<img src="img/timers.png" alt="">
<br>

Apos o periodo de 1 minuto execute novamente o comando para ver o Status como "active".

<img src="img/teste4.png" alt="">

### Verificar Notificações no Slack:

Abra o canal do Slack onde você configurou o webhook e verifique se recebeu uma notificação indicando o status do site. Observe que uma notificação foi enviada informando sobre o "Site está fora do ar", conforme a mensagem configurada para ser enviada pelo servidor quando ele sofrer uma parada. Isso confirma que as configurações estão funcionais e notificando corretamente.

<img src="img/teste5.png" alt="">

Em seguida, abra o site no navegador e verifique se consegue acessá-lo normalmente. Conforme mostrado na imagem abaixo, o site está acessível.

<img src="img/teste6.png" alt="">

### Verificar e Testar Executando o Script Manualmente:
Você também pode realizar o teste manual e verificar se ele responde enviando uma notificação ao Slack. Execute o script manualmente para verificar se ele está funcionando e enviando notificações:

```
sudo ./monitoramento_web.sh
```


## Desafio Bônus:
Para quem deseja se aprofundar mais:

### Automação com User Data na (AWS):
Podemos configurar a EC2 para já iniciar com Nginx, HTML e script de monitoramento via "User Data".
Basta organizar o arquivo da seguinte maneira e adicioná-lo na hora de criar uma instância. Por exemplo: em EC2, vá em "Instances" e clique em "Launch Instance" (criar instância), conforme ensinado no início do projeto sobre como criar uma instância na EC2. Depois de ter colocado as especificações, em "Advanced details" (detalhes avançados), expanda a flag e, no final, haverá um campo de "User data - optional". 

<img src="img/user_data1.png" alt="">

Copie o arquivo abaixo e cole no campo. Depois, clique em "Launch instance" (criar instância). Pronto, ao executar a instância, ela será carregada com Nginx, HTML e o script de monitoramento. Também deixarei o arquivo disponível nas pastas para consulta.
<br>

<img src="img/user_data2.png" alt="">


Script para inserção no "user data":
```
#!/bin/bash
# Projeto Linux
# Configuracao do Servidor Web

# Atualizar a lista de pacotes e instalar dependências necessárias
sudo apt update 
sudo apt install -y curl gnupg2 ca-certificates lsb-release

# Adicionar a chave de assinatura GPG e configura o repositório do Nginx
curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -
echo "deb http://nginx.org/packages/debian $(lsb_release -cs) nginx" | sudo tee /etc/apt/sources.list.d/nginx.list

# Atualizar a lista de pacotes e instalar o Nginx
sudo apt update && sudo apt install -y nginx

# Criar pagina html e salvar em index.html
sudo sh -c cat << 'EOF' > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8">
        <title>Projeto Linux AWS da CompassUOL</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="icon" href="https://compass.uol/content/aircompanycompass/en/h…t/header_copy/menuImg/1737576379917/menu-icon.png" type="image/png">
        <style>
            body {
                background-color: #000000;
                color: white;
                font-family: Arial, Helvetica, sans-serif;
                margin: 0;
                padding: 0;
            }

            #conteudo {
                width: 80%;
                margin: 0 auto;
                padding: 20px;
                text-align: justify;
            }

            header {
                background-color: #333;
                padding: 10px 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            nav ul {
                list-style: none;
                margin: 0;
                padding: 0;
                display: flex;
            }

            nav ul li {
                margin: 0 15px;
            }

            nav a {
                color: #E7E5DE;
                text-decoration: none;
                font-weight: bold;
            }

            nav a:hover {
                text-decoration: underline;
                color: #FFBF00;
            }

            .container {
                padding: 20px;
            }

            h1 {
                color: yellow; /* Amarelo para os títulos */
            }

            h2, h3, h4{
                color: goldenrod;
            }

            p {
                color: #FFFFFF; /* Branco para os parágrafos */
            }

            a {
                color: #1E90FF; /* Azul para os links */
            }

            footer {
                background-color: #111116;
                padding: 20px;
                text-align: center;
            }

            .footer-images {
                display: flex;
                justify-content: center;
                gap: 5px; /* Espaço entre as imagens */
            }

            .footer-images img {
                width: 20px; /* Diminui o tamanho da largura */
                max-width: 2%; /* Ajuste conforme necessário */
            }

            @media (max-width: 768px) {
                header {
                    flex-direction: column;
                }   
                nav ul {
                    flex-direction: column;
                }
                nav ul li {
                    margin: 5px 0;
                }
            }
        </style>
    </head>
    <body>
        <header>
            <h1 style="display: flex; align-items: center; justify-content: center;">
                <img src="https://upload.wikimedia.org/wikipedia/commons/f/f3/LogoCompasso-positivo.png" alt="Logo" style="max-height: 50px; margin-right: 10px;">
            </h1>
            <nav>
                <ul>
                    <li><a href="#home">Home</a></li>
                    <li><a href="#ferramentas">Ferramentas</a></li>
                    <li><a href="#contato">Projetos</a></li>
                </ul>
            </nav>
        </header>
    <div id="conteudo">
        <div class="container" id="home">
            <h1>Bem-vindo ao projeto Linux e AWS com automação de processos.</h1>
            
            <p>Serviços de nuvem da AWS (Amazon Web Services).</p>
            <p>Sistema operacional utilizado: Linux (Debian 12).</p>
            <p>Outras plataformas utilizadas: Slack</p>

        </div>

        <div class="container" id="ferramentas">
            <h2>Configuração de Servidor Web com Monitoramento</h2>
            <h3>Objetivo</h3>
            <p>O objetivo deste projeto é desenvolver e testar habilidades práticas em Linux, AWS e automação de processos por meio da configuração de um ambiente de servidor web monitorado. A proposta é criar um servidor web robusto, seguro e confiável, além de implementar um sistema de monitoramento que garanta a disponibilidade do site e a rápida identificação de falhas.</p>
            
            <h3>Descrição do Projeto</h3>
            <p>O projeto envolve a configuração de um servidor web utilizando uma instância EC2 da AWS, implementação de um serviço de monitoramento contínuo e automação de tarefas para garantir a eficiência e eficácia do servidor. Seguindo as melhores práticas, o projeto aborda desde a instalação e configuração do servidor web até a criação de scripts de monitoramento e a integração com ferramentas de notificação.</p>
            
            <h3>Passos do Projeto</h3>
            <h4>Criação da Instância AWS EC2:</h4>
            <p>Provisionar uma instância EC2 na AWS.</p>
            <p>Configurar as regras de segurança para permitir o tráfego HTTP e SSH.</p>

            <h4>Instalação do Servidor Web:</h4>
            <p>Instalar e configurar o servidor web (como Nginx ou Apache) na instância EC2.</p>
            <p>Configurar o servidor para servir uma página web simples.</p>

            <h4>Automação com Scripts de Bash:</h4>
            <p>Criar scripts Bash para automação de tarefas, como backup de arquivos e atualizações do sistema.</p>
            <p>Configurar o cron para executar tarefas automatizadas periodicamente.</p>

            <h4>Implementação do Monitoramento:</h4>
            <p>Criar scripts de monitoramento em Bash para verificar a disponibilidade do site.</p>
            <p>Utilizar curl para checar o status HTTP do site e registrar logs.</p>
            <p>Enviar notificações de falhas via webhook do Slack.</p>

            <h4>Integração com AWS CloudWatch:</h4>
            <p>Enviar métricas personalizadas para o CloudWatch utilizando AWS CLI.</p>
            <p>Configurar alarmes no CloudWatch para monitorar a disponibilidade do site e enviar notificações em caso de falhas.</p>

            <h4>Documentação e Testes:</h4>
            <p>Documentar todos os passos e configurações realizadas.</p>
            <p>Realizar testes para garantir que o servidor e o sistema de monitoramento funcionem corretamente.</p>
        </div>

        <div class="container">
            <h2>Ferramentas Utilizadas</h2>
            <p>AWS EC2: Para provisionamento e gerenciamento da instância do servidor.</p>
            <p>Nginx: Servidor web para hospedar a página web.</p>
            <p>Bash: Para automação e criação de scripts de monitoramento.</p>
            <p>AWS CLI: Para integração e envio de métricas ao CloudWatch.</p>
            <p>Slack: Para receber notificações de falhas e alertas.</p>
            
            <h2>Conclusão</h2>
            <p>Este projeto não só aprimora o conhecimento técnico em Linux, AWS e automação, mas também reforça a importância de monitorar continuamente os serviços para garantir alta disponibilidade e rápida resposta a incidentes. A implementação prática e a documentação detalhada proporcionam uma base sólida para futuros projetos de infraestrutura e administração de servidores.</p>
        </div>

        <hr>
    
        <footer>
            <div style="display: flex; justify-content: space-between;">
                    <p class="footer-partner-title">Strategic partnership</p>
                    <img src="	https://compass.uol/content/dam/aircompanycompass/footer/aws-logo.webp" class="footer-partner-image" alt="AWS's logo">
                    <p class="footer-partner-title">Powered by</p>
                    <img src="	https://compass.uol/content/dam/aircompanycompass/footer/ai-cockpit-logo.webp" class="footer-ai-cockpit-image" alt="Ai Cockpit's logo">
                    <img src="https://compass.uol/content/dam/aircompanycompass/footer/part-of-air-mobile.webp" class="footer-ai-logo" alt="Part of AI/R">
                </div>
            <p style="text-align: center;">© COMPASS UOL TECNOLOGIA LTDA — 1996 – 2025— All rights reserved</p>
        </footer>
    </div>
    </body>
</html>
EOF

# Habilitar e iniciar o serviço Nginx para reinício automático
sudo systemctl enable nginx --now

#Verifica se o Nginx esta rodando

sudo sh -c cat << 'EOF' > /usr/local/bin/monitoramento_web.sh
#!/bin/bash

SERVICE="nginx"

#verificar se o Nginx está rodando
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
EOF

#Altere as permissoes de execucao do script
sudo chmod +x /usr/local/bin/monitoramento_web.sh


#Cria um serviço systemd para garantir que o Nginx reinicie automaticamente

sudo sh -c cat << 'EOF' > /etc/systemd/system/servico_monitoramento_nginx.service
[Unit]
Description=Monitoramento do Nginx
After=network.target

[Service]
ExecStart=/usr/local/bin/monitoramento_web.sh
Type=simple
User=root
EOF


#Cria o timer para executar o serviço a cada 1 minuto
sudo sh -c cat << 'EOF' > /etc/systemd/system/monitoramento_nginx.timer
[Unit]
Description=Executar o monitoramento do Nginx a cada 1 minuto

[Timer]
OnBootSec=1min
OnUnitActiveSec=1min
Unit=servico_monitoramento_nginx.service

[Install]
WantedBy=timers.target
EOF

#Recarregue as configurações do systemd
sudo systemctl daemon-reload

#Habilite o timer para iniciar automaticamente com o sistema
sudo systemctl enable monitoramento_nginx.timer


#Inicie o timer imediatamente
sudo systemctl start monitoramento_nginx.timer

# Monitoramento e Notificacaoes
# Script para criar o monitoramento do site e enviar ao Slack
sudo sh -c cat << 'EOF' > /usr/local/bin/monitoramento_notificacao.sh
#!/bin/bash

# Verificar se a pasta que criamos monitoramento.log se não criar em log
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
EOF

# Aqui tornaremos o script executável
sudo chmod +x /usr/local/bin/monitoramento_notificacao.sh

# Comando para instalar o cron
sudo apt install cron -y

# Aqui adicionar a tarefa cron para rodar a cada 1 minuto
(sudo crontab -l 2>/dev/null; echo "* * * * * /usr/local/bin/monitoramento_notificacao.sh") | sudo crontab -

# Execute o comando para iniciar o cron
sudo service cron start

```

## :clipboard: Conclusão

A elaboração deste projeto proporciona desenvolver o conhecimento técnico em Linux, AWS e automação através de Scripts, 
também reforça a importância de monitorar continuamente os serviços para garantir a alta disponibilidade dos serviços 
e rápida resposta a incidentes ao criar a nossa integração com Slack para recebimento das notificações. 
A implementação prática e a documentação detalhada proporcionam uma base sólida para futuros projetos de 
infraestrutura e administração de servidores.




