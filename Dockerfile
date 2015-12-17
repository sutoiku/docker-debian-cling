FROM debian:jessie

# Install root6 extract cling and delete root6
# Use our cache
RUN \
   mkdir -p /etc/apt/apt.conf.d/ && \
   apt-get update && \
   export BUILD_PACKAGES='git-core make python libz-dev rsync clang' && \
   apt-get install -q -y curl ca-certificates $BUILD_PACKAGES --no-install-recommends || \
   apt-get install -q -y curl ca-certificates $BUILD_PACKAGES --no-install-recommends; \
   cd root && mkdir root6 && cd root6 && \
   git clone --depth 1 https://github.com/root-mirror/root src && \
   mkdir obj && cd obj && \
    ../src/configure --minimal --enable-cxx14 --prefix=/usr/local --with-clang && \
   make -j $(nproc) && \
   for exe in $(ls bin/*.exe); do mv $exe ${exe%.*}; done && \
   make install || true; \
   apt-get autoremove -y &&  apt-get remove --purge -y $BUILD_PACKAGES `apt-mark showauto` && \
   apt-get install -q -y libc++-dev --no-install-recommends && \
   rm -rf /var/lib/apt/lists/* /usr/share/doc /tmp/* /root/root6 && \
   rm -rf /usr/local/man/* \
    /usr/local/etc/root/html \
    /usr/local/etc/root/http \
    /usr/local/etc/root/daemons \
    /usr/local/etc/root/notebook \
    /usr/local/etc/root/plugins \
    /usr/local/etc/root/vmc \
    /usr/local/etc/root/*.txt \
    /usr/local/etc/root/system.* \
    /usr/local/etc/root/*.supp \
    /usr/local/etc/root/root.* \
    /usr/local/etc/root/hostcert.conf \
    /usr/local/share/doc \
    /usr/local/share/ \
    /usr/local/share/root/fonts \
    /usr/local/share/root/icons \
    /usr/local/share/ \
    /usr/local/share/emacs \
    /var/log/* \
    /var/cache/*

ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib/root
