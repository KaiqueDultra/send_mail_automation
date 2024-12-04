#!/bin/bash

# Definindo as variáveis
assunto="Atualização do Agile Release Plan"
corpo_email="Olá, prezado(a). Por favor, peço que atualize o agile release plan do seu projeto até sexta-feira.\n\nNome do projeto: %s\nLink do projeto: %s\n\nObrigado,\nSE Team."
from_email="kaique.dultra@outlook.com"

# Caminho para o arquivo JSON
json_file="projects.json"

# Lendo os arquivos JSON e iterando sobre os projetos
jq -c '.[]' "$json_file" | while read -r project; do
    # Extraindo as informações do projeto
    project_name=$(echo "$project" | jq -r '.project_name')
    link_confluence=$(echo "$project" | jq -r '.link_confluence')
    email_pls=$(echo "$project" | jq -r '.email_pls')
    email_bcc=$(echo "$project" | jq -r '.email_bcc')

    # Substituindo as variáveis no corpo do email
    corpo_email_formatado=$(printf "$corpo_email" "$project_name" "$link_confluence")

    # Enviando email usando mailx, incluindo o destinatário principal, CC e BCC
    echo -e "$corpo_email_formatado" | mailx -s "$assunto" \
        -r "$from_email" \
        -c "$email_pls" \
        -b "$email_bcc" \
        "$email_pls"  # Destinatário principal (To)

    echo "Email enviado para $email_pls (BCC: $email_bcc)"
done
