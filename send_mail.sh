#!/bin/bash

# Definindo as variáveis
assunto="Atualização do Agile Release Plan"
corpo_email="Olá, prezado(a). Por favor, peço que atualize o agile release plan do seu projeto até sexta-feira.\n\nNome do projeto: %s\nLink do projeto: %s\n\nObrigado,\nSE Team."
from_email="kaiquedultra@outlook.com"
smtp_server="smtp.office365.com"
smtp_port="587"
smtp_user="kaiquedultra@outlook.com"
smtp_pass="$OUTLOOK_APP_PASSWORD"

# Caminho para o arquivo JSON
json_file="projects.json"

# Criando o arquivo de configuração do smtp
echo "defaults" > ~/.msmtprc
echo "auth on" >> ~/.msmtprc
echo "tls on" >> ~/.msmtprc
echo "tls_trust_file /etc/ssl/certs/ca-certificates.crt" >> ~/.msmtprc
echo "smtp $smtp_server" >> ~/.msmtprc
echo "smtp_port $smtp_port" >> ~/.msmtprc
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
    email_bcc=$(echo "$project" | jq -r '.email_bcc')

    # Substituindo as variáveis no corpo do email
    corpo_email_formatado=$(printf "$corpo_email" "$project_name" "$link_confluence")

    # Enviando email usando msmtp (com suporte ao MSTP do Outlook)
    # A opcao -S é usada para definir o assunto diretamente, e os parametros --cc e --bcc para definir os destinatarios
    echo -e "$corpo_email_formatado" | msmtp \
        --subject="$assunto" \
        --from="$from_email" \
        --cc="$email_pls" \
        --bcc="$email_bcc"
        "$email_pls" # O destinatario principal 

    echo "Email enviado para $email_pls (BCC: $email_bcc)"
done
