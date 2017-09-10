# docker run -it --device /dev/i2c-0 --device /dev/i2c-1 --device /dev/i2c-2 --net=host --cap-add=SYS_RAWIO wxchip_391d619a-1b4d-4bdc-9ce3-edef9db6f2f4-img

FROM xtacocorex/gadget-chip-dt-overlays as build

# BASE OFF THE DEPRECIATED ALPINE AS WE NEED THE EDGE
FROM armhf/alpine:edge

COPY --from=build /lib/firmware/nextthingco /lib/firmware/nextthingco

RUN apk update --no-cache && \
    apk add --no-cache make && \
    apk add --no-cache gcc && \
    apk add --no-cache g++ && \
    apk add --no-cache flex && \
    apk add --no-cache bison && \
    apk add --no-cache build-base && \
    apk add --no-cache linux-headers && \
    apk add --no-cache git && \
    # DOWNLOAD PYTHON AND TOOLS FOR INSTALLING LIBRARIES
    apk add --no-cache python-dev && \
    apk add --no-cache py-setuptools && \
    # DOWNLOAD THE LATEST CHIP_IO SOURCE CODE
    git clone https://github.com/xtacocorex/CHIP_IO.git && \
    # INSTALL THE CHIP_IO LIBRARY FROM THE PROPER DIRECTORY
    cd CHIP_IO && \
    python setup.py install && \
    cd ../ && \
    rm -rf CHIP_IO && \
    # ADAFRUIT PURE PYTHON I2C - FORDSFORDS VERSION
    git clone https://github.com/fordsfords/Adafruit_Python_PureIO.git && \
    cd Adafruit_Python_PureIO && \
    python setup.py install && \
    cd ../ && \
    rm -rf Adafruit_Python_PureIO && \
    # ADAFRUIT_GPIO INSTALL
    git clone --depth=1 https://github.com/xtacocorex/Adafruit_Python_GPIO.git && \
    cd Adafruit_Python_GPIO && \
    python setup.py install && \
    cd ../ && \
    rm -rf Adafruit_Python_GPIO && \
    # ADAFRUIT ADS1X15 LIBARY
    git clone https://github.com/adafruit/Adafruit_Python_ADS1x15.git && \
    cd Adafruit_Python_ADS1x15 && \
    python setup.py install && \
    cd .. && \
    rm -rf Adafruit_Python_ADS1x15 && \
    # ADAFRUIT BMP180 LIBRARY
    git clone https://github.com/adafruit/Adafruit_Python_BMP.git && \
    cd Adafruit_Python_BMP && \
    python setup.py install && \
    cd .. && \
    rm -rf Adafruit_Python_BMP && \
    # XTACOCOREX'S AM2315 LIBRARY
    git clone https://github.com/xtacocorex/Simple_AM2315.git && \
    cd Simple_AM2315 && \
    python setup.py install && \
    cd .. && \
    rm -rf Simple_AM2315 && \
    # ADAFRUIT IO
    git clone https://github.com/adafruit/io-client-python.git && \
    cd io-client-python && \
    python setup.py install && \
    cd .. && \
    rm -rf io-client-python && \
    # WEATHER CHIP
    git clone https://github.com/xtacocorex/weather-chip.git && \
    cd weather-chip && \
    cp ./wxchip.py /wxchip.py && \
    cd .. && \
    rm -rf weather-chip && \
    # REMOVE BUILD TOOLS, WHICH ARE NO LONGER NEEDED AFTER INSTALLATION
    apk del make && \
    apk del gcc && \
    apk del g++ && \
    apk del flex && \
    apk del bison && \
    apk del build-base && \
    apk del linux-headers && \
    apk del git && \
    apk del python-dev && \
    apk del py2-pip && \
    # REMOVE CACHE
    rm -rf /var/cache/apk/*

# ADD IN THE WXCHIP.CFG
ADD wxchip.cfg /etc/

# ENTRYPOINT
ENTRYPOINT echo "WX CHIP IS STARTING" && \
    python wxchip.py

