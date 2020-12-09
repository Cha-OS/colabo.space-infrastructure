# Info

cat /etc/nginx/sites-available/wiki-colabo-discus

access_log /var/log/nginx/wiki-colabo-discuss.access.log;
access_log /var/log/nginx/wiki-colabo-discuss.access.plus.log;
error_log /var/log/nginx/wiki-colabo-discuss.error.log;

# Install

## PHP

```sh
php -v
# was 7.2

# Upgrade PHP
# https://askubuntu.com/a/565961/376116
sudo apt-get upgrade

php -v
# still the same :(

# https://www.cloudbooklet.com/upgrade-php-version-to-php-7-4-on-ubuntu/

# Add PPA for PHP 7.4
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update

# Install PHP 7.4 for Apache
sudo apt install php7.4

# Install PHP 7.4 FPM for Nginx
sudo apt install php7.4-fpm
sudo apt install php7.4-mbstring
sudo apt install php7.4-xml
sudo apt install php7.4-mysql
sudo apt install php7.4-gd
sudo apt install php7.4-apcu
sudo apt install php7.4-intl

php-fpm7.4 -v
```

Add in the nginx config file:

```
fastcgi_pass unix:/run/php/php7.4-fpm.sock;
```

```sh
# test
sudo nginx -t
# restart
sudo service nginx restart
```

## Download

+ https://www.mediawiki.org/wiki/Manual:Installing_MediaWiki
+ https://www.mediawiki.org/wiki/Download
+ there is a host label `wikis`
+ it operates on:
    + apts
    + database
    + remote_builds
    + nginx

+ Git
    + https://phabricator.wikimedia.org/source/mediawiki/browse/master/
    + https://www.mediawiki.org/wiki/Download_from_Git


```sh
# download mediawiki (MW)
wget https://releases.wikimedia.org/mediawiki/1.35/mediawiki-1.35.0.tar.gz
tar xvzf mediawiki-*.tar.gz
mv mediawiki-1.35.0/* .
rm -r mediawiki-1.35.0/
```

## Run Install

+ Go to the page: https://example.com/index.php
+ go to: https://example.com/mw-config/index.php
+ check all warnings
    + we protect both 
        + access to non-PHP files
            + [Passing Uncontrolled Requests to PHP](https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls/#passing-uncontrolled-requests-to-php)

        + exclude `uploads` folder
            + [Upload security](https://www.mediawiki.org/wiki/Manual:Security#Upload_security)
+ next page, from `colabo.space-infrastructure/provisioning/ansible/variables/database-list.json` provide
    + db name: wiki_colabo_discuss
    + db prefix: leave empty
    + db user name: wiki
    + db pass: empty
    + next page
+ will be asked to upgraded tables if already existed from the previous install
  + that is fine
+ Database account for web access
	+ yes
+ provide:
    + name: discuss-wiki
    + username: chaos
    + pass: from keepass
    + email: chaos.ngo@gmail.com
    + disable: Share data about this installation with MediaWiki developers
    + next page

+ set
	+ User rights profile:
    	+ Account creation required
    	+ Private wiki
        	+ cannot because of Parsoid/PHP problem
    + Copyright and licence: None
    + Email settings: all
    + Skins: keep the same
    + Special pages: all
    + Editors: all
    + Parser hooks: all
    + Media handlers: all (PDF)
    + Spam prevention: all
    + API: all (PageImages)
    + Other: all
    + Images and file uploads:
        + Enable file uploads
        + `/var/www/wiki-colabo-discuss/images/deleted`
    + Logo url: $wgResourceBasePath/resources/assets/wiki.png
        + https://colabo.space/data/images/logos/colabo-logo-with-url-130x150.png
        + Enable Instant Commons
    + Settings for object caching:
      +  PHP object caching (APC, APCu or WinCache)
    + next
+ download: `LocalSettings.php`
+ upload `LocalSettings.php`
    + NOTE: this might be automated with ansible

Added to `LocalSettings.php`:

```php
# Prevent new user registrations except by sysops
# https://www.mediawiki.org/wiki/Manual:Preventing_access#Restrict_account_creation
# disables: https://discuss-wiki.colabo.space/index.php?title=Special:CreateAccount
$wgGroupPermissions['*']['createaccount'] = false;

// Define constants for additional KnAllEdge
define("NS_COLABO_KNALLEDGE", 3000); // This MUST be even.
define("NS_COLABO_KNALLEDGE_TALK", 3001); // This MUST be the following odd integer.

// Add KnAllEdge namespaces
$wgExtraNamespaces[NS_COLABO_KNALLEDGE] = "Colabo.KnAllEdge";
$wgExtraNamespaces[NS_COLABO_KNALLEDGE_TALK] = "Colabo.KnAllEdge_talk"; // Note underscores in the namespace name.

// Define constants for RIMA namespaces.
define("NS_COLABO_RIMA", 3000); // This MUST be even.
define("NS_COLABO_RIMA_TALK", 3001); // This MUST be the following odd integer.

// Add RIMA namespaces
$wgExtraNamespaces[NS_COLABO_RIMA] = "Colabo.RIMA";
$wgExtraNamespaces[NS_COLABO_RIMA_TALK] = "Colabo.RIMA_talk"; // Note underscores in the namespace name
```

## Nginx


+ https://www.netsparker.com/blog/web-security/disable-directory-listing-web-servers/#nginxweb

Change to:
```yml
index index.php;
# autoindex on;
```

## Users

NOTE: There is more info in private infrastructure repo
+ regarding NGINX authorization
 
# Manage users

https://www.mediawiki.org/wiki/Manual:CreateAndPromote.php
+ createAndPromote.php is a maintenance script that creates a new user or modifies an existing user.
+ `maintenance/createAndPromote.php`

https://www.mediawiki.org/wiki/Manual:Account_creation
https://www.mediawiki.org/wiki/Manual:Preventing_access#Restrict_account_creation

