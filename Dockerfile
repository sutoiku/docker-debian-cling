FROM debian:stretch

# Install root6 extract cling and delete root6
RUN apt-get update && \
   mv /usr/local /usr/local2 && mkdir /usr/local && \
   export BUILD_PACKAGES='cmake g++ git-core make python libz-dev' && \
   apt-get install -q -y curl $BUILD_PACKAGES || apt-get install -q -y $BUILD_PACKAGES; \
   cd root && mkdir root6 && cd root6 && \
   git clone --depth 1 https://github.com/root-mirror/root src && \
   mkdir obj && cd obj && \
    ../src/configure --minimal --enable-cxx14 --prefix=/usr/local && \
   make -j $(nproc) && \
   for exe in $(ls bin/*.exe); do mv $exe ${exe%.*}; done && \
   make install || true; \
   cp /usr/local/lib/root/libCling.so /usr/local2/lib && \
   cp /usr/local/lib/root/libCore.so /usr/local2/lib && \
   cp /usr/local/lib/root/libRIO.so /usr/local2/lib && \
   cp /usr/local/lib/root/libThread.so /usr/local2/lib && \
   cp -r /usr/local/etc/root/cling /usr/local2/include && rm -rf /usr/local2/include/cling/cint && \
   cp -r /usr/local/etc/root/cling/llvm /usr/local2/include && \
   mkdir -p /usr/local2/etc && \
   cd /usr/local2/etc && ln -s ../include root && \
   apt-get autoremove -y &&  apt-get remove --purge -y $BUILD_PACKAGES `apt-mark showauto` && \
   rm -rf /var/lib/apt/lists/* /tmp/* /root/root6 && \
   rm -rf /usr/local && mv /usr/local2 /usr/local

ENV LD_LIBRARY_PATH=/usr/local/lib
