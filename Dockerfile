FROM debian:stretch

# Install root6 extract cling and delete root6
RUN \
#   echo 'Acquire::HTTP::Proxy "http://172.17.0.1:3142";' > /etc/apt/apt.conf.d/01proxy && \
#   echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy && \
   apt-get update && \
   export BUILD_PACKAGES='git-core make python libz-dev rsync g++' && \
   apt-get install libstdc++-5-dev --no-install-recommends && \
   apt-get install -q -y curl ca-certificates $BUILD_PACKAGES --no-install-recommends || \
   apt-get install -q -y curl ca-certificates $BUILD_PACKAGES --no-install-recommends; \
   cd root && mkdir root6 && cd root6 && \
   git clone --depth 1 https://github.com/root-mirror/root src && \
   mkdir obj && cd obj && \
    ../src/configure --minimal --enable-cxx14 --prefix=/usr/local && \
   make -j $(nproc) && \
   for exe in $(ls bin/*.exe); do mv $exe ${exe%.*}; done && \
   make install || true; \
   apt-get autoremove -y &&  apt-get remove --purge -y $BUILD_PACKAGES `apt-mark showauto` && \
   apt-get install -q -y libstdc++-5-dev --no-install-recommends && \
   rm -rf /var/lib/apt/lists/* /usr/share/doc /tmp/* /root/root6
   # rm /etc/apt/apt.conf.d/01proxy

ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib/root
ENV ROOT_INCLUDE=/usr/include/c++/5:/usr/include/x86_64-linux-gnu/c++/5:/usr/include/c++/5/backward
