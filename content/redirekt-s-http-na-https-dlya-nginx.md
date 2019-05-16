Title:  Редирект с http на https для nginx
Date: 2014-10-09 09:36
Author: azq
Category: Компы и сети
Tags: nginx
Slug: redirekt-s-http-na-https-dlya-nginx
Status: published

Как-то встала задача - редирект с http на https. Задача решается просто, просто добавлением нескольких строк в директиву location / {}<!--more-->

```
if ( $scheme = "http" ) {
 rewrite ^/(.*)$ https://$host/$1 permanent;
}
```

теперь при заходе на http://domain.com будет происходить редирект на https://domain.com
