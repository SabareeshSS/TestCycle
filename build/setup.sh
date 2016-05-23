#!/bin/bash
#Creates required directory for backup
if [[ ! -f /syclops ]];then
  mkdir -p /syclops/database
  mkdir -p /syclops/terminal
  mkdir -p /syclops/ui
  mkdir -p /syclops/playbacks
fi
#Download the source code
if [[ ! -f /syclops/ui/sites/default/settings.php ]];then
  cp ./ui/src/syclops/syclops-bitbucket.make /syclops/ui
  apt-get update
  apt-get install -y curl libcurl3 libcurl3-dev git-core
  apt-get install -y php5-cli php-pear
  pear channel-discover pear.drush.org
  pear install drush/drush
  cd /syclops/ui/
  drush make syclops-bitbucket.make  .
  cd -
  cp -R ./ui/src/drush /syclops/ui/sites/all/
  cp -R ./ui/src/patch/ /tmp
  cd /syclops/ui
  patch -p1 < /tmp/patch/user-module-custom-change.patch
  cd -
  cd /syclops/ui/sites/all/modules/contrib/og 
  patch -p1 < /tmp/patch/og-module-custom-change.patch
  cd -
  cd /syclops/ui/sites/all/modules/contrib/tfa
  patch -p1 < /tmp/patch/tfa-skip-permission.patch
  cd -
fi
#Change drupal default session expiry value
DRUPAL_DEFAULT_SETTING='/syclops/ui/sites/default/default.settings.php'
DEFAULT_EXPIRY="ini_set\('session.cookie_lifetime', 2000000\);"
EXPIRY="ini_set\('session.cookie_lifetime', 32400\);"

if [[ -f $DRUPAL_DEFAULT_SETTING ]];then
  sed -i -r 's/'"$DEFAULT_EXPIRY"'/'"$EXPIRY"'/g' $(echo $DRUPAL_DEFAULT_SETTING)  
fi

#Downloads gateone source and plugin
if [[ ! -f ./terminal/src/gateone ]]; then
  #Downloads Gateone source  
  cd ./terminal/src
  git clone https://bitbucket.org/syclops/syclops_gateone.git gateone
  #Downloads Gateone Plugin
  cd gateone/gateone/applications/terminal/plugins
  git clone https://bitbucket.org/syclops/syclops_gateone_plugin.git syclops
  cd -
fi

#Installs nsenter
ns_util=$(type -P /usr/local/bin/nsenter &>/dev/null && echo 1 || echo "")
if [[ -z $ns_util ]]; then
        cd /tmp
        apt-get update
        apt-get install -y build-essential
        curl https://www.kernel.org/pub/linux/utils/util-linux/v2.24/util-linux-2.24.tar.gz | tar -zxf-
        cd util-linux-2.24
        ./configure --without-ncurses
        make nsenter
        cp nsenter /usr/local/bin
fi

if [[ $? == 0 ]];then
    echo "NSEnter installation success"
else 
    echo "NSEnter installation faild. Please check installation error and try again."
    exit 1
fi
