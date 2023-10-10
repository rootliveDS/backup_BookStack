#!/bin/bash

# crontab

CRON_SCHEDULE='0 2 * * *'                      # Расписание Cron

SCRIPT_PATH='backup_script.sh'   

(crontab -l ; echo "$CRON_SCHEDULE $SCRIPT_PATH") | crontab -