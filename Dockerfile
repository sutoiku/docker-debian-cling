FROM debian:testing

RUN apt-get update  -q -y                                                                                   && \
    apt-get upgrade -q -y                                                                                   && \
    export BUILD_PACKAGES='git-core make cmake libz-dev python gcc g++ wget'                                && \
    apt-get install -f -q -y curl ca-certificates $BUILD_PACKAGES --no-install-recommends                   && \
    cd root && mkdir cling-build && cd cling-build                                                          && \
    wget https://raw.githubusercontent.com/root-mirror/root/master/interpreter/cling/tools/packaging/cpt.py && \
    chmod +x cpt.py                                                                                         && \
    ./cpt.py --current-dev=tar                                     \
             --with-clang-url=http://root.cern.ch/git/clang.git    \
             --with-llvm-url=http://root.cern.ch/git/llvm.git      \
             --with-cling-url=https://github.com/sutoiku/cling.git \
             --no-test                                             \
             --skip-cleanup                                        \
             --with-cmake-flags="-DLLVM_ENABLE_EH=ON -DLLVM_ENABLE_RTTI=ON -DLLVM_ENABLE_THREADS=OFF -DLLVM_OPTIMIZED_TABLEGEN=ON" && \
    mv /tmp/cling-obj/include/*        /usr/include/                                                        && \
    mv /tmp/cling-obj/lib/libcling.so  /usr/lib/                                                            && \
    mv ~/ci/build/builddir/lib/clang   /usr/lib/                                                            && \
    ln -s /usr/lib/libcling.so /usr/lib/libCling.so                                                         && \
    rm -rf ~/ci /tmp/cling-obj ~/cling-build \
          /var/lib/apt/lists/*               \
          /usr/share/doc                     \
          /tmp/*                             \
          /var/log/*                         \
          /var/cache/*                       \
          /usr/local # 20170103

ENV ROOT_INCLUDE    /usr/include/c++/6:/usr/include/x86_64-linux-gnu/c++/6:/usr/include/c++/6/backward
