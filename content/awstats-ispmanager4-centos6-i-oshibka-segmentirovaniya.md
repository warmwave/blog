Title:  Awstats, ISPmanager4, CentOS6 и ошибка сегментирования.
Date: 2017-08-14 19:22
Author: azq
Category: Компы и сети
Tags: Awstats, CentOS, ISPmanager, ISPmanager4, ISPmgr
Slug: awstats-ispmanager4-centos6-i-oshibka-segmentirovaniya
Status: published

Изначально сам Awstats ставился отсюда:

```
https://sourceforge.net/projects/awstats/files/AWStats/7.6/
```

Соответственно, версия - awstats-7.6-1. Далее был поправлен конфиг /etc/httpd/conf.d/awstats.conf, очищен кэш ISPmanager.  
**В итоге Awstats заработал.**

Но две недели назад Awstats перестал обновлять статистику, хотя логи ротировались, и посещаемость у сайтов была.  
На сервере 3 новостных сайта. Cтатистика нужна очень, причём именно серверная, ибо гугло-яндексы давно и безбожно врут.

При попытке обновить статистику вручную выдаётся ошибка "Segmentation fault".
-----------------------------------------------------------------------------

В messages-логах появляются подобные записи:

```
"awstats.pl: segfault at 0 ip 0000003face07b65 sp 00007ffd9c7a0b90 error 4 in libGeoIP.so.1.6.5[3face00000+34
Not saving repeating crash in '/usr/bin/perl'"
```

Статистика обновлялась в ручную:

```
/usr/local/awstats/wwwroot/cgi-bin/awstats.pl -config=domain.com -update
```

либо так, как делает это ISPmanager:

```
/usr/local/ispmgr/sbin/awstats2.sh domain.com /var/www/domain/data/logs/domain.com.access.log /var/www/domain/data/www/domain.com/webstat
```

Но в чём потом возникла проблема? В модуле libGeoIP.so?
-------------------------------------------------------

Дело было вот в чём.  
В конфигах awstats для каждого домена были такие директивы:

```
LoadPlugin="geoip GEOIP_STANDARD /usr/share/GeoIP/GeoIP.dat"
LoadPlugin="geoip_city_maxmind GEOIP_STANDARD /usr/share/GeoIP/GeoLiteCity.dat"
LoadPlugin="geoip_org_maxmind GEOIP_STANDARD /usr/share/GeoIP/GeoIPASNum.dat"
```

А эти dat-файлы скачиваются скриптом, установленным еженедельно в cron/  
В скрипте такие строки:

```
wget -q -O- http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz | gunzip > /usr/share/GeoIP/GeoIP.dat
wget -q -O- http://www.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz | gunzip > /usr/share/GeoIP/GeoLiteCity.dat
wget -q -O- http://www.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz | gunzip > /usr/share/GeoIP/GeoIPASNum.dat
```

Но проблема оказалась в том, что файлы в директории /usr/share/GeoIP/ оказались нулевого размера, потому что с maxmind.com ничего невозможно скачать.  
Я пробовал скачаить с maxmind вручную:

```
wget http://www.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz
```

**Результат: failed: Connection timed out.**  
Соответственно, возникали ошибки при попытке использования этих файлов при построении отчётов.

Причём, с сервера в Германии всё прекрасно скачивается с maxmind.com, а здесь такое ощущение, что либо этот IP у maxmind.com в бане, либо вообще вся подсеть.  
Скачав dat-файлы и подсунув в /usr/share/GeoIP/ проблема решалась.

Но тогда вопрос: Как настроить автоматическое регулярное скачивание, что-бы Awstats работал?
--------------------------------------------------------------------------------------------

Как вариант прокси для скачивания по крону, wget умеет прокси:

Скачать файл через proxy:

```
http_proxy="http://33.22.44.44:8080" wget http://www.google.com/favicon.ico
```

Для HTTPS

```
https_proxy="http://33.22.44.44:8080" wget https://www.google.com/favicon.ico
```

Proxy с авторизацией

```
http_proxy="http://33.22.44.44:8080" wget --proxy-user=user --proxy-password=password http://www.google.com/favicon.ico
```

Параметры --proxy-user и --proxy-password, чтобы не указывать постоянно, можно прописать в файл ~/.wgetrc

```
proxy-user = username
proxy-password = password
user-agent = Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20100101 Firefox/7.0.1
```
