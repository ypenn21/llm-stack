ARG PYVERSION=py39
FROM baseten/truss-server-base:3.9-gpu-v0.2.4

RUN pip install --upgrade pip











COPY ./requirements.txt requirements.txt
RUN pip install -r requirements.txt




ENV APP_HOME /app
WORKDIR $APP_HOME



COPY ./server /app
COPY ./model /app/model
COPY ./config.yaml /app/config.yaml











ENV INFERENCE_SERVER_PORT 8080
CMD exec python3 /app/inference_server.py
