#!/bin/sh

CONTAINER_IMAGE=${CONTAINER_IMAGE:-gadget-weatherchip}

case "$1" in
    build)
        docker build --no-cache=true -t "${CONTAINER_IMAGE}" .
        ;;
    tag)
        docker tag gadget-weatherchip xtacocorex/gadget-weatherchip
        ;;
    push)
        docker push xtacocorex/gadget-weatherchip
        ;;
    all)
        echo "BUILDING"
        docker build --no-cache=true -t "${CONTAINER_IMAGE}" .
        echo "TAGGING"
        docker tag gadget-weatherchip xtacocorex/gadget-weatherchip
        echo "PUSHING"
        docker push xtacocorex/gadget-weatherchip
        ;;
    remove-tags)
        docker rmi `docker images | grep gadget-weatherchip | grep "<none>" | tr -s " " | cut -d " " -f 3`
        ;;
esac
