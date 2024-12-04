#!/bin/bash

# Definindo as variáveis
assunto="Atualização do Agile Release Plan"
corpo_email="Olá, prezado(a). Por favor, peço que atualize o agile release plan do seu projeto até sexta-feira.\n\nNome do projeto: %s\nLink do projeto: %s\n\nObrigado,\nSE Team."
from_email="kaique.dultra@outlook.com"
smtp_server="smtp.office365.com"
smtp_port="587"
smtp_user="kaique.dultra@outlook.com"
smtp_pass="$OUTLOOK_APP_PASSWORD"  # Usando o segredo como variável de ambiente

# Caminho para o arquivo JSON
json_file="projects.json"

# Criando o arquivo de configuração do msmtp
echo "defaults" > ~/.msmtprc
echo "account default" >> ~/.msmtprc  # Definindo a conta como 'default'
echo "auth on" >> ~/.msmtprc
echo "tls on" >> ~/.msmtprc
echo "tls_trust_file /etc/ssl/certs/ca-certificates.crt" >> ~/.msmtprc
echo "host $smtp_server" >> ~/.msmtprc   # Configuração do servidor SMTP
echo "port $smtp_port" >> ~/.msmtprc     # Configuração da porta SMTP
echo "from $from_email" >> ~/.msmtprc
echo "user $smtp_user" >> ~/.msmtprc
echo "password $smtp_pass" >> ~/.msmtprc
echo "logfile ~/.msmtp.log" >> ~/.msmtprc
chmod 600 ~/.msmtprc

# Lendo os arquivos JSON e iterando sobre os projetos
jq -c '.[]' "$json_file" | while read -r project; do
    # Extraindo as informações do projeto
    project_name=$(echo "$project" | jq -r '.project_name')
    link_confluence=$(echo "$project" | jq -r '.link_confluence')
    email_pls=$(echo "$project" | jq -r '.email_pls')

    # Substituindo as variáveis no corpo do email
    corpo_email_formatado=$(printf "$corpo_email" "$project_name" "$link_confluence")

    # Enviando email usando msmtp
    # Passando o destinatário principal (To) e o remetente (From) diretamente.
    echo -e "$corpo_email_formatado" | msmtp \
        --from="$from_email" \
        "$email_pls"

    echo "Email enviado para $email_pls"
done
