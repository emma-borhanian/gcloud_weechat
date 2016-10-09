FROM debian:latest

RUN apt-get update && \
    apt-get install -y openssh-server

ADD launch-sshd launch-sshd
ADD sshd_config /etc/ssh/sshd_config

RUN chmod +x launch-sshd
RUN mkdir /var/run/sshd
RUN useradd client -m -d /home/client && \
    usermod client -p "$(cat /dev/urandom | base64 | head -c 32)" && \
    usermod -U client

EXPOSE 23

ENTRYPOINT ["./launch-sshd", "-D"]
