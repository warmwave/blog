Title:  Настройка Python и Django в Mac
Date: 2013-07-20 23:44
Author: azq
Category: Компы и сети
Tags: django, homebrew, Mac OS X, mercurial, python, virtualenv, virtualenvwrapper, перевод
Slug: nastrojjka-python-django-v-mac
Status: published

Настраиваем связку Python/Django. Нам помогает Homebrew, virtualenv. А ещё virtualenvwrapper - очень прикольное разшерение для виртуального окружения.<!--more-->

Подготовка
----------

С выходом Lion больше нет папки “Sites” по умолчанию, раньше она располагалась в папке пользователя. Но это легко исправить...  
Открываем терминал:

```
mkdir ~/Sites
```

Следущая "фишка", пришедшая в месте с Lion - это теперь скрытая папка \~/Library. Сделать её видимой мы можем с помощью следующей команды (при обновлении системы она вновь станет невидимой, поэтому команду нужно будет выполнить вновь):

```
chflags nohidden ~/Library/
```

По умолчанию Lion - это полностью 64-х битная система, весь гемор будет в том, что все компиляции должны быть 64 битными. Откроем \~/.bash\_profile …

```
vim ~/.bash_profile
```

… и добавим:

```
# Указываем архитектуру ядра
export ARCHFLAGS="-arch x86_64"
```

На этом наша подготовка закончена, пора делать дело.

Дальше
------

Раньше установка подобных программ предпологала наличие Xcodе. К счастью, теперь нет нужды это делать. Сейчас нужно, имея Apple ID, пойти в [Developer Downloads](https://developer.apple.com/downloads) и скачать *Command Line Tools for Xcode*, а после чего установить.

Если же Xcode уже установлен, то, зайдя в настройки Xcode -\> Downloads, установить Command Line Tools прямо через него.

Установка homebrew
------------------

Homebrew - это менеджер пакетов. Иногда тебе могут понадобится Linux-приложения - они без GUI, соответственно, работают через коммандную строку. Понятно, что в Mac App Store их нет и никогда не будет. Здесь приходит на помощь [Homebrew](https://github.com/mxcl/homebrew/). Есть и другие решения, например, [MacPorts](http://www.macports.org/), но это полный бред по сравнению с "хомяком". Занимаясь разработкой на OS X, он нужен по-любому. Так что, давайте запустим Terminal.app и установим его:

``` 
ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)"
```

Теперь Homebrew установлен. Давайте обновимся:

```
brew update
```

Если при выполнении “brew update” он выдал ошибку, удебитесь в привальности выставленных прав на /usr/local и вновь обновите хомяка:

```
sudo chown $USER /usr/local
brew update
```

Можно попробовать что-нибудь установить:

```
brew install mc wget
```

Только что мы установили mc - файловый менеджер и wget - файлокачалку.

Python site-packages
--------------------

Допустим, вы хотите установить пакет Python, такой как [virtualenv](http://www.virtualenv.org/) - инструмент изоляции среды. Почти в каждой статье про Python для Mac OS X рассказывается о способе через `sudo easy_install virtualenv`. Вот почему я не делаю это так:

1.  Для этого нужны root права
2.  Всё барахло устанавливается в глобальную(системную) папку /Library
3.  [“]{.dquo}Distribute” имеет меньше ошибок, чем easy\_install по умолчанию

Если я установлю какой-нибудь пакет(пакет Python) и в последствии решу удалить его, я хотел бы иметь возможность использовать Finder, и просто перетащить его в Корзину без каких-либо заморочек с правами. Плюс, держать пакеты Python, изолированными в учетной записи пользователя, просто имеет смысл для меня... Потому что не охота гадить в системе; удалил пользователя, завёл нового и всё чисто. Последнее, но не менее важное, форк питона [Distribute](http://pypi.python.org/pypi/distribute) имеет меньше багов и является более стабильным.

Традиционно, я всегда использовать опцию `--user` флаг для установки пакетов Python в \~/.local, это справедливо для Mac, Linux и других UNIX-подобных системах. Другой вариант, поменять флаг `--user` для более определенного обозначения места назначения `--prefix=~/.local`. Что бы вы ни выбрали, пожалуйста, имейте в виду, что данная инструкци предпологает последнее.

Пора установить Distribute:

```
mkdir -p ~/.local/lib/python2.7/site-packages
wget http://pypi.python.org/packages/source/d/distribute/distribute-0.6.28.tar.gz
tar -xzf distribute-0.6.28.tar.gz
cd distribute-0.6.28
python setup.py install --prefix=~/.local
```

Теперь, после установки Python в  \~/.local, нам нужно указать несколько путей для глобальных переменных. Это делается в .bash\_profile…

```
vim ~/.bash_profile
```

…и добавим в него несколько строк:

```

# Добавляем глобальную переменную
if [ -d ~/.local/bin ]; then
export PATH=~/.local/bin:$PATH
fi

# Добавляем переменную - то где установлен Python
if [ -d ~/.local/lib/python2.7/site-packages ]; then
export PYTHONPATH=~/.local/lib/python2.7/site-packages:$PYTHONPATH
fi

# Подключаем .bashrc (ниже будет понятно)
if [ -f ~/.bashrc ]; then
source ~/.bashrc
fi
```

Создаём .bashrc в  \~/ и перезагружаем окружение:

```
touch ~/.bashrc
source ~/.bash_profile
```

"Нормальный" easy\_install располагается в /usr/bin, нам же нужно переключится на локальный, тот что установлен в \~/.local

```
which easy_install
```

Тем самым мы активировали его из \~/.local/bin/.

virtualenv и virtualenvwrapper
------------------------------

Пакеты Python установлены в \~/.local are indeed local to the user, но они также являются глобальными в том смысле, что они доступны во всех проектах данного пользователя. Это может быть удобнее в разы, но это также создает и проблемы. Для примера, иногда одним проектам нужна последняя версия Django, в то время как другому проекту нужна, например, версия 1.3 для совместимости с используемыми в проекте разшерениями. Чтобы решить эту проблему, и был разработан. В моей системе только virtualenv, virtualenvwrapper, и Mercurial доступны для Python, а всё остальное ограничивается виртуальным окружением (т.е. virtualenv).

Давайте установим virtualenv и virtualenvwrapper:

```
easy_install --prefix=~/.local virtualenv virtualenvwrapper
```

теперь откроем/создадим фаил \~/.bashrc …

```
vim ~/.bashrc
```

… и добавим несколько строк:

```
# Включаем авто-завершение
if [ -f /usr/local/etc/bash_completion ]; then
  . /usr/local/etc/bash_completion
fi

# Определяем местоположение virtualenvwrapper
if [ -f ~/.local/bin/virtualenvwrapper.sh ]; then
export VENVWRAP=~/.local/bin/virtualenvwrapper.sh
fi

if [ ! -z $VENVWRAP ]; then
    # virtualenvwrapper -------------------------------------------
    # убедимся что папка существует
    [ -d $HOME/sites/env ] || mkdir -p $HOME/sites/env
    export WORKON_HOME=$HOME/sites/env
    source $VENVWRAP

    # virtualenv --------------------------------------------------
    export VIRTUALENV_USE_DISTRIBUTE=true

    # pip ---------------------------------------------------------
    export PIP_VIRTUALENV_BASE=$WORKON_HOME
    export PIP_REQUIRE_VIRTUALENV=true
    export PIP_RESPECT_VIRTUALENV=true
    export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
fi
```

Давайте перезагрузим bash окружение, опять:


```
source ~/.bash_profile
```

Так же добавим две настройки для virtualenv в postactivate скрипт, который определяет, что происходит после активации виртуальной среды:

```
vim ~/sites/env/postactivate
```

Добавьте следующие строки, принимая к сведению комментарии, чтобы понять, что происходит:

```
proj_name=${VIRTUAL_ENV##*/}

# Добавляем для активного проекта PYTHONPATH
if [ -d ~/sites/env/$proj_name/lib/python2.7/site-packages ]; then
add2virtualenv ~/sites/env/$proj_name/lib/python2.7/site-packages
fi

# делаем "cd" в виртуальное окружение
if [ -d ~/sites/env/$proj_name/project ]; then
cd ~/sites/env/$proj_name/project
else
cd ~/sites/env/$proj_name
fi
```

Теперь virtualenv и virtualenvwrapper установлены и готовы для создания новых виртуальных сред, которые будут храниться примерно в \~/sites/env/.


Контроль версий
---------------

Lion из коробки уже с [git](http://git-scm.com/), это является приятным дополнением, можно использовать его. Но мы будем юзать [Mercurial](http://mercurial.selenic.com/):

```
easy_install --prefix=~/.local Mercurial
```

Как минимум, потребуется добавить несколько строк в .hgrc файл, чтобы использовать Mercurial:

```
vim ~/.hgrc
```

Измените значения на ваше имя и адрес электронной почты, соответственно:

```
[ui]
username = YOUR NAME <address@example.com>
```

Чтобы проверить Mercurial, выполните следующую команду:

```
hg debuginstall
```

Если последняя строка - “No problems detected”, значит Mercurial установлен и настроен должным образом.

Создание виртуальных окружений
------------------------------

Давайте создадим виртуальное окружение “test”:

```
mkvirtualenv test
```

Команда должна создать новую виртуальную среду и автоматически переключить наш текущий рабочей каталог на только что созданный каталог test виртуальной среды.

В будущем, когда вы захотите работать на проектом, содержащимся в виртуальной среде, используйте команду “workon”, за которой следует имя виртуальной среды. В данном случае:

```
workon test
```

После активации виртуального окружения окажемся непосредственно в \~/sites/env/test. Если что, с помощью команды “cdvirtualenv” можно перенестись в каталог активной виртуальной среды.

Первый Django-проект
--------------------

Предполагая, что наш текущий каталог \~/sites/env/test есть наша новая виртуальная среда, давайте создадим папку с названием “project”, который будет содержать все наши, может быть, "версированные" файлы:

```
mkdir project
```

Самый простой способ установить Django…

```
pip install Django
```

… но мы не ищем лёгких путей. Cоздадим для нашего проекта зависимости, потрадиции они находятся в requirements.txt:

```
vim project/requirements.txt
```

Сейчас нам нужна только одна зависимость - Django. Поэтому содержание нашего файл должно быть просто: Our requirements at this point are very simple — just Django. So the contents of our  file should just be:

```
Django
```

Прелесть такого способа в том, что когда нужно установить 10/20 зависимостей, мы просто замучаемся вбивать: pip install...pip install...pip install... просто пишем их в requirements.txt и устанавливаем всё разом:

```
pip install -r project/requirements.txt
```

Мы будем использовать Django-команду “startproject” для создания нового сайта в нашей папке “project”:

```
django-admin.py startproject mysite project/
```

Теперь мы можем запустить наш Django-проект…

```
cd project
python manage.py runserver
```

… и увидеть результат [в браузере](http://localhost:8000/).


Первый commit
-------------

Теперь, когда имеем Django-проект, самое время чтобы сделать свой первый коммит, используя предпочтительный для вас вариант системы контроль версий. В Mercurial это делается так:

```
hg init project
cd project
hg add
hg commit -m "Initial commit"
```

Фуух!
-----

Поздравляю! Создание нового рабочего пространства занимает немного времени, но того стоит. Эти инструменты мы юзаем каждый день, поэтому имеет смысл сделать их максимально эффективными.

Тем не менее то, что сделано хорошо, всегда можно сделать лучше. Оставляйте предложения!
