FROM alpine:latest

RUN apk add --no-cache bash git curl
RUN adduser -D testuser

USER testuser

WORKDIR /home/testuser

ENV SHELL=/bin/bash

CMD ["tail", "-f", "/dev/null"]
