FROM python:2.7-slim AS builder

USER root

COPY requirements.txt /tmp/pip-tmp/requirements.txt

ENV VIRTUAL_ENV=/opt/venv
RUN pip install virtualenv
RUN python -m virtualenv $VIRTUAL_ENV
ENV PATH="/opt/venv/bin:$PATH"

RUN apt-get update; \
    apt-get install -y\
    libpq-dev \
    libsasl2-dev \
    libldap2-dev \
    libssl-dev \
    gcc;

RUN virtualenv $VIRTUAL_ENV
RUN pip install --upgrade pip
RUN pip install --no-compile --no-cache-dir -r /tmp/pip-tmp/requirements.txt

FROM python:2.7-slim AS base

RUN apt-get update; \
    apt-get postgresql-client; \
    apt-get install -y locales locales-all; \
    apt-get install -y libldap2-dev; \
    apt-get install -y libpq-dev; \
    apt-get install -y gettext; \
    echo "America/Manaus" > /etc/timezone; \
    dpkg-reconfigure -f noninteractive tzdata;

ENV LC_ALL=pt_BR.UTF-8
ENV LANG=pt_BR.UTF8
ENV LANGUAGE=pt_BR.UTF-8

WORKDIR /workspace

FROM base AS production

ENV PATH="/opt/venv/bin:$PATH"

COPY --from=builder /opt/venv /opt/venv

COPY . /workspace

RUN chmod +x /workspace/reset.sh
RUN chmod +x /workspace/docker-entrypoint.sh
