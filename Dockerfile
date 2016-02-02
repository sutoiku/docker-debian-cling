FROM debian:testing

# Install root6 extract cling and delete root6
# Use our cache
RUN \
   mkdir -p /etc/apt/apt.conf.d/ && \
   apt-get update && \
   mv /usr/local /usr/local2 && mkdir /usr/local && \
   export BUILD_PACKAGES='git-core make python libz-dev rsync clang' && \
   apt-get install -q -y curl ca-certificates $BUILD_PACKAGES --no-install-recommends || \
   apt-get install -q -y curl ca-certificates $BUILD_PACKAGES --no-install-recommends; \
   cd root && mkdir root6 && cd root6 && \
   git clone --depth 1 https://github.com/root-mirror/root src && \
   mkdir obj && cd obj && \
   locate --basename rsync; which rsync; ldd /usr/bin/rsync; \
   ../src/configure --minimal                               \
                    --enable-cxx14                          \
                    --prefix=/usr/local                     \
                    --cflags='-D_GLIBCXX_USE_CXX11_ABI=0'   \
                    --cxxflags='-D_GLIBCXX_USE_CXX11_ABI=0' \
                    --with-clang && \
   make -j`nproc` && \
   for exe in $(ls bin/*.exe); do mv $exe ${exe%.*}; done && \
   make install || true; \
   mkdir -p /usr/local2/lib/root && \
   cp /usr/local/lib/root/libCling.so /usr/local2/lib/root && \
   cp /usr/local/lib/root/libCore.so /usr/local2/lib/root && \
   cp /usr/local/lib/root/libRIO.so /usr/local2/lib/root && \
   cp /usr/local/lib/root/libThread.so /usr/local2/lib/root && \
   cp -r /usr/local/etc/root/cling /usr/local2/include && rm -rf /usr/local2/include/cling/cint && \
   cp -r /usr/local/etc/root/cling/llvm /usr/local2/include && \
   mkdir -p /usr/local2/etc && \
   cd /usr/local2/etc && ln -s ../include root && \
   apt-get autoremove -y &&  apt-get remove --purge -y $BUILD_PACKAGES `apt-mark showauto` && \
   apt-get install -q -y libc++-dev --no-install-recommends && \
   rm -rf /var/lib/apt/lists/* /usr/share/doc /tmp/* /root/root6 /var/log/* /var/cache/* && \
   rm -rf /usr/local && mv /usr/local2 /usr/local

ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib/root
ENV ROOT_INCLUDE /usr/include/c++/5:/usr/include/x86_64-linux-gnu/c++/5:/usr/include/c++/5/backward
