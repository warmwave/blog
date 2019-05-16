Title:  Меняем root-пароль MySQL в MAC OS X
Date: 2014-08-22 19:10
Author: azq
Category: Компы и сети
Tags: Mac OS X, MySQL, перевод, Сбрасываем пароль MySQL
Slug: menyaem-root-parol-mysql-v-mac-os-x
Status: published

Устанавливал я как-то MySQL на OS X, и толи я запарил, толи одно из двух… но пароль который я вводил не подходил(((

<!--more-->Решаем проблему:  
Сначала останавливаем службу:

    sudo /Library/StartupItems/MySQLCOM/MySQLCOM stop

Далее выполняем:

    /usr/local/mysql/bin/mysqld_safe --skip-grant-tables

А для старых версий MySQL:

    /usr/local/mysql/bin/safe_mysqld --skip-grant-tables

Теперь открываем ЕЩЁ ОДНО окно терминала и выполняем:

    /usr/local/mysql/bin/mysql mysql
    use mysql;
    UPDATE user SET Password=PASSWORD(‘YOUR_PASSWORD’) WHERE Host=’localhost’ AND User=’root’;
    flush privileges;
    quit

Всё. Перезапускаем службу:

    sudo /Library/StartupItems/MySQLCOM/MySQLCOM restart

P.S. Остановку и запуск можно выполнять через «Системные настройки»
