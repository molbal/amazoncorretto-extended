FROM amazoncorretto:18.0.2-al2 as jdk

# Install bazillion dependencies
RUN yum install -y gcc gcc-c++ compat-gcc-32 compat-gcc-32-c++ tar xz gzip make wget

# Install ghostscript
RUN cd /usr/local/ && wget https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs1000/ghostscript-10.0.0.tar.gz
RUN cd /usr/local/ && tar -zxvf ghostscript-10.0.0.tar.gz
#RUN mkdir /usr/include/ghostscript
RUN cd /usr/local/ghostscript-10.0.0 && ./configure --prefix=/usr --enable-dynamic --disable-compile-inits --with-system-libtiff && make
RUN cd /usr/local/ghostscript-10.0.0 && ./configure --prefix=/usr --enable-dynamic --disable-compile-inits --with-system-libtiff && make so
RUN cd /usr/local/ghostscript-10.0.0 && ./configure --prefix=/usr --enable-dynamic --disable-compile-inits --with-system-libtiff && make install
#RUN chmod 777 /usr/include/ghostscript
RUN cd /usr/local/ghostscript-10.0.0 && make soinstall && install -v -m644 base/*.h /usr/include/ghostscript && ln -v -s ghostscript /usr/include/ps
RUN cd /usr/local/ghostscript-10.0.0 && ln -sfv ../ghostscript/10.0.0/doc /usr/share/doc/ghostscript-10.0.0
RUN cd /usr/local/ && wget https://deac-fra.dl.sourceforge.net/project/gs-fonts/gs-fonts/8.11%20%28base%2035%2C%20GPL%29/ghostscript-fonts-std-8.11.tar.gz
RUN cd /usr/local/ && tar -xvf ghostscript-fonts-std-8.11.tar.gz -C /usr/share/ghostscript
RUN cd /usr/local/ && fc-cache -v /usr/share/ghostscript/fonts/
#RUN mkdir /usr/include/ghostscript/
RUN chmod go-w /usr/include/ghostscript/

# Install wkhtmltopdf
RUN cd /usr/local/ && wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox-0.12.6-1.amazonlinux2.aarch64.rpm
RUN cd /usr/local/ && yum -y install ./wkhtmltox-0.12.6-1.amazonlinux2.aarch64.rpm

ENTRYPOINT ["/bin/bash"]