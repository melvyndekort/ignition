#!/bin/sh

#
# TODO: This script needs to be modified for Raspberry Pi
#
exit 1


[ "$#" -ne 1 ] && echo "One parameter expected: device" && exit 1

DEVICE="$1"

(
  mkdir -p temp
  cd temp
  curl -sLO https://ignition.mdekort.nl/pihole.ign
)

docker run \
  --privileged \
  --rm \
  -v /dev:/dev \
  -v /run/udev:/run/udev \
  -v ./temp:/data \
  -w /data \
  quay.io/coreos/coreos-installer:release \
  install "$DEVICE" -i pihole.ign

rm -rf temp
