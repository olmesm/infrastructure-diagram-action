FROM python:3.10-slim

WORKDIR /usr/src/app

COPY setup.sh ./
RUN bash setup.sh
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
