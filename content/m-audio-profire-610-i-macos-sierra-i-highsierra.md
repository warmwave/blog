Title:  M-Audio Profire 610 в Sierra и HighSierra
Date: 2017-11-12 01:45
Author: azq
Category: Шумы и звуки
Tags: HighSierra, Kext Utility, M-Audio, Profire, Sierra
Slug: m-audio-profire-610-i-macos-sierra-i-highsierra
Status: published

Проблема с двайверами для **M-Audio Profire 610** в новых яблочных ОС замечена уже [не первый раз](/kompy-i-seti/ne-rabotaet-m-audio-profire-610-v-yosemite.html).

Все файлы из этой статьи можно скачать [**здесь**](/files/ProFire610_DriverSierra.zip).

**Данная техника проверена на macOS Sierra и OSX High Sierra. Перезегрузка в Recovery Mode, ровно как отключение SIP не требуются.**

Перед тем как выполнять действия описанные ниже, нужно установить последние доступные драйвера. Скачать их можно с [сайта производителя](http://m-audio.com/support/drivers). Устанавливаем драйвера и не перезагружаемся (мастер установки попросит перезагрузить систему).

**Звуковая карта должна быть отключена. **

И так, ПОГНАЛИ.
---------------

1 - Открываем терминал:

```
sudo rm -rf /System/Library/Extensions/M-AudioFireWireDICE.kext
sudo rm -rf /Library/Extensions/M-AudioFireWireDICE.kext
```

2 - Файл [M-AudioFireWireDICE.kext](/files/ProFire610_DriverSierra.zip) копируем в **/Library/Extensions**

3 - Запускаем [Kext Utility](http://cvad-mac.narod.ru/files/Kext_Utility.app.v2.6.6.zip), вводим пароль и фиксим права.

Далее перезагружаем систему (можно с помощью окна мастера установки) и радуемся!!!