FROM debian:stretch

# Install root6 extract cling and delete root6
RUN apt-get update && \
   export BUILD_PACKAGES='cmake g++ git-core make python libz-dev' && \
   apt-get install -q -y curl $BUILD_PACKAGES || apt-get install -q -y $BUILD_PACKAGES; \
   cd root && mkdir root6 && cd root6 && \
   git clone --depth 1 https://github.com/root-mirror/root src && \
   mkdir obj && cd obj && \
    ../src/configure --minimal --enable-cxx14 --prefix=/opt && \
   make -j $(nproc) && \
   for exe in $(ls bin/*.exe); do mv $exe ${exe%.*}; done && \
   make install || true; \
   cp /opt/lib/root/libCling.so /usr/local/lib && \
   cp /opt/lib/root/libCore.so /usr/local/lib && \
   cp /opt/lib/root/libRIO.so /usr/local/lib && \
   cp /opt/lib/root/libThread.so /usr/local/lib && \
   cp -r /opt/etc/root/cling /usr/local/include && rm -rf /usr/local/include/cling/cint && \
   cp -r /opt/etc/root/cling/llvm /usr/local/include && \
   mkdir -p /usr/local/etc && \
   cd /usr/local/etc && ln -s /usr/local/include root && \
   apt-get autoremove -y &&  apt-get remove --purge -y $BUILD_PACKAGES `apt-mark showauto` && \
   rm -rf /var/lib/apt/lists/* /tmp/* /root/root6 && \
   rm -rf /opt

ENV LD_LIBRARY_PATH=/usr/local/lib
