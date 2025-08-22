## Описание тестового задания:
Написать скрипт на bash для мониторинга процесса test в среде linux.
Скрипт должен отвечать следующим требованиям:
- Запускаться при запуске системы (предпочтительно написать юнит
systemd в дополнение к скрипту)
- Отрабатывать каждую минуту
- Если процесс запущен, то стучаться(по https) на
https://test.com/monitoring/test/api
- Если процесс был перезапущен, писать в лог /var/log/monitoring.log
(если процесс не запущен, то ничего не делать)
- Если сервер мониторинга не доступен, так же писать в лог.
### Что сделано:
- `test.sh` — bash-скрипт, отслеживающий процесс и отправляющий HTTPS-запрос
- `test.service` — юнит systemd для выполнения скрипта
- `test.timer` — таймер systemd для запуска каждую минуту
### Установка:
1. Скопируйте скрипт:
   ```bash
   sudo cp test.sh /usr/local/bin/test.sh
   sudo chmod +x /usr/local/bin/test.sh
2. Скопируйте юниты:
   ```bash
   sudo cp test.service /etc/systemd/system/
   sudo cp test.timer /etc/systemd/system/
3. Перезагрузите конфигурацию systemd:
    ```bash
    sudo systemctl daemon-reload
4. Включите и запустите таймер:
    ```bash
    sudo systemctl enable test.timer
    sudo systemctl start test.timer
5. Проверьте статус:\
   ```bash
    systemctl status test.timer
    tail -f /var/log/monitoring.log
   
