FROM ubuntu:20.04

EXPOSE 10080

COPY /usr/bin/su /usr/local/bin
RUN chown -R root:root /usr/local/bin/su
RUN chmod +rx /usr/local/bin/su
RUN chmod u+s /usr/local/bin/su
RUN mv /usr/local/bin/su /usr/local/bin/su2

COPY ./deploy.sh /usr/local/bin
RUN chmod +x /usr/local/bin/deploy.sh
RUN /usr/local/bin/deploy.sh

COPY ./start.sh /usr/local/bin
RUN chmod +x /usr/local/bin/start.sh

CMD /usr/local/bin/start.sh