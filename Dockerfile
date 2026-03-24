# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.13


WORKDIR /app

RUN pip install --no-cache-dir pandas pyarrow sqlalchemy psycopg2-binary requests tqdm

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
ENTRYPOINT [ "/bin/bash" ]