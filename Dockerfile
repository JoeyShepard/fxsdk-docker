FROM debian:stable-slim
RUN apt update 
RUN apt install -y expect
RUN apt install -y curl git python3 build-essential cmake pkg-config 

RUN useradd -ms /bin/bash fxsdk
USER fxsdk
RUN curl "https://git.planet-casio.com/Lephenixnoir/GiteaPC/raw/branch/master/install.sh" -o /tmp/giteapc-install.sh
RUN expect -c 'set timeout -1; spawn bash /tmp/giteapc-install.sh; expect "Is that okay (Y/n)?"; send "Y\r"; expect "Type \"-\" to skip setting the PATH entirely."; send "\r"; expect EOF;'

USER root
RUN apt install -y python3-pil libusb-1.0-0-dev libudev-dev libsdl2-dev libpng-dev libncurses-dev
RUN apt install -y libudisks2-dev libglib2.0-dev
RUN apt install -y libmpfr-dev libmpc-dev libgmp-dev libppl-dev flex texinfo

USER fxsdk
ENV PATH="$PATH:/home/fxsdk/.local/bin"
RUN giteapc install -y Lephenixnoir/fxsdk Lephenixnoir/sh-elf-binutils Lephenixnoir/sh-elf-gcc
RUN giteapc install -y Lephenixnoir/sh-elf-gdb
RUN giteapc install -y Lephenixnoir/OpenLibm Vhex-Kernel-Core/fxlibc
RUN giteapc install -y Lephenixnoir/sh-elf-gcc
RUN giteapc install -y Lephenixnoir/gint

RUN rm -rf /home/fxsdk/.local/share/giteapc/Lephenixnoir/sh-elf-gcc/build/
RUN rm -rf /home/fxsdk/.local/share/giteapc/Lephenixnoir/sh-elf-gdb/build/
RUN rm -rf /home/fxsdk/.local/share/giteapc/Lephenixnoir/sh-elf-binutils/build/
