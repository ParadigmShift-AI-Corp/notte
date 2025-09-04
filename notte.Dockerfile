ARG PYTHON_VERSION=3.11
ARG NOTTE_VERSION=dev

# build stage
FROM python:${PYTHON_VERSION}-slim AS build

RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*

RUN pip install uv

WORKDIR /app

COPY . .

RUN uv sync --dev --all-extras

RUN bash build.sh ${NOTTE_VERSION}

# final stage
FROM us-central1-docker.pkg.dev/evaluation-deployment/agents/neurosim-base:latest

WORKDIR /app

COPY --from=build /app/dist/ ./dist/

RUN uv pip install --system dist/*.whl

# Setup entrypoint if needed, for now we just have the package installed
CMD [ "bash" ]
