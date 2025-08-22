#!/bin/bash
LOGFILE="/var/log/monitoring.log"
PROCESS_NAME="test"
URL="https://test.com/monitoring/test/api"
STATE_FILE="/tmp/test_process.pid"
# Если лог-файла нет - создаем его
touch "$LOGFILE" 2>/dev/null || echo "$(date): Не удалось создать лог-файл $LOGFILE" | sudo tee -a "$LOGFILE" > /dev/null
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" | sudo tee -a "$LOGFILE" > /dev/null
}
# Проверяем запущен ли процесс
PID=$(pgrep "^$PROCESS_NAME$" | head -n1)
# Если процесс не запущен - ничего не делаем
if [ -z "$PID" ]; then
    exit 0
fi
# Проверяем изменился ли PID процесса
if [ -f "$STATE_FILE" ]; then
    OLD_PID=$(cat "$STATE_FILE")
    if [ "$OLD_PID" != "$PID" ]; then
        log_message "Процесс $PROCESS_NAME перезапущен (старый PID: $OLD_PID, новый PID: $PID)"
    fi
else
    log_message "Мониторинг процесса $PROCESS_NAME запущен (PID: $PID)"
fi
# Сохраняем текущий PID
echo "$PID" > "$STATE_FILE" 2>/dev/null || sudo sh -c "echo '$PID' > $STATE_FILE"
# Отправляем запрос
if curl -f -s -o /dev/null -w "%{http_code}" -X GET "$URL" --connect-timeout 10 --max-time 20 | grep -q "200"; then
    log_message "Успешный запрос к $URL"
else
    log_message "Ошибка: не удалось отправить запрос к $URL"
fi