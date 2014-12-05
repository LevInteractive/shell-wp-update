## Purpose

This will simply update a wordpress site and all of its plugins to the latest version without needing to check the database, domain name or wp-config.php file. Good to use if you're managing sites with version control and want to check in the changes before going live.

## How to Use

1. Clone this project and `cd` in.
2. Make the script executable: `chmod +x update-wp.sh`
3. Do `./update-wp.sh ../my-site/`. Note that this path should be the root directory to the wordpress site.
4. Checkout the updates! You will probably need to update the database which you can do by visiting `/wp-admin/upgrade.php?step=1`.

By default the script will ignore:

* /wp-content/
* .* (any hidden files)
* /wp-config.php
* Anything in your .gitignore file.

