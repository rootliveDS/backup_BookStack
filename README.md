# Backup BookStack    
 1) Edit endpoints (in backup_script.sh) and Run script config_ssh.sh  - Скрипт создает ключи SSH если они отсутствуют, и затем копирует публичный ключ на удаленный сервер для более безопасной авторизации.

 2) Run script add_crontab.sh  - Скрипт добавляет событие crontab с запуском backup_script.sh


