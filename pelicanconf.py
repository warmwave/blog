#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals
from datetime import datetime

AUTHOR = 'azq'
SITENAME = 'Warmwave Blog'
SITESUBTITLE = 'Компы и сети, тела и души, шумы и звуки'
SITEURL = ''
DEFAULT_LANG = 'ru'

PATH = 'content'
OUTPUT_PATH = 'output'
DELETE_OUTPUT_DIRECTORY = True
DEFAULT_PAGINATION = 10
RELATED_POSTS_MAX = 5


TIMEZONE = 'Europe/Moscow'
CURRENTYEAR = datetime.now().strftime('%Y')



PAGE_URL = '{slug}/'
PAGE_SAVE_AS = '{slug}/index.html'
CATEGORY_URL = 'category/{slug}'
CATEGORY_SAVE_AS = 'category/{slug}/index.html'
CATEGORIES_SAVE_AS = 'categories/index.html'
TAGS_SAVE_AS = 'tags/index.html'
TAG_URL = 'tag/{slug}'
TAG_SAVE_AS = 'tag/{slug}/index.html'
AUTHOR_SAVE_AS = ''

STATIC_PATHS = ['files', 'style.css', 'uploads']

EXTRA_PATH_METADATA = {
    # 'themes/aboutwilson_my/static/': {'path': 'theme'},
    'style.css': {'path': 'style.css'},
    'files': {'path': 'files'},
    'uploads': {'path': 'uploads'},
    # 'extra/CNAME': {'path': 'CNAME'},

}

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Blogroll
LINKS = (('Pelican', 'http://getpelican.com/'),
         ('Python.org', 'http://python.org/'),
         ('Jinja2', 'http://jinja.pocoo.org/'),
         ('You can modify those links in your config file', '#'),)

# Social widget
SOCIAL = (('twitter', 'https://twitter.com/paulomiramor'),
          ('linkedin', 'http://www.linkedin.com/in/XXXXXXX'),
          ('github', 'https://github.com/EuPaulo'),)



FAVICON = '/theme/images/favicon.png'

THEME = 'themes/aboutwilson_my/'
# THEME = 'themes/mnmlist/'
# THEME = 'themes/nmnlist/'

DISPLAY_PAGES_ON_MENU = True
DISPLAY_CATEGORIES_ON_MENU = True
# DISPLAY_BREADCRUMBS = True
# DISPLAY_CATEGORY_IN_BREADCRUMBS = True
# отображение тегов
# DISPLAY_TAGS_ON_SIDEBAR = True
# показывать в облаке или списком
# DISPLAY_TAGS_INLINE = True

MENUITEMS = (
    ('Компы и сети', '/category/kompy-i-seti'),
    ('Шумы и звуки', '/category/shumy-i-zvuki'),
    ('Тела и души', '/category/tela-i-dushi'),
)

MENUITEMS2 = (
    ('ВСЁ', '/archives.html'),
    ('СКАЗАТЬ "СПАСИБО!"', '/donate.html'),
)

# PAGE_EXCLUDES = ['donate.html']
# ARTICLE_EXCLUDES = ['donate.html']

# Uncomment following line if you want document-relative URLs when developing
# RELATIVE_URLS = True
# LOAD_CONTENT_CACHE = False

# Plugins
PLUGIN_PATH = "plugins"
# PLUGINS = ['sitemap', 'neighbors', 'summary', 'related_posts', 'optimize_images', 'disqus']
# PLUGINS = ['sitemap', 'category_order', 'w3c_validate', 'optimize_images', '']
PLUGINS = ['neighbors', 'summary', 'related_posts', 'optimize_images', 'disqus_static', 'sitemap']
# disqus_static
# sitemap
# gzip_cache
# w3c_validate


# Sitemap
SITEMAP = {
    'format': 'xml',
    'priorities': {
        'articles': 0.5,
        'indexes': 0.5,
        'pages': 0.5
    },
    'changefreqs': {
        'articles': 'monthly',
        'indexes': 'daily',
        'pages': 'monthly'
    }
}

MARKDOWN = {
    'extension_configs': {
        'markdown.extensions.codehilite': {'css_class': 'highlight', 'linenums': False},
        'markdown.extensions.extra': {},
        'markdown.extensions.meta': {},
    },
    'output_format': 'html5',
}

DISQUS_SITENAME = 'blog-warmwave-ru'

DISQUS_SECRET_KEY = 'gsZU6LHPzEZXSViM0GhQ1xiGZnVdeTxiDpUBqwJI3opkkkjVtcNZcG6xheggrSwk'
DISQUS_PUBLIC_KEY = 'S6SsIA4Uq86sqe3sIvcjvOqcGi3lM9sHPkz2tiK3Wy3mick3zIcw3T63OXjBnhpV'

# GOOGLE_ANALYTICS = 'UA-******your_code'
# GOOGLE_ANALYTICS_DOMAIN = 'http://webquant.ru/'


