# Backup Automático do MariaDB para MinIO

Este repositório contém um script shell para realizar backups automáticos de um banco de dados **MariaDB** e enviá-los para um armazenamento **MinIO**.

## 🔧 Requisitos
Antes de iniciar, certifique-se de que possui os seguintes requisitos:

- **Ubuntu Server** ou outra distribuição Linux compatível
- **MariaDB** instalado e configurado
- **MinIO** instalado ou acesso a um servidor MinIO
- **AWS CLI** configurado para acessar o MinIO
- Permissões adequadas para execução do script e escrita no diretório de backup

## 🛠️ Instalação

### 1. Clonar o Repositório
```bash
git clone https://github.com/jairisonsouza/backup-mariadb-minio.git
cd backup-mariadb-minio
```

### 2. Configurar Permissões
Crie o diretório para armazenar os backups e ajuste as permissões:
```bash
sudo mkdir -p /var/backups/mariadb
sudo chown $(whoami):$(whoami) /var/backups/mariadb
sudo chmod 750 /var/backups/mariadb
```

### 3. Configurar AWS CLI para MinIO
Se ainda não configurou o AWS CLI para o MinIO, faça:
```bash
aws configure set aws_access_key_id SEU_ACCESS_KEY
aws configure set aws_secret_access_key SEU_SECRET_KEY
aws configure set region us-east-1
```
Verifique se a conexão está funcionando:
```bash
aws --endpoint-url http://SEU_MINIO_URL:9000 s3 ls
```

### 4. Editar as Configurações do Script
Abra o arquivo **backup_mariadb_minio.sh** e edite as seguintes variáveis conforme sua configuração:
```bash
DB_USER="root"
DB_PASSWORD="SUA_SENHA"
DB_HOST="localhost"
DB_PORT="3306"
DB_NAME="meu_banco"
BACKUP_DIR="/var/backups/mariadb"
MINIO_BUCKET="meus-backups"
MINIO_ENDPOINT="http://SEU_MINIO_URL:9000"
```

### 5. Tornar o Script Executável
```bash
chmod +x backup_mariadb_minio.sh
```

## 🔄 Execução Manual do Backup
Para testar manualmente o script, execute:
```bash
./backup_mariadb_minio.sh
```

Se tudo estiver correto, você verá mensagens indicando a criação do backup e o envio para o MinIO.

## ⏰ Agendar Backup Automático (Cron)
Para agendar a execução automática do backup diariamente às 3h da manhã, adicione a seguinte linha ao crontab:
```bash
crontab -e
```
E adicione:
```bash
0 3 * * * /caminho/para/backup_mariadb_minio.sh >> /var/log/backup_mariadb.log 2>&1
```

## 🌐 Verificação dos Backups no MinIO
Para listar os backups enviados para o MinIO, execute:
```bash
aws --endpoint-url http://SEU_MINIO_URL:9000 s3 ls s3://meus-backups/
```

## 🚀 Conclusão
Este script implementa uma solução simples e eficaz para **backup automatizado** do MariaDB para MinIO, garantindo **segurança, redundância e automação**.

Se você tiver sugestões de melhoria ou encontrar problemas, contribua com o repositório!

#MariaDB #Backup #MinIO #DevOps #Automacao

