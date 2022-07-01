#!/bin/bash

echo "Downloading the kURL installer for $APP_SLUG" >> /tmp/install.txt

curl -LO https://k8s.kurl.sh/$APP_SLUG 
mv $APP_SLUG $APP_SLUG.sh
chmod 744 $APP_SLUG.sh

echo "Installing kURL k8s for $APP_SLUG" >> /tmp/install.txt

sudo su
/bin/bash -x ./$APP_SLUG.sh >> /tmp/install.txt
