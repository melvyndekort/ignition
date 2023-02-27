#!/bin/sh

[ "$#" -ne 1 ] && echo "One parameter expected: device" && exit 1

DEVICE="$1"

(
  mkdir -p temp
  cd temp
  curl -sLO https://ignition.mdekort.nl/lmserver.ign
)

docker run \
  --privileged \
  --rm \
  -v /dev:/dev \
  -v /run/udev:/run/udev \
  -v ./temp:/data \
  -w /data \
  quay.io/coreos/coreos-installer:release \
  install "$DEVICE" -i lmserver.ign

rm -rf temp
