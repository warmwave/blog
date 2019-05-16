Title:  Ошибка GPG. Следующие подписи неверные: KEYEXPIRED
Date: 2017-11-06 02:49
Author: azq
Category: Компы и сети
Tags: apt, apt-key, Debian
Slug: oshibka-gpg-sleduyushhie-podpisi-nevernye-keyexpired
Status: published

При обновлении пакетов заметил следущее:

```
Получено 86,1 kБ за 5с (15,1 kБ/c)
Чтение списков пакетов… Готово
W: Ошибка GPG: http://debian-archive.trafficmanager.net jessie InRelease: Следующие подписи неверные: KEYEXPIRED 1507383481
```

Всё решается, всё просто.
-------------------------

```
➜ ~ apt-key list | grep expired
```

или

```
➜ ~ apt-key list | grep просрочен
pub 4096R/B98321F9 2010-08-07 [просрочен с: 2017-08-05]
pub 2048R/A86CAD7F 2015-10-08 [просрочен с: 2017-10-07]
➜ ~ apt-key del B98321F9
OK
➜ ~ apt-key del A86CAD7F
OK
```

 
