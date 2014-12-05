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
	-ar \
	--stats \
	--delete \
	--exclude='/wp-content/' \
	--exclude='.*' \
	--exclude='/wp-config.php' \
	$LATEST_ROOT/wordpress/ $DIR/
