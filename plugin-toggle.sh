#!/bin/bash

### Скрипт для временного отключения плагина и возврата через 5 минут ###

PLUGIN_DIR="/home/*/public_html/wp-content/plugins/rss-feed-post-generator-echo"
BACKUP_SUFFIX="_disabled_by_script"
LOG="/var/log/plugin-toggle.log"

echo "[*] Запуск plugin-toggle: $(date)" >> $LOG

# Найдём и переименуем директорию плагина
for path in $PLUGIN_DIR; do
  if [ -d "$path" ]; then
    new_path="${path}${BACKUP_SUFFIX}"
    echo "[!] Отключение плагина: $path -> $new_path" | tee -a $LOG
    mv "$path" "$new_path"

    # Фоновый возврат через 5 минут
    (sleep 300 && mv "$new_path" "$path" && echo "[✔] Возврат плагина: $new_path -> $path" >> $LOG) &
  else
    echo "[-] Плагин не найден по пути: $path" >> $LOG
  fi

done

echo "[*] Готово. Лог: $LOG"
