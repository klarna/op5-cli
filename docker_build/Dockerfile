FROM alpine:latest

RUN apk update
RUN apk add --update git python perl
RUN wget https://bootstrap.pypa.io/get-pip.py; python get-pip.py

WORKDIR /tmp

RUN echo -e "[http]\n sslVerify = false" > /root/.gitconfig
RUN git clone https://stash.int.klarna.net/scm/opsmon/op5-cli.git && cd op5-cli && git submodule update --init && pip install -r requirements.txt && pip install keyring && python setup.py install
RUN mkdir -p /root/.config/op5-cli
ADD ca-cert.pem .
RUN cat ca-cert.pem >> /usr/lib/python2.7/site-packages/requests/cacert.pem

ADD start.sh /tmp/
ENV op5_username $op5_username

ENTRYPOINT ["/tmp/start.sh"]
