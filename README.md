## Web Development Tool

### はじめに
本ツールはRuby 2.2.4とPostgreSQL 9.5.3によるRuby on Rails開発用ツールです。

### 同梱しているソフトウェア
* Ruby 2.2.4
* PostgreSQL 9.5.3
* Nginx

### 使い方
```
$ cd ~
$ git clone https://github.com/tomohitoy/webdev.git
$ mkdir ~/.ssh
$ cd .ssh
$ ssh-keygen -t rsa -b 4096 -C "t07840ty@gmail.com"
$ cp id_rsa.pub ~/webdev/
$ cd ~/datasci
$ docker-compose build
$ docker-compose pull
$ docker-compose up -d
$ ssh tomohitoy@0.0.0.0 -p 2222 -i ~/.ssh/id_rsa
```

