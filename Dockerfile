FROM debian:testing

RUN echo "v20160929"; \
   apt-get update -q                                                                                       && \
   apt-get upgrade -q                                                                                      && \
   export BUILD_PACKAGES='git-core make cmake libz-dev python gcc g++ wget'                                && \
   apt-get install -f -q -y curl ca-certificates $BUILD_PACKAGES --no-install-recommends                   && \
   cd root && mkdir cling-build && cd cling-build                                                          && \
   wget https://raw.githubusercontent.com/root-mirror/root/master/interpreter/cling/tools/packaging/cpt.py && \
   chmod +x cpt.py && ./cpt.py --last-stable deb

ENV LD_LIBRARY_PATH /usr/local/lib:/usr/local/lib/root
ENV ROOT_INCLUDE    /usr/include/c++/5:/usr/include/x86_64-linux-gnu/c++/5:/usr/include/c++/5/backward
