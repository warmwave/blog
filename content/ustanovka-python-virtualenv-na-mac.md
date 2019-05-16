Title: Virtualenv на Mac OS X
Date: 2013-07-20 23:43
Author: azq
Category: Компы и сети
Tags: Mac OS X, pip, python, virtualenv, перевод
Slug: ustanovka-python-virtualenv-na-mac
Status: published

Virtualenv позволяет создать изолированное окружение для вашего проекта. Своеобразная песочница в которой можно как угодно гадить и не опосаться за установленные модули и/или проекты  
<!--more-->

Существует множество способов установки Python и Virtualenv на Mac OS X 10.8 Mountain Lion. Здесь, в этой статье, описан один из них.

Первые шаги
-----------

Предполагается, что вы уже установили Xcode и Homebrew. За подробностями можно обратиться к статье "[Настройка Mac OS X](/kompy-i-seti/nastrojjka-mac-os-x.html "Настройка Mac OS X")''.

Python
------

Мы будем устанавливать Python с помощью Homebrew. Зачем, спросите вы, ведь с Mac OS X он идёт по умолчанию. Вот несколько причин:

-   Homebrew всегда имеет самые последние версии (в настоящее время 2.7.5). Версия в комплекте с OS X - 2.7.2.
-   Apple зделала значительные изменения в своем комплекте Python, и потенциально содержит ошибки.
-   "Домороценный" Python включает в себя последние версии инструментов управления пакетами: [pip](http://www.pip-installer.org/) и [Setuptools](http://pythonhosted.org/setuptools/)

В Lion версия OpenSSL (0.9.8r) от февраля 2011 года, так что мы скажим хомяку загрузить последнюю версию OpenSSL и компилировать Python с ним.

Используйте следующую команду для установки Python через Homebrew:

    brew install python --with-brewed-openssl

Вы уже изменяли `PATH`, как сказано в "[Настройка Mac OS X Mountain Lion 10.8](/kompy-i-seti/nastrojjka-mac-os-x.html "Настройка Mac OS X")'', верно? Если нет, пожалуйста, сделайте это сейчас.

Опционально можно установить Python 3.x рядом с Python 2.x:

    brew install python3 --with-brewed-openssl

Pip
---

Допустим, вы хотите установить пакет Python, такой как [virtualenv](http://www.virtualenv.org/) - инструмент изоляции среды. Почти в каждой статье про Python для Mac OS X рассказывается о способе через `sudo easy_install virtualenv`. Вот почему я не делаю это так:

1.  Для этого нужны root права
2.  Всё барахло устанавливается в глобальную(системную) папку /Library
3.  [pip](http://www.pip-installer.org/) развивается болле активно нежели Setuptools’овский `easy_install`
4.  Используя инструменты предоставленные Homebrew мы получаем более стабильное Python-окружение

Как вы наверное уже догадались, мы будем использовать инструменты, полученные при установки пакетов Python. Если установка производится с помощью "доморощенного" pip, пакеты будут установлены в /usr/local/lib/python2.7/site-packages, а бинарники будут падать в /usr/local/bin.

Система контроля версий
-----------------------

Я уже давненько юзаю [Mercurial](http://mercurial.selenic.com/), а репозитории заливаю на [Bitbucket](https://bitbucket.org/j/dotfiles) и [GitHub](https://github.com/justinmayer/dotfiles), давайте установим [Mercurial](http://mercurial.selenic.com/) и [hg-git](http://hg-git.github.com/):

    pip install Mercurial hg-git

Как минимум, потребуется добавить несколько строк в .hgrc файл, чтобы использовать Mercurial:

    vim ~/.hgrc

Измените значения на ваше имя и адрес электронной почты, соответственно:

    [ui]
    username = YOUR NAME <address@example.com>;

Чтобы проверить Mercurial, выполните следующую команду:

    hg debuginstall

Если последняя строка - “No problems detected”, значит Mercurial установлен и настроен должным образом..

Virtualenv
----------

Пакеты Python установлены в \~/.local are indeed local to the user, но они также являются глобальными в том смысле, что они доступны во всех проектах данного пользователя. Это может быть удобнее в разы, но это также создает и проблемы. Для примера, иногда одним проектам нужна последняя версия Django, в то время как другому проекту нужна, например, версия 1.3 для совместимости с используемыми в проекте разшерениями. Чтобы решить эту проблему, и был разработан. В моей системе только [virtualenv](http://www.virtualenv.org/), virtualenvwrapper, и [Mercurial](http://mercurial.selenic.com/) доступны для Python, а всё остальное ограничивается виртуальным окружением (т.е. virtualenv).

Теперь все обьяснения позади, теперьустановим [virtualenv](http://www.virtualenv.org/):

    pip install virtualenv

Создим папки для хранения наших проектов и виртуальных сред, соответственно:

    mkdir -p ~/Projects ~/Virtualenvs

откроем \~/.bashrc file…

    vim ~/.bashrc

… и добавим несколько строк:

    # pip должен выполняться только если активирован virtualenv
    export PIP_REQUIRE_VIRTUALENV=true
    # кешируем пакеты чтобы избежать повторной загрузки
    export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

Перезагружаем bash:

    source ~/.bash_profile

Сейчас virtualenv установлен и готов к работе, которые будут храниться в `~/Virtualenvs`. Новое окружение создаётся следующим образом:

    cd ~/Virtualenvs
    virtualenv test

Если у нас стоят оба Python, 2.x и 3.x, можно создать виртуальное окружение с Python 3.x:

    virtualenv -p python3 test-py3

… что облегчит переключение между Python 2.x и 3.x

Ограничение pip витруальным окружением
--------------------------------------

Что произойдёт, если мы *думаем*, что работаем в виртуальном окружении, но на самом деле она не активно, а мы устанавливаем что-нибудь с помощью Pip? Тогда в этом случае пакет установится в глобальный site-packages(/usr/local/lib/python2.7/site-packages), сведя на "нет" всю нашу изоляцию.

К счастью pip имеет один малодокументированный параметр который рещит нашу проблему. На самом деле мы им уже воспользовались). Помните, выше мы писали - `export PIP_REQUIRE_VIRTUALENV=true`? Например, давайте посмотрим, что происходит, когда мы пытаемся установить пакет в отсутствии активированной виртуальной среды:

    $ pip install markdown
    Could not find an activated virtualenv (required).

Прекрасно! Но, возникает вопрос, как установить или обновить глобальный пакет? Просто добавляя следующие строки в .bashrc:

    gpip(){
       PIP_REQUIRE_VIRTUALENV="" pip "$@"
    }

Функция выше позволяет нам сделать это через:

    gpip install --upgrade --no-use-wheel 
    pip setuptools virtualenv

Создание нового окружения
-------------------------

Давайте создадим виртуальную среду для [Pelican](http://getpelican.com/), генератор статического сайта на основе Python, и установим его:

    cd ~/Virtualenvs
    virtualenv pelican

Активируем среду:

    cd pelican
    . bin/activate

Для установки [Pelican](http://getpelican.com/) в окружение успользуем pip:

    pip install pelican markdown

Для получения дополнительной информации о виртуальных средах читаем [virtualenv docs](http://www.virtualenv.org/).
