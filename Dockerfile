# Generated from Dockerfile.template


FROM ghcr.io/olmesm/infrastructure-diagram-action:1.1.0

WORKDIR /usr/src/app

COPY src/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
