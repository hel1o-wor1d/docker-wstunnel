FROM ubuntu:20.04

EXPOSE 10080

COPY ./deploy.sh /usr/local/bin
RUN chmod +x /usr/local/bin/deploy.sh
RUN /usr/local/bin/deploy.sh

COPY ./start.sh /usr/local/bin
RUN chmod +x /usr/local/bin/start.sh

CMD /usr/local/bin/start.sh