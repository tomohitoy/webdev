#
# Base
#

FROM centos:6.8
MAINTAINER tomohitoy t07840ty@gmail.com

RUN yum update -y
RUN chmod go+w,u+s /tmp

# package
RUN yum install git zsh vim zlib zlib-devel openssl-devel gcc-c++ glibc-headers libyaml-devel readline readline-devel zlib-devel libffi-devel openssh-server openssh-clients -y

# setting for sshd
RUN /etc/init.d/sshd start

# install nginx
RUN rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
RUN yum install nginx -y

# user
RUN useradd tomohitoy -G wheel\
    && echo 'tomohitoy:tomohitoy' | chpasswd \
    && echo "wheel ALL=(ALL) ALL" >> /etc/sudoers
RUN chsh tomohitoy -s $(which zsh)

USER tomohitoy
WORKDIR /home/tomohitoy
ENV HOME /home/tomohitoy

# ssh
RUN mkdir .ssh
ADD id_rsa.pub .ssh/authorized_keys
USER root
RUN chown tomohitoy:tomohitoy -R /home/tomohitoy
RUN chmod 700 .ssh
USER tomohitoy

# dotfiles
RUN git clone https://github.com/tomohitoy/dotfiles.git ~/dotfiles \
    && cd ~/dotfiles \
    && git checkout centos \
    && bash bootstrap.sh

# Ruby (rbenv)
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN cd ~/.rbenv && src/configure && make -C src
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
RUN echo 'eval "$(rbenv init -)"' >> ~/.zshrc
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN ~/.rbenv/bin/rbenv install 2.2.4
RUN ~/.rbenv/bin/rbenv global 2.2.4
RUN ~/.rbenv/bin/rbenv rehash

# Database

USER root
# client
RUN yum install postgresql -y
USER tomohitoy

# volumes
USER tomohitoy
RUN mkdir /home/tomohitoy/works

USER root
EXPOSE 22 80 3000
CMD ["/usr/sbin/sshd", "-D"]
