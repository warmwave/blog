Title:  PyEnv на OS X - Менеджер версий для python
Date: 2016-11-30 02:19
Author: azq
Category: Компы и сети
Tags: homebrew, Mac OS X, pyenv, python, Sierra
Slug: pyenv-na-os-x
Status: published

**О том как установить PyEnv и всё что для него нужно в OS X. PyEnv - это такая магическая штука которая позволяет иметь в системе несколько версий Python и легко переключаться между ними. Иногда даже автоматически)))**

Установка.
----------

С помощью уже привычного [Homebrew](/tag/homebrew) устанавливаем необходимые пакеты.

```
brew install pyenv pyenv-virtualenv pyenv-virtualenvwrapper pyenv-ccache pyenv-which-ext
```

Для того что-бы не таскать из сети одни и те же модули, их лучше всего кешировать - **pyenv-ccache**. А про [virtualenv](/tag/virtualenv) и [virtualenvwrapper](/tag/virtualenvwrapper) на страницах этого блога я уже писал.

Добавляем переменные.
---------------------

Теперь открываем ~/.bashrc или ~/.profile и добавляем:

- по просьбе горячё любимого Хомяка))):

```
# Устанавливать окружения в папку домашнего каталога(~/.pyenv)
export PYENV_ROOT=/usr/local/var/pyenv
# Или
# Устанавливать окружения в папку с pyenv(Куда его установил Homebrew), а не ~/.pyenv
# export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
```

- Для автоматической активации виртуального окружения и автозавершения добавим:

```
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi 
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
```

Пользуемся.
-----------

Теперь о том как этим пользоваться:

```
pyenv commands # Смотрим список команд
pyenv version # Узнаём активную версию Питона
3.5.0 (set by /usr/local/var/pyenv/version)
pyenv versions # Узнаём список установленных версий и окружений
  system
  2.7.10 # Версия
  2.7.10/envs/GB # Виртуальное окружение для версии 2.7.10
* 3.5.0 (set by /usr/local/var/pyenv/version)
  GB
pyenv install 3.5.2 # Устанавливаем Python 3.5.2
pyenv virtualenv 2.7.10 NewName # Создаём виртуальное окружение для Питона версии 2.7.10
pyenv global 3.5.2 # Активировать глобально
pyenv local NewName # Активируем окружение NewName
```

**Обращаю ваше внимание на очень удобную особенность: после выполнения команды **

```
pyenv local NewName
```

создаётся файл .python-version, и теперь "благодаря" ему,  когда вы в следующий раз перейдёте в эту же директорию, то виртуальное окружение NewName активируется автоматически.
