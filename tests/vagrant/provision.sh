#!/bin/sh
set -e

if [ -f /etc/debian_version ]; then
  apt-get update
  DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    curl \
    python \
    python-apt \
    systemd \
    unzip \
    wget
  apt-get clean
elif [ -f /etc/redhat-release ]; then
  if [ -f /etc/centos-release ]; then
    yum install -y epel-release
  fi
  yum update -y --exclude=kernel*
  yum install -y \
    curl \
    python \
    python2-dnf \
    systemd \
    unzip \
    wget
  if [ -f /etc/centos-release ]; then
    yum install -y systemd-resolved
  fi
  yum clean all
else
  echo "Operating system is not supportet."
  exit 1
fi

curl -s https://bootstrap.pypa.io/get-pip.py | python

pip install --upgrade \
  ansible==2.7.7 \
  ansible-lint \
  coverage \
  cryptography \
  junit-xml \
  pyopenssl \
  splitter
