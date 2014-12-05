#!/bin/bash

# The site we are updating. Trailing slash stripped.
DIR=${@%/}

# Where to download WP from if we need to.
WP_URL="https://wordpress.org/latest.zip"

# This is where the latest version of WP is stored.
LATEST_ROOT="./wp"

# If the site's directory doesn't exist, stop.
if [ ! -d "$DIR" ]; then
	echo "ERROR: Directory ($DIR) not found."
	exit
fi

# Make sure this looks like a WordPress site.
if [ ! -d "$DIR/wp-admin" ]; then
	echo "ERROR: This doesn't seem to be a WordPress website."
	exit
fi

# If we need the latest version, download.
if [ ! -d "$LATEST_ROOT" ]; then
	echo "Downloading latest wordpress version."
	wget -O wp.zip $WP_URL
	unzip wp.zip -d $LATEST_ROOT
	rm -rf ./wp.zip
fi

# Rsync the site.
echo "Ryncing repository with new version."
rsync \
	-aqr \
	--stats \
	--delete \
	--filter=':- .gitignore' \
	--exclude='/wp-content/' \
	--exclude='.*' \
	--exclude='/wp-config.php' \
	$LATEST_ROOT/wordpress/ \
	$DIR/

# Update the plugins.
# This bit is an altered snippet from this script: http://b.ri.mu/files/wordpress-upgrade.sh
echo "Upgrading plugins."
CACHE_FILE="./.plugupdate.txt"
touch $CACHE_FILE
pluglist=$(find $DIR/wp-content/plugins/ -maxdepth 1 -type d | sed s@$DIR/wp-content/plugins/@@)
for plugname in $pluglist ; do curl -s http://api.wordpress.org/plugins/info/1.0/$plugname.xml |grep download_link | cut -c40- | sed s/\].*// >>$CACHE_FILE ; done
for file in $(cat $CACHE_FILE) ; do curl -s -o ./tmp.zip $file ;unzip -qq -o ./tmp.zip -d $DIR/wp-content/plugins/ ; rm ./tmp.zip ; done
rm $CACHE_FILE

echo "Updated. You probably need to update the database. You can do so at /wp-admin/upgrade.php?step=1"
