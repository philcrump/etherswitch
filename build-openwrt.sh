#!/bin/bash

BASE_DIR=$(pwd)"/"$(dirname "$0")
LEDE_DIR="${BASE_DIR}/lede"

if [ ! -d "$LEDE_DIR" ]; then
    # Install dependencies
    sudo apt-get install -y git-core build-essential libssl-dev libncurses5-dev unzip gawk;
    # Clone upstream source
    git clone https://git.lede-project.org/source.git $LEDE_DIR/;
else
    cd $LEDE_DIR/;
    # Reset local changes (re-apply later)
    git reset --hard HEAD;
    # Pull latest source
    git pull;
fi

# Copy in latest application files
if [ -d "$LEDE_DIR/files/" ]; then
    rm -fr $LEDE_DIR/files/;
fi
cp -rv $BASE_DIR/application-files $LEDE_DIR/files/;

# Apply application patches
IFS=$'\n'
for patchfile in `ls -1 $BASE_DIR/application-patches/`
do
  patch -p0 -d ${LEDE_DIR}/ < $patchfile
done
unset IFS

# Add Build config
cp $BASE_DIR/ledeconfig-diff $LEDE_DIR/.config;

timestamp=$(date +"%Y-%m-%d-%H%M")
gitref=$(git describe --dirty --always)
echo "{\"p\":\"ghy99\",\"t\":\"$timestamp\",\"g\":\"$gitref\"}" > "$LEDE_DIR/files/etc/version"

# Compile!
cd $LEDE_DIR/;
make defconfig;
make -j 4 V=s;

# Copy out compiled fw image
cp -fv ${LEDE_DIR}/bin/targets/ar71xx/generic/lede-ar71xx-generic-gl-ar150-squashfs-sysupgrade.bin ${BASE_DIR}/lede-ghy99-switch-$timestamp-$gitref.bin

echo "Done!"
