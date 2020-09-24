FROM python:3.8.5-alpine3.12

WORKDIR /
COPY ./ld4pman-api-tester-GET.py /locustfile.py
RUN sed -i s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g /etc/apk/repositories \
    && apk add --no-cache --virtual .build-deps \
        gcc \
        make \
        linux-headers \
        python3-dev \
        alpine-sdk \
        libffi-dev \
    && pip install -i https://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com locust \
    && apk del .build-deps

EXPOSE 8089
#CMD ["uvicorn", "ldapman.main:app", "--host", "0.0.0.0", "--log-config", "logging.ini"]
ENTRYPOINT ["locust", "-f", "/locustfile.py"]