FROM debian:testing

# Install root6 extract cling and delete root6
RUN apt-get update -q                                                                                && \
    export BUILD_PACKAGES='git-core cmake make libz-dev python gcc g++'                              && \
    apt-get install -f -q -y curl ca-certificates $BUILD_PACKAGES --no-install-recommends            && \
    cd root && mkdir root6 && cd root6                                                               && \
    git clone -q --single-branch --branch master --depth 1 https://github.com/root-mirror/root src   && \
    mkdir obj && cd obj                                                                              && \
    #                                                                                                   \
    # Configure                                                                                         \
    #                                                                                                   \
    cmake -DCMAKE_CXX_FLAGS=-D_GLIBCXX_USE_CXX11_ABI=0                                                  \
          -Dminimal=true                                                                                \
          -Dprefix=/usr/local                                                                           \
          -Denable-cxx14=true ../src/                                                                && \
    rm -rf tutorials/ CTestCustom.cmake                                                              && \
    #                                                                                                   \
    # Build                                                                                             \
    #                                                                                                   \
    make -j`nproc`                                                                                   && \
    for exe in $(ls bin/*.exe); do mv $exe ${exe%.*}; done                                           && \
    #                                                                                                   \
    # Install                                                                                           \
    #                                                                                                   \
    make install || true;                                                                               \
    #                                                                                                   \
    # Clean                                                                                             \
    #                                                                                                   \
    rm -rf /usr/local/include/cling/cint                                                             && \
    mkdir -p /usr/local2/lib/root                                                                    && \
    mkdir -p /usr/local2/etc/root                                                                    && \
    cp     /usr/local/lib/root/libCling.so      /usr/local2/lib/root                                 && \
    cp     /usr/local/lib/root/libCore.so       /usr/local2/lib/root                                 && \
    cp     /usr/local/lib/root/libRIO.so        /usr/local2/lib/root                                 && \
    cp     /usr/local/lib/root/libThread.so     /usr/local2/lib/root                                 && \
    cp -r  /usr/local/include                   /usr/local2/                                         && \
    cp -r  /usr/local/etc/root/cling            /usr/local2/include                                  && \
    cp -r  /usr/local/etc/root/cling/llvm       /usr/local2/include                                  && \
    cp     /usr/local/etc/root/allDict.cxx.pch  /usr/local2/etc/root/allDict.cxx.pch                 && \
    apt-get remove --purge -y $BUILD_PACKAGES                                                        && \
    apt-get autoremove -y                                                                            && \
    apt-get install -q -y libc++-dev --no-install-recommends                                         && \
    apt-get autoclean -y                                                                             && \
    rm -rf /var/lib/apt/lists/*                                                                         \
           /usr/share/doc                                                                               \
           /tmp/*                                                                                       \
           /root/root6                                                                                  \
           /var/log/*                                                                                   \
           /var/cache/*                                                                                 \
           /usr/local                                                                                && \
    mv /usr/local2 /usr/local                                                                        && \
    ln -s /usr/local/include/cling /usr/local/etc/root/cling

ENV LD_LIBRARY_PATH /usr/local/lib:/usr/local/lib/root
ENV ROOT_INCLUDE    /usr/include/c++/5:/usr/include/x86_64-linux-gnu/c++/5:/usr/include/c++/5/backward
