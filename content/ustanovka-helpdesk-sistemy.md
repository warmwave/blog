Title: Установка HelpDesk-системы на CentOS		
Date: 2016-11-29 23:01
Author: azq
Category: Без рубрики
Tags: CentOS, HelpDesk, MongoDB, Node.js, React.js
Slug: ustanovka-helpdesk-sistemy
Status: draft

**В этой статье устанавливаем тикет-систему, которая работает на Node.js и MongoDB, фронтэнд - React.js**

<!--more-->

Всё началось с заказа на [FL.ru](https://www.fl.ru/projects/?ref=26908). Заказчик хотел иметь HelpDesk-систему (<https://github.com/SibirixScrum/HelpDesk>) и возможность получать и обрабатывать тикеты от своих клиентов. Так же у клиента оказался сервер на CentOS которым он управлял при помощи панели VestaCP, на нём и нужно было развернуть эту систему.

Давайте условимся что домен на котором будет висеть система - domain.com. Он уже добавлен через панель управления и делегирован. Так же в системе уже стоит nodejs и mongo.

 

Из плюсов системы могу отметить:

-   **Красивый интерфейс**
-   **Простота установки и администрирования**
-   **Автоматическое создание тикета при получении email**

 

``` {.lang:default .decode:true}
server {
    listen      89.108.76.255:80;
    server_name partner.unisolar.ru www.partner.unisolar.ru partner-unisolar-ru.unisolar.ru;
    error_log  /var/log/httpd/domains/partner.unisolar.ru.error.log error;

    location / {
        proxy_pass      http://89.108.76.255:8080;
        location ~* ^.+\.(jpeg|jpg|png|gif|bmp|ico|svg|tif|tiff|css|js|htm|html|ttf|otf|webp|woff|txt|csv|rtf|doc|docx|xls|xlsx|ppt|pptx|odf|odp|ods|odt|pdf|psd|ai|eot|eps|ps|zip|tar|tgz|gz|rar|bz2|7z|aac|m4a|mp3|mp4|ogg|wav|wma|3gp|avi|flv|m4v|mkv|mov|)$ {
            root           /home/admin/web/partner.unisolar.ru/public_html;
            access_log     /var/log/httpd/domains/partner.unisolar.ru.log combined;
            access_log     /var/log/httpd/domains/partner.unisolar.ru.bytes bytes;
            expires        max;
            try_files      $uri @fallback;
        }
    }

    location /error/ {
        alias   /home/admin/web/partner.unisolar.ru/document_errors/;
    }

    location @fallback {
        proxy_pass      http://89.108.76.255:8080;
    }

    location ~ /\.ht    {return 404;}
    location ~ /\.svn/  {return 404;}
    location ~ /\.git/  {return 404;}
    location ~ /\.hg/   {return 404;}
    location ~ /\.bzr/  {return 404;}

    include /home/admin/conf/web/nginx.partner.unisolar.ru.conf*;
}

---------------------------------------------

server {
    listen      89.108.76.255:80;
    server_name partner.unisolar.ru www.partner.unisolar.ru partner-unisolar-ru.unisolar.ru;
    error_log  /var/log/httpd/domains/partner.unisolar.ru.error.log error;

    location / {
        proxy_pass      http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        root /root/helpdesk/public/;
        location ~* ^.+\.(jpeg|jpg|png|gif|bmp|ico|svg|tif|tiff|css|js|htm|html|ttf|otf|webp|woff|txt|csv|rtf|doc|docx|xls|xlsx|ppt|pptx|odf|odp|ods|odt|pdf|psd|ai|eot|eps|ps|zip|tar|tgz|gz|rar|bz2|7z|aac|m4a|mp3|mp4|ogg|wav|wma|3gp|avi|flv|m4v|mkv|mov|)$ {
            root           /home/admin/web/partner.unisolar.ru/public_html;
            access_log     /var/log/httpd/domains/partner.unisolar.ru.log combined;
            access_log     /var/log/httpd/domains/partner.unisolar.ru.bytes bytes;
            #expires        max;
            try_files      $uri @fallback;
        }
    }

    location /error/ {
        alias   /home/admin/web/partner.unisolar.ru/document_errors/;
    }

    location @fallback {
        proxy_pass      http://localhost:3000;
    }

    location ~ /\.ht    {return 404;}
    location ~ /\.svn/  {return 404;}
    location ~ /\.git/  {return 404;}
    location ~ /\.hg/   {return 404;}
    location ~ /\.bzr/  {return 404;}

    include /home/admin/conf/web/nginx.partner.unisolar.ru.conf*;
}
```

 
