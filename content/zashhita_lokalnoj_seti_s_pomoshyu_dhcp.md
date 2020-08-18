Title:  Python-скрипт для "предупреждения вторжения" в локальную сеть по средствам DHCP-сервера.
Date: 2020-08-17 17:33
Author: azq
Category: Компы и сети
Tags: Python, isc-dhcp-server
Slug: zashhita_lokalnoj_seti_s_pomoshyu_dhcp
Status: published

Первый запуск и/или дальнейшее добавление "легальных" клиентов из уже выданных IP:

```python3 dhcpMagic.py --m```

парамметр --m отображает конф.диалог

Для постоянного наблюдения за клиентами/нарушителями добавляем в cron:

```python3 dhcpMagic.py```

либо

```python3 dhcpMagic.py -AE (если в config.py AUTOEDIT = False)```

При необходимости правим config.py:
```
DEBUG = False # False - пишет логи в файл, True - отображает конф.диалог (аналог --m при запуске)
AUTOEDIT = True # Следить за нарушителями (аналог -AE при запуске)
interface = 'enp0s8' # Интерфейс на котором висит DHCP-сервер
dhcpConfFile = '/etc/dhcp/dhcpd.conf'

fourthActet = '40-90'
netmask = '255.255.255.0'
defaultLeaseTime = 10
maxLeaseTime = 10
domainNameServers = '8.8.8.8'
domainName = 'workgroup'
```

**Сам скрипт [тут][1]**
[1]: https://gitlab.com/warmwavemedia/dhcpmagic "Ссылка на репу" 