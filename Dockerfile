FROM debian:jessie
MAINTAINER Basil Veerman <bveerman@uvic.ca>

RUN apt-get update

RUN apt-get -yq install gcc \
                        build-essential \
                        wget \
                        bzip2 \
                        tar \
                        libopenmpi-dev


#Build HDF5
RUN wget http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.15-patch1.tar.bz2; \
    tar xjvf hdf5-1.8.15-patch1.tar.bz2; \
    cd hdf5-1.8.15-patch1; \
    CC=mpicc ./configure --enable-parallel --prefix=/usr/local/hdf5; \
    make -j4; \
    make install; \
    cd ..; \
    rm -rf /hdf5-1.8.15-patch1 /hdf5-1.8.15-patch1.tar.bz2 

#Build netcdf
RUN wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4.3.3.1.tar.gz
RUN tar xzvf netcdf-4.3.3.1.tar.gz
RUN cd netcdf-4.3.3.1; \
    ./configure --prefix=/usr/local/netcdf \ 
                CC=mpicc \
                LDFLAGS=-L/usr/local/hdf5/lib \
                CFLAGS=-I/usr/local/hdf5/include; \
    make -j4; \
    make install;\
    cd ..;\
    rm -rf netcdf-4.3.3.1 netcdf-4.3.3.1.tar.gz
