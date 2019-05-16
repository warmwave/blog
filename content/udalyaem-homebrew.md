Title:  Удаляем Homebrew
Date: 2014-08-22 14:33
Author: azq
Category: Компы и сети
Tags: homebrew, Mac OS X, Удаляем Homebrew
Slug: udalyaem-homebrew
Status: published

Случилось так что нужно удалить Homebrew, окей. Решить задачу, как всегда, можно несколькими способами.

<!--more-->Первый способ. Для этого нужно выполнить в консоли:

    cd `brew --prefix`
    rm -rf Cellar
    brew prune
    rm `git ls-files`
    rm -r Library/Homebrew Library/Aliases Library/Formula Library/Contributions
    rm -rf .git
    rm -rf ~/Library/Caches/Homebrew

Второй способ. Так же существует скрипт, который так и называется - «[uninstall\_homebrew.sh](https://gist.github.com/mxcl/1173223/download#)»

```
#!/bin/sh
# Just copy and paste the lines below (all at once, it won't work line by line!)
# MAKE SURE YOU ARE HAPPY WITH WHAT IT DOES FIRST! THERE IS NO WARRANTY!

function abort {
  echo "$1"
  exit 1
}

set -e

/usr/bin/which -s git || abort "brew install git first!"
test -d /usr/local/.git || abort "brew update first!"

cd `brew --prefix`
git checkout master
git ls-files -z | pbcopy
rm -rf Cellar
bin/brew prune
pbpaste | xargs -0 rm
rm -r Library/Homebrew Library/Aliases Library/Formula Library/Contributions 
test -d Library/LinkedKegs && rm -r Library/LinkedKegs
rmdir -p bin Library share/man/man1 2> /dev/null
rm -rf .git
rm -rf ~/Library/Caches/Homebrew
rm -rf ~/Library/Logs/Homebrew
rm -rf /Library/Caches/Homebrew
```

 
