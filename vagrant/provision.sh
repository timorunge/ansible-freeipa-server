#!/bin/sh
set -e

if [ -f /etc/debian_version ]; then
  apt-get update
  DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    curl \
    python \
    python-apt \
    systemd
  apt-get clean
elif [ -f /etc/redhat-release ]; then
  yum install -y epel-release
  yum update -y
  yum install -y \
    curl \
    pip \
    python \
    systemd
  yum clean all
else
  echo "Operating system is not supportet."
  exit 1
fi

curl -s https://bootstrap.pypa.io/get-pip.py | python

pip install pyopenssl
pip install ansible
pip install ansible-lint coverage junit-xml splitter
