#!/usr/bin/env bash
set -e

# Description: PostgreSQL database for code insights data.
#
# Disk: 128GB / persistent SSD
# Network: 1Gbps
# Liveness probe: 5432/TCP
# Ports exposed to other Sourcegraph services: 5432/TCP 9187/TCP
# Ports exposed to the public internet: none
#
VOLUME="$HOME/sourcegraph-docker/codeinsights-db-disk"
./ensure-volume.sh $VOLUME 999

docker run --detach \
    --name=codeinsights-db \
    --network=sourcegraph \
    --restart=always \
    --cpus=4 \
    --memory=2g \
    -e POSTGRES_DB=postgres \
    -e POSTGRES_PASSWORD=password \
    -e POSTGRES_USER=postgres \
    -e PGDATA=/var/lib/postgresql/data/pgdata \
    -v $VOLUME:/var/lib/postgresql/data/ \
    index.docker.io/sourcegraph/codeinsights-db:4.5.0@sha256:6c38760505cffe11b3490599078f586b58ca1922bee066e45f98cd7c458ae678

# Sourcegraph requires PostgreSQL 12+. Generally newer versions are better,
# but anything 12 and higher is supported.

echo "Deployed codeinsights-db service"
