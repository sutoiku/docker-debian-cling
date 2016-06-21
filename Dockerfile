FROM debian:testing

# Install root6 extract cling and delete root6
RUN echo "v20160609"; \
   apt-get update -q                                                                                  && \
   export BUILD_PACKAGES='git-core make cmake libz-dev python gcc g++'                                && \
   apt-get install -f -q -y curl ca-certificates $BUILD_PACKAGES --no-install-recommends              && \
   cd root && mkdir root6 && cd root6                                                                 && \
   #                                                                                                     \
   # Clone                                                                                               \
   #                                                                                                     \
   git clone -q --single-branch --branch cling-patches --depth 1 http://root.cern.ch/git/llvm.git src && \
   cd src/tools                                                                                       && \
   git clone -q --single-branch --branch master --depth 1 http://root.cern.ch/git/cling.git           && \
   git clone -q --single-branch --branch cling-patches --depth 1 http://root.cern.ch/git/clang.git    && \
   cd ../..                                                                                           && \
   mkdir build                                                                                        && \
   cd build                                                                                           && \
   #                                                                                                     \
   # Configure                                                                                           \
   #                                                                                                     \
   cmake -DCMAKE_INSTALL_PREFIX=/usr/local            \
         -Dminimal=true                               \
         -Dprefix=/usr/local                          \
         -Denable-cxx14=true                          \
         -DCMAKE_CXX_FLAGS=-D_GLIBCXX_USE_CXX11_ABI=0 \
         -DLLVM_TARGETS_TO_BUILD=host                 \
         -DCMAKE_BUILD_TYPE=Release                   \
          ../src                                                                                      && \
   make                                                                                               && \
   make install

ENV LD_LIBRARY_PATH /usr/local/lib:/usr/local/lib/root
ENV ROOT_INCLUDE    /usr/include/c++/5:/usr/include/x86_64-linux-gnu/c++/5:/usr/include/c++/5/backward
