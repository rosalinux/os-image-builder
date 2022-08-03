FROM openmandriva/4.2

RUN dnf clean all
RUN dnf clean packages
RUN dnf -y update && dnf -y upgrade
RUN dnf install -y iputils openssh mc vi vim

RUN dnf install -y locales

RUN dnf install -y traceroute git-core bzip2 wget pbzip2 xz openssl
RUN dnf install -y ccache gcc gcc-c++ cross-aarch64-openmandriva-linux-gnu-gcc cross-armv7hnl-openmandriva-linux-gnueabihf-gcc
RUN dnf install -y cmake sudo
RUN dnf install -y timezone u-boot-tools dosfstools qemu-user-binfmt qemu-user-static-tapset fontconfig kpartx lsof f2fs-tools
RUN dnf install -y automake libtool make glibc-devel libuuid-devel lz4 liblz4-devel liblzo-devel glibc-static-devel glibc-devel clang
RUN dnf install -y rpm-openmandriva-setup-build rpmdevtools abb
RUN dnf install -y autoconf-archive expat libexpat-devel libx11-devel libsystemd-devel
RUN dnf install -y libz-devel

RUN cd /tmp \
 && git clone -b v1.15.0 https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git \
 && cd f2fs-tools \
 && ./autogen.sh \
 && ./configure --prefix /usr/local \
 && make install

RUN cd /tmp \
 && git clone https://github.com/LonelyFool/lpunpack_and_lpmake.git \
 && cd lpunpack_and_lpmake \
 && git checkout f2e94aef8786477cf5cb51f2e94f84838314cc5b \
 && sed -i 's|CFLAGS.*static.*||g' make.sh \
 && ./make.sh \
 && mv bin/* /usr/local/bin

RUN cd /tmp \
 && git clone -b 1.1.4 https://github.com/anestisb/android-simg2img.git \
 && cd android-simg2img \
 && make \
 && mv simg2img /usr/local/bin \
 && mv img2simg /usr/local/bin \
 && mv simg2simg /usr/local/bin \
 && mv append2simg /usr/local/bin

RUN echo $'\
[ayya-pkgs]\n\
name=ROSA AYYA SPECIAL PACKAGES\n\
baseurl=file:///opt/ayya-repo\n\
gpgcheck=0\n\
enabled=1' > /etc/yum.repos.d/rosa.repo

RUN git config --global user.email "you@example.com"
RUN git config --global user.name "Your Name"

RUN rm -rf /tmp/*

RUN echo "PATH=/usr/local/bin:\$PATH" >> /root/.bashrc

CMD /bin/bash

# commands for build and start docker:
# build:
#   docker build --network host -t "rosa" .
# start:
#   docker run --network host -it -v /opt:/opt -v /dev:/dev -v ${HOME}:${HOME} --privileged "rosa" "bash"

