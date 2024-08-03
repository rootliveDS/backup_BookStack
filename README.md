# Backup BookStack

Этот проект предназначен для создания резервных копий сервера BookStack.

## Конфигурация

1. Откройте `scripts/backup_script.sh` и измените переменные:
   - `IP_ADDRESS`: IP-адрес сервера BookStack.
   - `REMOTE_USER`: Пользователь для подключения к серверу.
   - `MYSQL_USER`, `MYSQL_DB`, `MYSQL_PASS`: Данные для подключения к базе данных MySQL.

## Установка

1. Склонируйте репозиторий:

    ```sh
    git clone https://github.com/ваш-проект/backup-bookstack.git
    cd backup-bookstack
    ```

2. Настройте SSH доступ:

    ```sh
    ./scripts/config_ssh.sh
    ```

3. Добавьте задачу в crontab для автоматического запуска скрипта резервного копирования:

    ```sh
    ./scripts/add_crontab.sh
    ```

## Логи и резервные копии

- Логи хранятся в директории `logs/`.
- Резервные копии хранятся в директории `backups/`.
