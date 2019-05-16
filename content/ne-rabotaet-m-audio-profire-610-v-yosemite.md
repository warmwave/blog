Title:  Не работает M-Audio ProFire 610 в Yosemite
Date: 2014-10-12 16:42
Author: azq
Category: Шумы и звуки
Tags: M-Audio, Yosemite
Slug: ne-rabotaet-m-audio-profire-610-v-yosemite
Status: published

Попробовал я тут поставить Yosemite. Это уже вторая попытка заюзать новую систему.<!--more--> Первая оказалась неудачной т.к. система была, на тот момент, реально сырой. Сейчас всё более-менее. Но всё-же обнаружил одну проблему. У меня не работала звуковая карта - M-Audio ProFire 610.

Пробема, как всегда решилась просто:

```
sudo nvram boot-args="kext-dev-mode=1"
```

 
