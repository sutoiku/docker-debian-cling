FROM debian:testing

# Install root6 extract cling and delete root6
# Use our cache -- update
RUN echo "Hello v20160405"; \
   mkdir -p /etc/apt/apt.conf.d && \
   apt-get clean -q && \
   apt-get update -q && \
   apt-get upgrade -q -y && \
   mv /usr/local /usr/local2 && mkdir /usr/local && \
   apt-get clean -q && \
   export BUILD_PACKAGES='git-core make python libz-dev rsync gcc g++' && \
   (apt-get install -f -q -y curl ca-certificates $BUILD_PACKAGES --no-install-recommends || \
    apt-get install -f -q -y curl ca-certificates $BUILD_PACKAGES --no-install-recommends) && \
   cd root && mkdir root6 && cd root6 && \
   git clone -q --depth 1 https://github.com/root-mirror/root src && \
   mkdir obj && cd obj && \
   CLINGCXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0" \
   CFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"        \
   CPPFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"      \
   CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"      \
   ../src/configure --minimal                               \
                    --enable-cxx14                          \
                    --prefix=/usr/local                     \
                    --cflags='-D_GLIBCXX_USE_CXX11_ABI=0'   \
                    --cxxflags='-D_GLIBCXX_USE_CXX11_ABI=0' && \
   CLINGCXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0" \
   CFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"        \
   CPPFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"      \
   CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"      \
   make -j`nproc`  && \
   for exe in $(ls bin/*.exe); do mv $exe ${exe%.*}; done && \
   CLINGCXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0" \
   CFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"        \
   CPPFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"      \
   CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"      \
   make install || true; \
   mkdir -p /usr/local2/lib/root && \
   cp /usr/local/lib/root/libCling.so /usr/local2/lib/root && \
   cp /usr/local/lib/root/libCore.so /usr/local2/lib/root && \
   cp /usr/local/lib/root/libRIO.so /usr/local2/lib/root && \
   cp /usr/local/lib/root/libThread.so /usr/local2/lib/root && \
   cp -r /usr/local/etc/root/cling /usr/local2/include && \
   rm -rf /usr/local2/include/cling/cint && \
   cp -r /usr/local/etc/root/cling/llvm /usr/local2/include && \
   mkdir -p /usr/local2/etc && \
   cd /usr/local2/etc && ln -s ../include root && \
   cp /usr/local2/etc/root/allDict.cxx.pch /usr/local/etc/root/allDict.cxx.pch && \
   apt-get autoremove -y &&  apt-get remove --purge -y $BUILD_PACKAGES `apt-mark showauto` && \
   apt-get install -q -y libc++-dev --no-install-recommends && \
   rm -rf /var/lib/apt/lists/* /usr/share/doc /tmp/* /root/root6 /var/log/* /var/cache/* && \
   rm -rf /usr/local && mv /usr/local2 /usr/local

ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib/root
ENV ROOT_INCLUDE /usr/include/c++/5:/usr/include/x86_64-linux-gnu/c++/5:/usr/include/c++/5/backward
