ARG PYTHON_VERSION=3.11
# build stage
FROM python:${PYTHON_VERSION}-slim as build

RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*

RUN pip install uv

WORKDIR /app

COPY . .

RUN uv sync --dev --all-extras

RUN bash build.sh 0.0.1

# final stage
FROM python:${PYTHON_VERSION}-slim

WORKDIR /app

COPY --from=build /app/dist/notte-0.0.1-py3-none-any.whl .

RUN pip install notte-0.0.1-py3-none-any.whl

# Setup entrypoint if needed, for now we just have the package installed
CMD [ "bash" ]
