FROM centos:centos7

############## add repo 
RUN yum -y install epel-release
RUN rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
RUN rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-1.el7.nux.noarch.rpm
######################
 

RUN yum update -y

RUN yum install -y \
    curl wget unzip git vim \
    pngcrush \
    ghostscript \
    libreoffice \
    jpegoptim \
    advpng \
    pdftotext \
    wkhtmltopdf \
    python-pip \
    cronie \
    ffmpeg \
    pngout \
    advancecomp \
    perl-Image-ExifTool \
    poppler* \
    npm

#RUN npm i -g svg-placeholder

####### install supervisor for multi process
RUN pip install supervisor

ADD supervisord.conf /etc/supervisord.conf

############ install html2text, zopflipng, cjpeg
#RUN wget http://li.nux.ro/download/nux/dextop/el7/x86_64/html2text-1.3.2a-14.el7.nux.x86_64.rpm
RUN rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/html2text-1.3.2a-14.el7.nux.x86_64.rpm
RUN yum install -y html2text zopfli libjpeg-turbo-utils zopflipng cjpeg sqip
###############################  

########### install pngout
RUN wget http://static.jonof.id.au/dl/kenutils/pngout-20150319-linux.tar.gz
RUN tar zxvf pngout-20150319-linux.tar.gz
RUN cp ./pngout-20150319-linux/x86_64/pngout /usr/local/bin/
##############################

############ install composer
RUN wget https://getcomposer.org/composer.phar
RUN chmod +x composer.phar
RUN mv composer.phar /usr/local/bin/composer
#############################

RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY*

#RUN yum -y install -y epel-release

RUN yum -y install httpd

RUN rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm

RUN yum -y install yum-utils

RUN yum update -y

RUN yum-config-manager --enable remi-php72

RUN yum -y install php php-opcache

RUN yum install -y \
    php-pear \
    php-pecl-apcu \
    php-pecl-imagick \
    php-pecl-redis \
	php-gd \
	php-json \
	php-mbstring \
	php-mysqlnd \
	php-xml \
	php-xmlrpc \
	php-opcache \
	php-intl \
	php-exif \
	php-pdo_mysql \
	php-soap \
	php-xsl \
	php-mysqli \
	php-bcmath \
	php-zip \
	php-bz2 

#################### install imagick
#RUN pecl install imagick && docker-php-ext-enable imagick

#################### install apcu
#RUN pecl install apcu && docker-php-ext-enable apcu

#################### install redis
#RUN pecl install redis && docker-php-ext-enable redis

# Change user to match the host system UID and GID and chown www directory
#RUN useradd -d /var/www/html -G apache pimcore
#RUN useradd -g apache apache
RUN echo "pimcore#123" | passwd --stdin apache

RUN chmod -R 644 /var/www/html
RUN chmod -R +X /var/www/html
RUN chown -R apache.apache /var/www/html/

WORKDIR /var/www/html


EXPOSE 80

# Start the service
#CMD ["-D", "FOREGROUND"]
#ENTRYPOINT ["/usr/sbin/httpd"]
ENTRYPOINT ["/usr/bin/supervisord"]



