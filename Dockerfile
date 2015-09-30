FROM debian:jessie
MAINTAINER Basil Veerman <bveerman@uvic.ca>

RUN echo 'Acquire::HTTP::Proxy "http://docker1.pcic:3142";' >> /etc/apt/apt.conf.d/01proxy \
 && echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy

RUN apt-get update && apt-get -yq install gcc \
                      build-essential \
                      tar \
                      bzip2 \
                      m4 \
                      zlib1g-dev \
                      libopenmpi-dev

COPY hdf5-1.8.15-patch1.tar.bz2 hdf5-1.8.15-patch1.tar.bz2
COPY netcdf-4.3.3.1.tar.gz netcdf-4.3.3.1.tar.gz

#Build HDF5
RUN tar xjvf hdf5-1.8.15-patch1.tar.bz2 && \
    cd hdf5-1.8.15-patch1 && \
    CC=mpicc ./configure --enable-parallel --prefix=/usr/local/hdf5 && \
    make -j4 && \
    make install && \
    cd .. && \
    rm -rf /hdf5-1.8.15-patch1 /hdf5-1.8.15-patch1.tar.bz2 

#Build netcdf
RUN tar xzvf netcdf-4.3.3.1.tar.gz && \
    cd netcdf-4.3.3.1 && \
    ./configure --prefix=/usr/local/netcdf \ 
                CC=mpicc \
                LDFLAGS=-L/usr/local/hdf5/lib \
                CFLAGS=-I/usr/local/hdf5/include && \
    make -j4 && \
    make install && \
    cd .. && \
    rm -rf netcdf-4.3.3.1 netcdf-4.3.3.1.tar.gz
