Title:  Python3 и virtualenv в Sierra. Установка и настройка
Date: 2016-10-31 16:12
Author: azq
Category: Компы и сети
Tags: homebrew, Mac OS X, python, Sierra, virtualenv, virtualenvwrapper
Slug: python3-and-virtualenv-in-sierra
Status: published

Это обновлённый материал о настройке Python3 и virtualenv по мотивам двух предыдущих: "[Настройка Python и Django в Mac](http://blog.warmwave.ru/kompy-i-seti/nastrojjka-python-django-v-mac.html)" и "[Virtualenv на Mac OS X](http://blog.warmwave.ru/kompy-i-seti/ustanovka-python-virtualenv-na-mac.html)". Всё описанное тут актуально для OS X Sierra. Если вам не понятен материал, задавайте вопросы в комментариях или же обратитесь к ссылкам выше.

Подготовка. Установка Homebrew и Python3
----------------------------------------

Первое, что нужно сделать - установить Homebrew:

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Итак, далее... Устанавливаем **python**, ставим сразу 3ю версию.

```
brew install python3 --with-brewed-openssl
```

Проверить версию питона можно командой

```
# Для коробочного питона
python -V # Узнать версию
where python # Место расположения
# Для только что установленного питона 
python3 -V # Узнать версию
where python3 # Место расположения
```

Установка и настройка virtualenv
--------------------------------

Далее устанавливаем два расширения для виртуального окружения. Это нужно для того, чтобы для каждого проекта подтягивались только зависимости проекта.

```
pip3 install virtualenv virtualenvwrapper
```

Вставим несколько строк в ~/.bashrc:

```
# Добавляем переменную - то где установлен Python
if [ -d /usr/local/lib/python3.5/site-packages ]; then
export PYTHONPATH=/usr/local/lib/python3.5/site-packages:$PYTHONPATH
fi

# Определяем местоположение virtualenvwrapper
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
export VENVWRAP=/usr/local/bin/virtualenvwrapper.sh
fi

if [ ! -z $VENVWRAP ]; then
 # virtualenvwrapper
 # убедимся что папка существует
 [ -d $HOME/sites/env ] || mkdir -p $HOME/sites/env
 export WORKON_HOME=$HOME/sites/env
 source $VENVWRAP
 
 # virtualenv
 export VIRTUALENV_USE_DISTRIBUTE=true
 
 # pip
 export PIP_VIRTUALENV_BASE=$WORKON_HOME
 export PIP_REQUIRE_VIRTUALENV=true # pip должен выполняться только если активирован virtualenv
 export PIP_RESPECT_VIRTUALENV=true
 export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache # Кешируем пакеты чтобы избежать повторной загрузки
fi
```

Создаём файл ~/sites/env/postactivate и добавляем в него следующее:

```
proj_name=${VIRTUAL_ENV##*/}

# Добавляем для активного проекта PYTHONPATH
if [ -d ~/sites/env/$proj_name/lib/python3.5/site-packages ]; then
add2virtualenv ~/sites/env/$proj_name/lib/python3.5/site-packages
fi

# делаем "cd" в виртуальное окружение
if [ -d ~/sites/env/$proj_name/project ]; then
cd ~/sites/env/$proj_name/project
else
cd ~/sites/env/$proj_name
fi
```

Использование virtualenv
------------------------

После этого остаётся перезагрузить bash-окружение

```
source ~/.bashrc
```

В результате мы можем следующее:

-   **Создать виртуальную среду с именем "test" в ~/sites/env/**

    ```
    mkvirtualenv test
    ```

-   **Активировать созданную среду**

    ```
    workon test
    ```

-   **Перейти в каталог активной среды**

    ```
    cdvirtualenv
    ```

Это всё, что нужно сделать для удобной и гибкой работы с Python. Напоминаю, что если у вас возникли вопросы, то задавайте их в комментариях ниже.
