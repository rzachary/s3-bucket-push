FROM python:3.8-alpine

LABEL "com.github.ations.name"="S3 Blog Push"
LABEL "com.github.actions.description"="Push blog contents to an S3 Bucket"
LABEL "com.github.actions.icon"="refresh-ccw"
LABEL "com.github.action.color"="yellow"

LABEL version="0.0.1"
LABEL repository=""
LABEL homepage="rickeyzachary.com"
LABEL maintainer="Rickey Zachary <rzachary@rickeyzachary.com>"

ENV AWSCLI_VERSION='1.18.39'

RUN pip install --quiet --no-cache-dir awscli==${AWSCLI_VERSION}

ADD entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]
