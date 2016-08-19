FROM debian:testing

# Install root6 extract cling and delete root6
RUN echo "v20160819"; \
   apt-get clean -q                                                                        && \
   apt-get update -q     || apt-get update -q                                              && \
   apt-get upgrade -q -y || apt-get upgrade -q -y                                          && \
   mv /usr/local /usr/local2 && mkdir /usr/local                                           && \
   apt-get clean -q                                                                        && \
   export BUILD_PACKAGES='git-core dpkg-dev cmake python liblzma-dev ninja-build libz-dev rsync make g++ gcc binutils' && \
   (apt-get install -f -q -y curl ca-certificates $BUILD_PACKAGES --no-install-recommends ||  \
    apt-get install -f -q -y curl ca-certificates $BUILD_PACKAGES --no-install-recommends) && \
   cd /root && mkdir root6 && cd root6 && echo "Cloning root6" && \
   git clone --depth 1 --single-branch --branch master https://github.com/y--/root src && \
   mkdir obj && cd obj                                                                     && \
   cmake  -G Ninja \
          -Dtesting=off -Dgnuinstall=ON \
          -DCMAKE_INSTALL_PREFIX=/usr/local ../src \
          -DCMAKE_BUILD_TYPE=MinSizeRel \
          -Dminimal=ON \
          -Dx11=OFF \
          -Dastiff=OFF \
          -DCMAKE_INSTALL_DOCDIR=/tmp/rootdel \
          -DCMAKE_INSTALL_DATAROOTDIR=/tmp/rootdel \
          -DCMAKE_INSTALL_ELISPDIR=/tmp/rootdel \
          -DCMAKE_INSTALL_CMAKEDIR=/tmp/rootdel \
          -DLLVM_ENABLE_THREADS=OFF \
          -DLLVM_OPTIMIZED_TABLEGEN=ON \
           &&\
   cmake --build . --target install && \
   rm -rf /tmp/rootdel && \
   #                                                                                          \
   # Clean                                                                                    \
   #                                                                                          \
   rm -rf /usr/local/include/cling/cint                                                    && \
   mkdir -p /usr/local2/lib/root                                                           && \
   mkdir -p /usr/local2/etc/root                                                           && \
   cp     /usr/local/lib/root/libCling.so      /usr/local2/lib/root                        && \
   cp     /usr/local/lib/root/libCore.so       /usr/local2/lib/root                        && \
   cp     /usr/local/lib/root/libRIO.so        /usr/local2/lib/root                        && \
   cp     /usr/local/lib/root/libThread.so     /usr/local2/lib/root                        && \
   cp -r  /usr/local/include                   /usr/local2/                                && \
   cp -r  /usr/local/etc/root/cling            /usr/local2/include                         && \
   cp -r  /usr/local/etc/root/cling/llvm       /usr/local2/include                         && \
   cp     /usr/local/etc/root/allDict.cxx.pch  /usr/local2/etc/root/allDict.cxx.pch        && \
   apt-get remove --purge -y $BUILD_PACKAGES                                               && \
   apt-get autoremove -y                                                                   && \
   apt-get install -q -y libc++-dev --no-install-recommends                                && \
   apt-get autoclean -y                                                                    && \
   rm -rf /var/lib/apt/lists/*                                                                \
          /usr/share/doc                                                                      \
          /tmp/*                                                                              \
          /root/root6                                                                         \
          /var/log/*                                                                          \
          /var/cache/*                                                                        \
          /usr/local                                                                       && \
   mv /usr/local2 /usr/local                                                               && \
   ln -s /usr/local/include/cling /usr/local/etc/root/cling

ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib/root
ENV ROOT_INCLUDE /usr/include/c++/5:/usr/include/x86_64-linux-gnu/c++/5:/usr/include/c++/5/backward
