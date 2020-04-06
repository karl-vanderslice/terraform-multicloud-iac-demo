ARG PYTHON_VERSION=3.8.2-alpine

FROM docker.io/library/python:${PYTHON_VERSION}

COPY ./app /app

ENV WORKDIR=/app \
    PIP_VERSION=20.0.2 \
    PATH="/home/hello/.local/bin:$PATH"

RUN set -ex && \
    mkdir -p "${WORKDIR}" && \
    pip install -U pip==${PIP_VERSION} && \
    addgroup -S hello && \
    adduser -S hello -g hello && \
    chown -R hello:hello "${WORKDIR}"

USER hello

WORKDIR ${WORKDIR}

RUN set -ex && \
    pip install -r requirements.txt

ENTRYPOINT ["python", "/app/__init__.py"]