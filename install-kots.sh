#!/usr/bin/env bash

if [[ -z "${APP_SLUG}" ]]
then
      read -p "APP_SLUG to install:" GITHUB_USERNAME
else
      echo -e "APP_SLUG ${GREEN}is set${NC}."
fi

echo "downloading the KOTS application"

curl -LO https://k8s.kurl.sh/$APP_SLUG 
mv $APP_SLUG $APP_SLUG.sh
chmod 744 $APP_SLUG.sh

echo "installing the KOTS application"

sudo su
/bin/bash -x ./$APP_SLUG.sh > /tmp/install.txt
