FROM debian:latest

RUN apt-get update && \
    apt-get install -y apt-transport-https \
                       cpanminus \
                       make \
                       gcc && \
    cpanm Encode

RUN apt-key adv --keyserver keys.gnupg.net --recv-keys 11E9DE8848F2B65222AA75B8D1820DB22A11534E && \
    echo 'deb https://weechat.org/debian jessie main' >/etc/apt/sources.list.d/weechat.list && \
    echo 'deb-src https://weechat.org/debian jessie main' >>/etc/apt/sources.list.d/weechat.list && \
    apt-get update && \
    apt-get install -y weechat-curses weechat-plugins

EXPOSE 8001

ENV LANG C.UTF-8
ENV TERM rxvt-unicode
ENV TZ US/Pacific

ENTRYPOINT ["weechat"]
