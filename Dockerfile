FROM python:3.7-alpine
MAINTAINER sosol-ent

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
RUN apk add --update --no-cache postgresql-client jpeg-dev
RUN apk add --update --no-cache --virtual .tmp-build-deps \
      gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev
RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps

RUN mkdir /app
WORKDIR /app
COPY ./app /app
# make a place for storing media and static files for django
RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static
# Add user and give user correct permissions
RUN adduser -D user
# Make user owner of /vol/ and its contents
RUN chown -R user:user /vol/
# let Owner:7=rwx Group:5=r-x World:r-x
RUN chmod -R 755 /vol/web
USER user