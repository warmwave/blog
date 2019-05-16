Title:  [Решено] - Ошибки при установке версий python через pyenv.
Date: 2017-11-26 18:40
Author: azq
Category: Компы и сети
Tags: High Sierra, homebrew, pyenv, python, Sierra
Slug: resheno-the-python-ssl-extension-was-not-compiled-missing-the-openssl-lib
Status: published

При установке ещё одной версии Python вылезла ошибка: **The Python ssl extension was not compiled. Missing the OpenSSL lib?**

Гугление привело к решению:

```
brew uninstall openssl && brew install openssl && CFLAGS="-I$(brew --prefix openssl)/include" LDFLAGS="-L$(brew --prefix openssl)/lib"
```

но в результате brew предложил удалить все зависимые пакеты, что не есть хорошо. В такой ситуации нужна опция *-ignore-dependencies.*

```
brew uninstall --ignore-dependencies openssl && brew install openssl && CFLAGS="-I$(brew --prefix openssl)/include" LDFLAGS="-L$(brew --prefix openssl)/lib"
```

Но это не решило проблему. Гуглим дальше...

```
CFLAGS="-I$(brew --prefix openssl)/include"   
LDFLAGS="-L$(brew --prefix openssl)/lib"   
pyenv install -v 3.7.0a1
```

Терминал выплюнул что-то похожее на предыдущие попытки, но

```
~ pyenv versions                                                                                                                                                        
* system (set by /usr/local/var/pyenv/version)
  3.5.2
  3.7.0a1
```

Другие варианты ошибок
----------------------

Так же вполне возможно, особенно если система свежая, понадобится установить Xcode:

```
xcode-select --install
```
