#!/bin/bash

source /var/lib/astroneer/notifier.sh

setup_bashrc() {
    cat >> /bash.bashrc <<EOF


$_bashrc_tag_start
export wineprefix=/wine
export winearch=win64
$_bashrc_tag_end
EOF
}

grep "${_bashrc_tag_start}" /etc/bash.bashrc > /dev/null
[[ $? != 0 ]] && setup_bashrc

steamcmd_setup

# start Xvfb
xvfb_display=0
rm -rf /tmp/.X$xvfb_display-lock
Xvfb :$xvfb_display -screen 0, 1024x768x24:32 -nolisten tcp &
export DISPLAY=:$xvfb_display

mkdir -p /usr/share/wine/mono /usr/share/wine/gecko
test -f /usr/share/wine/mono/wine-mono-5.0.0-x86.msi || wget -q http://dl.winehq.org/wine/wine-mono/5.0.0/wine-mono-5.0.0-x86.msi -O /usr/share/wine/mono/wine-mono-5.0.0-x86.msi
test -f /usr/share/wine/gecko/wine-gecko-2.47.1-x86_64.msi || wget -q http://dl.winehq.org/wine/wine-gecko/2.47.1/wine-gecko-2.47.1-x86_64.msi -O /usr/share/wine/gecko/wine-gecko-2.47.1-x86_64.msi
test -f /usr/share/wine/gecko/wine-gecko-2.47.1-x86.msi || wget -q http://dl.winehq.org/wine/wine-gecko/2.47.1/wine-gecko-2.47.1-x86.msi -O /usr/share/wine/gecko/wine-gecko-2.47.1-x86.msi

wget http://crt.usertrust.com/USERTrustRSAAddTrustCA.crt -O /usr/local/share/ca-certificates
update-ca-certificates

# start supervisord
"$@"
