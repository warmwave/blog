#!/bin/bash

cd ~/
echo
echo "WarmWave Script - warmwavemedia@gmail.com"
echo
echo "Выберите действие:"
echo
echo "1"
echo "2 - Установка Dante"
echo "3 - Установка 3proxy - руками"
echo "4 - Установка 3proxy"
echo "0 - Выход"

read doing #здесь мы читаем в переменную $doing со стандартного ввода

case $doing in
	1)	

	;;
	2) # Установка Dante
		# https://habrahabr.ru/company/aladdinrd/blog/353738/
		wget https://www.inet.no/dante/files/dante-1.4.1.tar.gz
		tar -xvf dante-1.4.1.tar.gz
		cd dante-1.4.1
		apt-get install gcc make
		mkdir /root/dante
		./configure --prefix=/root/dante
		make
		make install
		echo 'logoutput: /var/log/socks.log

internal: eth0 port = 1088 # В качестве входящего соединения используем наш дефолтный интерфейс на порту 1080
external: eth0 #В качестве выходного также его

method: username 
user.privileged: root #Рут нужен для возможности проводить аутентификацию системных пользователей
user.notprivileged: nobody

client pass {
		from: 0.0.0.0/0 to: 0.0.0.0/0 #Правила оставляем как есть, для наших целей этого достаточно
		log: error connect disconnect
}

client block {
		from: 0.0.0.0/0 to: 0.0.0.0/0
		log: connect error
}

pass {
		from: 0.0.0.0/0 to: 0.0.0.0/0
		log: error connect disconnect
}

block {
		from: 0.0.0.0/0 to: 0.0.0.0/0
		log: connect error
}
		' >> /root/dante/danted.conf
		/root/dante/sbin/sockd -f /root/dante/danted.conf -D

		echo 'Блокируем двухсторонний пинг'
		iptables -I INPUT 1 -p icmp -j DROP
		echo 'ОК'
		echo 'Dante установлен'
		echo ''
		echo 'Создать пользователя - 	useradd --shell /usr/sbin/nologin username'
		echo 'Задать пароль для юзера - passwd username'
		echo 'Остановка и перезапуск - 	pkill sockd && /root/dante/sbin/sockd -f /root/dante/danted.conf -D'
	;;
	3) # Установка 3proxy
		if [ "$rls" == "xenial" ]||[ "$rls" == "stretch" ]||[ "$rls" == "trusty" ]||[ "$rls" == "jessie" ]; then
			apt-get install wget git zip build-essential wget
		else
			yum install wget git zip build-essential wget
		fi

		cd ~/
		rm -rf ~/3proxy* && rm -rf /usr/local/3proxy && rm -rf /etc/init.d/3proxy
		# apt-get update && apt-get install build-essential wget
		# wget http://3proxy.ru/0.7.1.2/3proxy-0.7.1.2.tgz
		# wget https://github.com/z3APA3A/3proxy/archive/3proxy-0.8.6.tar.gz
		# wget http://3proxy.ru/current/3proxy-0.9-devel.tgz && tar -xvzf 3proxy-0.9-devel.tgz && cd ~/3proxy*
		wget https://github.com/z3APA3A/3proxy/archive/devel.zip && unzip devel.zip && cd ~/3proxy*
		echo '#define ANONYMOUS 1' >> ./src/proxy.h && make -f Makefile.Linux && mkdir /var/log/3proxy && mkdir -p /usr/local/3proxy && cp src/3proxy /usr/local/3proxy
		echo '# Важно указать данное значение, так как только при нем процесс 3proxy уйдет в background
daemon

# Пропишем правильные серверы имен, посмотрев их на своем сервере в /etc/resolv.conf
nserver 8.8.8.8
nserver 8.8.8.4

# Оставим размер кэша для запросов DNS по умолчанию
nscache 65536
# Равно как и таймауты
timeouts 1 5 30 60 180 1800 15 60

# Путь к логам и формат лога, к имени лога будет добавляться дата создания
log /var/log/3proxy/3proxy.log D
logformat "L%C - %U [%d/%o/%Y:%H:%M:%S %z] ""%T"" %E %I %O %N/%R:%r"
archiver gz /usr/bin/gzip %F
rotate 30

# Отслеживать изменения в файле конфигурации
monitor "/usr/local/3proxy/3proxy.cfg"

# Создаем пользователей
users proxyuser:CL:zXGHQD7szBa7aXdGyynD

flush
auth strong
allow proxyuser 88.85.172.25 * * *
# allow * * * *
# proxy -6 -p33128 -n -a -i134.0.117.62 -e2a00:f940:1:1:2::8b8
proxy -p33128 -n -a -i188.138.95.105 -e188.138.95.105
# proxy -p33128 -n -a -i10.0.0.6 -e10.0.0.6

# flush
# auth none
# auth strong
# users proxyuser:CL:zXGHQD7szBa7aXdGyynD
# socks -6 -p33129 -i134.0.117.62 -e2a00:f940:1:1:2::8b8
socks -p33129 -i188.138.95.105 -e188.138.95.105
# socks -p33129 -i10.0.0.6 -e10.0.0.6

# Запустить административный веб-интерфейс на порту 8081
# flush
# auth none
# allow * * * *
# admin -p8081

# Запускаем сервер от пользователя nobody
# (возможно в вашей ОС uid и gid пользователя nobody будут другими, для их определения воспользуйтесь командой id nobody)
setgid 65534
setuid 65534' >> /usr/local/3proxy/3proxy.cfg
		echo '#!/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/local/3proxy/3proxy
DAEMON_OPTS=/usr/local/3proxy/3proxy.cfg
NAME=3proxy
DESC=3proxy
test -f $DAEMON || exit 0
set -e
case "$1" in
	start)
		echo -n "Starting $DESC: "
		start-stop-daemon --start --quiet --pidfile /usr/local/3proxy/$NAME.pid \
		--exec $DAEMON $DAEMON_OPTS
		echo "done."
	;;
	stop)
		echo -n "Stopping $DESC: "
		start-stop-daemon --stop --quiet --pidfile /usr/local/3proxy/$NAME.pid \
		--exec $DAEMON
		echo "done."
	;;
	restart)
		stop
		start
	;;
	*)
		N=/etc/init.d/$NAME
		echo "Usage: $N {start|stop}" >&2
		exit 1
	;;
esac
exit 0' >> /etc/init.d/3proxy
		chown -R nobody:nogroup /usr/local/3proxy && chmod +x /etc/init.d/3proxy && update-rc.d 3proxy defaults && service 3proxy start
		cd ~/
		echo '3proxy установлен'
	;;
	4)
		git clone https://github.com/z3apa3a/3proxy
		cd 3proxy
		ln -s Makefile.Linux Makefile
		make
		sudo make install
		echo '3proxy установлен'
	;;
	0)
		exit 0
	;;
	*) #если введено с клавиатуры то, что в case не описывается, выполнять следующее:
		echo "Введено неправильное действие"
esac #окончание оператора case.
