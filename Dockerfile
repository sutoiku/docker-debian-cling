FROM debian:testing

# Install root6 extract cling and delete root6
RUN echo "v20160408"; \
   mkdir -p /etc/apt/apt.conf.d                                                            && \
   apt-get clean -q                                                                        && \
   apt-get update -q                                                                       && \
   apt-get upgrade -q -y                                                                   && \
   apt-get clean -q                                                                        && \
   export BUILD_PACKAGES='git-core make python libz-dev rsync gcc g++'                     && \
   (apt-get install -f -q -y curl ca-certificates $BUILD_PACKAGES --no-install-recommends ||  \
    apt-get install -f -q -y curl ca-certificates $BUILD_PACKAGES --no-install-recommends) && \
   cd root && mkdir root6 && cd root6                                                      && \
   git clone -q --depth 1 https://github.com/root-mirror/root src                          && \
   mkdir obj && cd obj                                                                     && \
   #                                                                                          \
   # Configure                                                                                \
   #                                                                                          \
   CLINGCXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"                                                 \
   CFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"                                                        \
   CPPFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"                                                      \
   CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"                                                      \
   ../src/configure --minimal                                                                 \
                    --enable-cxx14                                                            \
                    --prefix=/usr/local                                                       \
                    --cflags='-D_GLIBCXX_USE_CXX11_ABI=0'                                     \
                    --cxxflags='-D_GLIBCXX_USE_CXX11_ABI=0'                                && \
   #                                                                                          \
   # Build                                                                                    \
   #                                                                                          \
   CLINGCXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"                                                 \
   CFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"                                                        \
   CPPFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"                                                      \
   CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"                                                      \
   make -j`nproc`                                                                          && \
   for exe in $(ls bin/*.exe); do mv $exe ${exe%.*}; done                                  && \
   #                                                                                          \
   # Install                                                                                  \
   #                                                                                          \
   CLINGCXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"                                                 \
   CFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"                                                        \
   CPPFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"                                                      \
   CXXFLAGS="-D_GLIBCXX_USE_CXX11_ABI=0"                                                      \
   make install || true;                                                                      \
   #                                                                                          \
   # Clean                                                                                    \
   #                                                                                          \
   apt-get autoremove -y                                                                   && \
   apt-get autoclean  -y                                                                   && \
   apt-get remove --purge -y $BUILD_PACKAGES `apt-mark showauto`                           && \
   apt-get install -q -y libc++-dev --no-install-recommends                                && \
   rm -rf /usr/local/include/cling/cint                                                       \
          /var/lib/apt/lists/*                                                                \
          /tmp/*                                                                              \
          /root/root6                                                                         \
          /usr/local/man/*                                                                    \
          /usr/local/etc/root/html                                                            \
          /usr/local/etc/root/http                                                            \
          /usr/local/etc/root/daemons                                                         \
          /usr/local/etc/root/notebook                                                        \
          /usr/local/etc/root/plugins                                                         \
          /usr/local/etc/root/vmc                                                             \
          /usr/local/etc/root/*.txt                                                           \
          /usr/local/etc/root/system.*                                                        \
          /usr/local/etc/root/*.supp                                                          \
          /usr/local/etc/root/root.*                                                          \
          /usr/local/etc/root/hostcert.conf                                                   \
          /usr/local/share/                                                                   \
          /var/log/*                                                                          \
          /var/cache/*                                                                     && \
   ln -s /usr/local/include/cling /usr/local/etc/root/cling

ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib/root
ENV ROOT_INCLUDE /usr/include/c++/5:/usr/include/x86_64-linux-gnu/c++/5:/usr/include/c++/5/backward
