# Install root6 extract cling and delete root6
RUN \
# Use our cache
#   echo 'Acquire::HTTP::Proxy "http://172.17.0.1:3142";' > /etc/apt/apt.conf.d/01proxy && \
#   echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy && \
   apt-get update && \
   mv /usr/local /usr/local2 && mkdir /usr/local && \
   export BUILD_PACKAGES='git-core make python libz-dev rsync curl ca-certificates g++' && \
   apt-get install -q -y $BUILD_PACKAGES --no-install-recommends || \
   apt-get install -q -y $BUILD_PACKAGES --no-install-recommends; \
   cd root && mkdir root6 && cd root6 && \
# Use a small patch so we dont need to have g++ on the command-line:
   git clone --depth 1 https://github.com/Y--/root src && \
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
   apt-get autoremove -y && apt-get remove --purge -y $BUILD_PACKAGES `apt-mark showauto` && \
#   rm /etc/apt/apt.conf.d/01proxy
   apt-get autoremove -y && apt-get autoclean -y && \
   rm -rf /var/lib/apt/lists/* /tmp/* /root/root6 && \
   rm -rf /usr/local && mv /usr/local2 /usr/local
#TODO: figure out how to leave the libc++ headers in place as sling uses them.
ENV ROOT_INCLUDE /usr/include/c++/5:/usr/include/x86_64-linux-gnu/c++/5:/usr/include/c++/5/backward
ENV LD_LIBRARY_PATH=/usr/local/lib
