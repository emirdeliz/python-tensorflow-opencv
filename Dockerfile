# Dockerfile with tensorflow gpu support on python3, opencv3.3
FROM --platform=linux/arm64/v8 tensorflow/tensorflow:latest
LABEL maintainer="Emir Marques <emirdeliz@gmail.com>"

RUN apt-get -y update && apt-get -y upgrade && apt-get install -y sudo wget unzip

# For OpenCV:
RUN sudo apt-get -y update && apt-get install -y \
  bash \
  ca-certificates \
  clang \
  cmake>3.22 \
  coreutils \
  curl \ 
  gcc \
  g++ \
  git \
  gettext \
  libavc1394-dev \
  libc-dev \
  libffi-dev \
  libpng-dev \
  libwebp-dev \
  make \
  musl \
  openssl \
  python3 \
  openssh-client \
  unzip

# For build OpenCV
# Clone, build and install OpenCV
RUN cd /opt \
  && wget https://github.com/opencv/opencv/archive/4.6.0.zip \
  && unzip 4.6.0.zip && rm 4.6.0.zip \
  && wget https://github.com/opencv/opencv_contrib/archive/4.6.0.zip \
  && unzip 4.6.0.zip && rm 4.6.0.zip \
  && cd /opt/opencv-4.6.0 && mkdir build && cd build \
  && cmake -D CMAKE_BUILD_TYPE=RELEASE \
  -D CMAKE_C_COMPILER=/usr/bin/clang \
  -D CMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -D CMAKE_INSTALL_PREFIX=/usr/local \
  -D INSTALL_PYTHON_EXAMPLES=OFF \
  -D INSTALL_C_EXAMPLES=OFF \
  -D WITH_FFMPEG=ON \
  -D WITH_TBB=ON \
  -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-4.6.0/modules \
  -D PYTHON_EXECUTABLE=/usr/local/bin/python \
  .. \
  && make -j"$(nproc)" \ 
  && make install \
  && rm -rf /build

CMD python -c "import tensorflow as tf; print(tf.constant(42) / 2 + 2)"

RUN mkdir source
WORKDIR /source