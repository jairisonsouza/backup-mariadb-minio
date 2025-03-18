#!/bin/bash

# Configurações do MariaDB
DB_USER="root"
DB_PASSWORD="SUA_SENHA"
DB_HOST="localhost"
DB_PORT="3306"
DB_NAME="meu_banco"
BACKUP_DIR="/var/backups/mariadb"
BACKUP_FILE="${BACKUP_DIR}/backup_$(date +'%Y%m%d_%H%M%S').sql.gz"

# Configurações do MinIO
MINIO_BUCKET="meus-backups"
MINIO_ENDPOINT="http://SEU_MINIO_URL:9000"

# Criar diretório de backup, se não existir
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    chmod 750 "$BACKUP_DIR"
fi

# Testar permissão de escrita
if [ ! -w "$BACKUP_DIR" ]; then
    echo "Erro: Sem permissão para escrever em $BACKUP_DIR"
    exit 1
fi

# Gerar o backup do MariaDB
mysqldump -u "$DB_USER" -p"$DB_PASSWORD" -h "$DB_HOST" -P "$DB_PORT" "$DB_NAME" | gzip > "$BACKUP_FILE"

# Verificar se o backup foi criado
if [ -f "$BACKUP_FILE" ]; then
    echo "Backup criado: $BACKUP_FILE"

    # Enviar backup para o MinIO
    aws --endpoint-url "$MINIO_ENDPOINT" s3 cp "$BACKUP_FILE" "s3://$MINIO_BUCKET/"
    
    if [ $? -eq 0 ]; then
        echo "Backup enviado para MinIO com sucesso."
    else
        echo "Falha ao enviar backup para MinIO."
    fi

    # Manter apenas os 3 backups mais recentes no servidor local
    ls -tp "$BACKUP_DIR"/*.sql.gz | grep -v '/$' | tail -n +4 | xargs -d '\n' rm -f

    echo "Limpeza concluída: Mantidos os 3 backups mais recentes."
else
    echo "Erro ao criar backup!"
    exit 1
fi
