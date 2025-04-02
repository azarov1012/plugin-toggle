#!/bin/bash

PLUGIN_NAME="rss-feed-post-generator-echo"
DISABLED_NAME="${PLUGIN_NAME}-disabled"
BASE_PATH="/home"
DELAY_MINUTES=5
LOG="/var/log/plugin-toggle.log"

echo "[*] $(date) — Запуск скрипта" >> $LOG

# Отключение плагина
find $BASE_PATH/*/public_html/wp-content/plugins/ -type d -name "$PLUGIN_NAME" | while read plugin_dir; do
    parent_dir=$(dirname "$plugin_dir")
    new_path="${parent_dir}/${DISABLED_NAME}"
    
    echo "[-] Отключение плагина в $plugin_dir" | tee -a $LOG
    mv "$plugin_dir" "$new_path"
done

echo "[*] Плагин отключён. Ожидаем ${DELAY_MINUTES} минут..." | tee -a $LOG
sleep "${DELAY_MINUTES}m"

# Включение плагина
find $BASE_PATH/*/public_html/wp-content/plugins/ -type d -name "$DISABLED_NAME" | while read disabled_dir; do
    parent_dir=$(dirname "$disabled_dir")
    original_path="${parent_dir}/${PLUGIN_NAME}"

    echo "[+] Включение плагина обратно: $original_path" | tee -a $LOG
    mv "$disabled_dir" "$original_path"
done

echo "[✔] Завершено: $(date)" >> $LOG
