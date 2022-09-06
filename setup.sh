#!/usr/bin/env bash

set -e

show_usage() {
  echo "Usage: $(basename $0) takes exactly 1 argument (install | uninstall)"
}

if [ $# -ne 1 ]
then
  show_usage
  exit 1
fi

check_env() {
  if [[ -z "${APM_TMP_DIR}" ]]; then
    echo "APM_TMP_DIR is not set"
    exit 1
  
  elif [[ -z "${APM_PKG_INSTALL_DIR}" ]]; then
    echo "APM_PKG_INSTALL_DIR is not set"
    exit 1
  
  elif [[ -z "${APM_PKG_BIN_DIR}" ]]; then
    echo "APM_PKG_BIN_DIR is not set"
    exit 1
  fi
}

install() {
  wget https://github.com/indygreg/python-build-standalone/releases/download/20220802/cpython-3.10.6+20220802-x86_64-unknown-linux-gnu-install_only.tar.gz -O $APM_TMP_DIR/cpython-3.10.6.tar.gz
  tar xf $APM_TMP_DIR/cpython-3.10.6.tar.gz -C $APM_PKG_INSTALL_DIR
  rm $APM_TMP_DIR/cpython-3.10.6.tar.gz

  $APM_PKG_INSTALL_DIR/python/bin/pip3.10 install https://github.com/AttifyOS/expliot/releases/download/v0.9.11/bluepy-1.3.0-cp310-cp310-linux_x86_64.whl
  $APM_PKG_INSTALL_DIR/python/bin/pip3.10 install libusb
  $APM_PKG_INSTALL_DIR/python/bin/pip3.10 install expliot==0.9.11

  ln -s $APM_PKG_INSTALL_DIR/python/bin/expliot $APM_PKG_BIN_DIR/

  echo "This package adds the commands:"
  echo " - expliot"
}

uninstall() {
  rm -rf $APM_PKG_BIN_DIR/python
  rm $APM_PKG_BIN_DIR/expliot
}

run() {
  if [[ "$1" == "install" ]]; then 
    install
  elif [[ "$1" == "uninstall" ]]; then 
    uninstall
  else
    show_usage
  fi
}

check_env
run $1