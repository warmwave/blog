Title:  Настройка Mac OS X (Xcode, Homebrew etc.)
Date: 2013-07-20 23:42
Author: azq
Category: Компы и сети
Tags: homebrew, Mac OS X, перевод
Slug: nastrojjka-mac-os-x
Status: published

Хочу начать с инструментов командной строки на Mac OS X. В этом учебнике рассматривается установка Xcode, Homebrew (без него никуда), и другие полезности.

Первые шаги
----------------------

«Фишка», пришедшая в месте с Lion — это теперь скрытая папка \~/Library. Сделать её видимой мы можем с помощью следующей команды (при обновлении системы она вновь станет невидимой, поэтому команду нужно будет выполнить вновь):

    chflags nohidden ~/Library/

По умолчанию Lion — это полностью 64-х битная система, весь гемор в том, что всё должно компилироваться в 64-х битном режиме. Кроме того, поскольку в Lion дэфолтный `PATH` — `/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin`, нам нужно изменить его так что-бы бинарники Homebrew имели приоритет над бинарниками [OS]{.caps} X. Что бы это сделать, откроем `~/.bash_profile` …

    vim ~/.bash_profile

… и добавим:

    # Указываем архитектуру ядра
    export ARCHFLAGS="-arch x86_64"
    # Разбираемся с бинарниками
    export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
    # Загружает .bashrc если он существует
    test -f ~/.bashrc && source ~/.bashrc

Что бы изменения вступили в силу… :

    source ~/.bash_profile

Компилятор
----------

Раньше установка подобных программ предпологала наличие Xcodе. К счастью, теперь нет нужды это делать. Сейчас нужно, имея Apple ID, пойти в [Developer Downloads](https://developer.apple.com/downloads) и скачать *Command Line Tools for Xcode*, а после чего установить.

Если же Xcode уже установлен, то, зайдя в настройки Xcode -\> Downloads, установить Command Line Tools прямо через него.

XQuartz
-------

X11 является обязательной зависимостью для некоторых инструментов. Но мы будем использовать [XQuartz](http://xquartz.macosforge.org/), это форк X11.

Homebrew
--------

Homebrew — это менеджер пакетов. Иногда тебе могут понадобится Linux-приложения — они без GUI, соответственно, работают через коммандную строку. Понятно, что в Mac App Store их нет и никогда не будет. Здесь приходит на помощь [Homebrew](https://github.com/mxcl/homebrew/). Есть и другие решения, например, [MacPorts](http://www.macports.org/), но это полный бред по сравнению с «хомяком». Занимаясь разработкой на OS X, он нужен по-любому. Так что, давайте запустим Terminal.app и установим его:

    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

Устанавливаем Homebrew, введя свой административный пароль, когда потребуется. Затем выполните следующую команду, чтобы убедиться, что не существует каких-либо потенциальных проблем с вашим окружением. Некоторые предупреждения (если таковые имеются) являются информационными…

::: {.highlight}
    brew doctor
:::

Следующая команда обновит до последней версии наш homebrew и его формулы (formulae):

::: {.highlight}
    brew update
:::

Если при выполнении “brew update” он выдал ошибку, удебитесь в привальности выставленных прав на /usr/local и вновь обновите хомяка:

::: {.highlight}
    sudo chown $USER /usr/local
    brew update
:::

Давайте установим несколько программ:

::: {.highlight}
    brew install bash-completion ssh-copy-id wget
:::

Можно запустить `brew info ssh-copy-id`, например, что бы получить информацию по пакету.

Что бы включить авто-завершение добавим несколько строк в .bash\_profile:

    # Включаем автозавершение
    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi

Только основы
-------------

Очевидно, что все это только основы. Если у вас есть заинтересованность в Python, посмотрите на — [Установка Python и Virtualenv на Mac](/kompy-i-seti/ustanovka-python-virtualenv-na-mac.html "Установка Python и Virtualenv на Mac").
