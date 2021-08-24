FROM centos:8
LABEL maintainer "ueno.s <ueno.s@gamestudio.co.jp>"

RUN yum install -y dnf tzdata && \
    cd /lib/systemd/system/sysinit.target.wants/ && \
    for i in *; do \
        [ $i == systemd-tmpfiles-setup.service ] || rm -vf $i ; \
    done ; \
    rm -vf /lib/systemd/system/multi-user.target.wants/* && \
    rm -vf /etc/systemd/system/*.wants/* && \
    rm -vf /lib/systemd/system/local-fs.target.wants/* && \
    rm -vf /lib/systemd/system/sockets.target.wants/*udev* && \
    rm -vf /lib/systemd/system/sockets.target.wants/*initctl* && \
    rm -vf /lib/systemd/system/basic.target.wants/* && \
    rm -vf /lib/systemd/system/anaconda.target.wants/* && \
    mkdir -p /etc/selinux/targeted/contexts/ && \
    echo '<busconfig><selinux></selinux></busconfig>' > /etc/selinux/targeted/contexts/dbus_contexts \
    && dnf update -y \
    && dnf clean all --enablerepo='*' \
    && dnf clean metadata --enablerepo='*' \
    && dnf clean all --enablerepo='*' \
    && rm -rf /var/cache/yum \
    && dnf -y swap centos-{linux,stream}-repos \
    && dnf -y distro-sync \
    && rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial \
    && dnf -y upgrade

CMD ["/sbin/init"]