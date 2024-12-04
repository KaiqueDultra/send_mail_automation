#!/bin/bash

# Definindo as variaveis
assunto="Atualização do Agile Release Plan"
corpo_email="Olá, prezado(a). Por favor, peço que atualize o agile release plan do seu projeto até sexta-feira.\n\nNome do projeto: %s\nLink do projeto: %s\n\nObrigado,\nSE Team."
from_email="kaique.dultra@outlook.com"

# Caminho para o arquivo JSON
json_file="projects.json"

# Lendo os arquivos JSON e itera sobre os projetos
jq -c '.[]' "$json_file" | while read -r project; do
    # Extraindo as informacoes do projeto
    project_name=$(echo "$project" | jq -r '.project_name')
    link_confluence=$(echo "$project" | jq -r '.link_confluence')
    email_pls=$(echo "$project" | jq -r '.email_pls')
    email_bbc=$(echo "$project" | jq -r '.email_bcc')

    # Substituindo as variaveis no corpo do email
    corpo_email_formatado=$(printf "$corpo_email" "$project_name" "$link_confluence")

    # Enviando email usando o comando mail ou sendmail
    echo -e "$corpo_email_formatado" | mailx -s "$assunto" \
        -r "$from_email" \
        -c "$email_pls" \
        -b "$email_bcc"

    echo "Email enviado para $email_pls (BCC: $email_bcc)"
done