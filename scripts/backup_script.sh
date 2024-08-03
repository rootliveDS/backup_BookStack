
#!/bin/bash

IP_ADDRESS=''                    # IP сервера с установленным BookStack
REMOTE_USER=''                           # Пользователь для передачи данных

MYSQL_USER=''                            # Пользователь базы данных на сервере BookStack
MYSQL_DB=''                         # База данных на сервере BookStack
MYSQL_PASS=''                    # Пароль пользователя базы данных на сервере BookStack

DAYS_TO_KEEP=1                              # Количество дней хранения бекапов на локальном сервере

TIMESTAMP=$(date +%Y%m%d%H)
TIMESTAMP_DATE=$(date +%Y%m%d)

LOG_DIR="/var/log/BookStack_backups_log"
LOG_FILE="$LOG_DIR/backup_log_$TIMESTAMP.log"

BACKUP_DIR="/var/backups/BookStack/backup_$TIMESTAMP"
BACKUP_DIR_DB="$BACKUP_DIR/database"
BACKUP_DIR_FIlES="$BACKUP_DIR/Files"

mkdir -p "$BACKUP_DIR"
mkdir -p "$BACKUP_DIR_DB"
mkdir -p "$BACKUP_DIR_FIlES"
mkdir -p "$LOG_DIR"
touch "$LOG_FILE"

SOURCE_DIRS=(
    "/var/www/bookstack/.env"
    "/var/www/bookstack/public/uploads"
    "/var/www/bookstack/storage/uploads"
    "/var/www/bookstack/themes"
)

log() {
    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $1" >> "$LOG_FILE"
}

log "Starting backup at $(date)"

ssh -t $REMOTE_USER@$IP_ADDRESS "mkdir -p $BACKUP_DIR_DB"
ssh -t $REMOTE_USER@$IP_ADDRESS "mysqldump -u $MYSQL_USER -p'$MYSQL_PASS' $MYSQL_DB" > "$BACKUP_DIR_DB/db_bakcup_$TIMESTAMP.sql" &&

log "MySQL backup completed successfully" ||
log "MySQL backup failed"


for dir in "${SOURCE_DIRS[@]}"
do
    dir_name=$(basename "$dir")
    parent_dir_name=$(basename "$(dirname "$dir")")
    echo "$dir"
    echo "${parent_dir_name}_${dir_name}"
    echo $BACKUP_DIR_FIlES
    if [ ! -d "/var/backups/BookStack/backup_$TIMESTAMP/Files/${parent_dir_name}_${dir_name}" ]; then
        mkdir -p "/var/backups/BookStack/backup_$TIMESTAMP/Files/${parent_dir_name}_${dir_name}"
    fi


    rsync -avz --progress "$REMOTE_USER@$IP_ADDRESS:$dir" /var/backups/BookStack/backup_$TIMESTAMP/Files/${parent_dir_name}_${dir_name} >> "$LOG_FILE" 2>&1
    echo "rsync -avz --progress $REMOTE_USER@$IP_ADDRESS:$dir /var/backups/BookStack/backup_$TIMESTAMP/Files/${parent_dir_name}_${dir_name}"
done


rsync -avz -e ssh $REMOTE_USER@$IP_ADDRESS:$BACKUP_DIR_DB/db_backup_$TIMESTAMP.sql $BACKUP_DIR_DB/

ssh -t $REMOTE_USER@$IP_ADDRESS "rm -rf $BACKUP_DIR_DB"
BACKUP_DIR_SOURCE="/var/backups/BookStack"
find "$BACKUP_DIR_SOURCE" -type d -mtime +$DAYS_TO_KEEP -exec rm -rf {} \;