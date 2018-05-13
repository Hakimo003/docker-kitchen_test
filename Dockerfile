FROM centos:latest
MAINTAINER hakim.chrifialaoui@gmail.com

####################################################
# ADD A NECESSARY CONFIG IF YOU ARE BEHIND A PROXY #
####################################################

RUN yum update -y && \
    yum install -y \
		python-devel \
    ansible \
		python-lxml \
		libxml2 \
		libxslt \
		libxml2-devel \
		libxslt-devel \
		epel-release \
    python-pip \
    gcc gcc-c++ \
    libtool libtool-ltdl \
    make cmake \
    pkgconfig \
    automake autoconf \
    yum-utils rpm-build \
    gem \
    libselinux-python && \
    yum clean all
###########################################
#     Preparing kitchen requierements     #
###########################################

RUN curl -k -O https://packages.chef.io/files/stable/chef/14.1.1/el/7/chef-14.1.1-1.el7.x86_64.rpm && \
   rpm -ivh chef-14.1.1-1.el7.x86_64.rpm && \
   rm chef-14.1.1-1.el7.x86_64.rpm

# Install RVM and Ruby as default
RUN yum install -y which && \
    yum update -y && \
    yum clean all

RUN /bin/bash -lc "command curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -"
RUN /bin/bash -lc "curl -L get.rvm.io | bash -s stable"
RUN /bin/bash -lc "rvm autolibs fail && rvm autolibs enable"
RUN /bin/bash -lc "rvm install ruby-2.4.3 && rvm use 2.4.3"

COPY serverspec /home/serverspec
RUN /bin/bash -lc "chmod 777 /home/serverspec"
RUN /home/serverspec


CMD ["/usr/sbin/init"]
