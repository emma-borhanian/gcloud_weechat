# Weechat for google cloud dockerfile

FROM debian:jessie

RUN apt-get update && \
    apt-get install -y apt-transport-https=1.0.9.8.3 \
                       cpanminus=1.7014-1 \
                       make=4.0-8.1 \
                       gcc=4:4.9.2-2 && \
    cpanm Encode~2.84

RUN apt-key adv --keyserver keys.gnupg.net --recv-keys 11E9DE8848F2B65222AA75B8D1820DB22A11534E && \
    echo 'deb https://weechat.org/debian jessie main' >/etc/apt/sources.list.d/weechat.list && \
    echo 'deb-src https://weechat.org/debian jessie main' >>/etc/apt/sources.list.d/weechat.list && \
    apt-get update && \
    apt-get install -y weechat-curses=1.4-1 weechat-plugins=1.4-1

EXPOSE 8001

ENV LANG C.UTF-8
ENV TERM rxvt-unicode
ENV TZ US/Pacific

CMD weechat -r "\
/set relay.network.password \"$WEECHAT_PASSWORD\";\
/set logger.file.mask \"\$plugin.\$name.log\";\
/relay add weechat 8001;\
/script install socket_notify.rb;\
/script autoload socket_notify.rb;\
"
