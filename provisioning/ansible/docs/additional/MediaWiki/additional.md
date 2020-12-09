# Install


After logging in and clicking `Edit` I get the error: `Error contacting the Parsoid/RESTBase server: http-bad-status`

Debuging network in Chrome:

https://discuss-wiki.colabo.space/api.php?action=visualeditor&format=json&paction=parse&page=Main_Page&uselang=en-gb&formatversion=2&oldid=1

```json
{
	"error": {
		"code": "apierror-visualeditor-docserver-http-error",
		"info": "Error contacting the Parsoid/RESTBase server: http-bad-status",
		"docref": "See https://discuss-wiki.colabo.space/api.php for API usage. Subscribe to the mediawiki-api-announce mailing list at &lt;https://lists.wikimedia.org/mailman/listinfo/mediawiki-api-announce&gt; for notice of API deprecations and breaking changes."
	}
}
```

# RESTBase

https://www.mediawiki.org/wiki/RESTBase

## Extension:WYSIWYG

+ It seems this is [the official one](https://www.mediawiki.org/wiki/WYSIWYG_editor#Mediawiki_extensions)

https://www.mediawiki.org/wiki/Extension:WYSIWYG
https://github.com/Mediawiki-wysiwyg/WYSIWYG-CKeditor/issues/125
+ овај одговор је помогао Лази, њега је испратио и прорадило је
+ https://github.com/Mediawiki-wysiwyg/WYSIWYG-CKeditor/issues/125#issuecomment-571145003
https://github.com/Mediawiki-wysiwyg/WYSIWYG-CKeditor/issues/122
https://www.mediawiki.org/wiki/Topic:To7pgn923finhvwd

## Parsoid

https://www.mediawiki.org/wiki/Parsoid
https://upload.wikimedia.org/wikipedia/commons/d/d8/The_Long_And_Winding_Road_To_Making_Parsoid_The_Default_MediaWiki_Parser.pdf

https://github.com/wikimedia/parsoid/tree/master/extension
+ The Parsoid extension exports a REST API for Parsoid. It is only needed if you are running RESTBase as a caching layer in front of Parsoid.

[API](https://www.mediawiki.org/wiki/Parsoid/API)

[RESTBase](https://www.mediawiki.org/wiki/RESTBase)
+ RESTBase is a caching / storing API proxy backing the Wikimedia REST API.

[Parsoid/JS](https://www.mediawiki.org/wiki/Parsoid/JS)
+ This page documents Parsoid/JS, which was **replaced by Parsoid/PHP** in 2020.

[Parsoid/PHP](https://www.mediawiki.org/wiki/Parsoid/PHP)


```sh
cd /var/www
git clone https://phabricator.wikimedia.org/diffusion/GPAR/ parsoid-php
```

```php
$PARSOID_INSTALL_DIR = '/var/www/parsoid-php';

// For developers: ensure Parsoid is executed from $PARSOID_INSTALL_DIR,
// (not the version included in mediawiki-core by default)
// Must occur *before* wfLoadExtension()
if ( $PARSOID_INSTALL_DIR !== 'vendor/wikimedia/parsoid' ) {
    AutoLoader::$psr4Namespaces += [
        // Keep this in sync with the "autoload" clause in
        // $PARSOID_INSTALL_DIR/composer.json
        'Wikimedia\\Parsoid\\' => "$PARSOID_INSTALL_DIR/src",
    ];
}

wfLoadExtension( 'Parsoid', "$PARSOID_INSTALL_DIR/extension.json" );

# Manually configure Parsoid
$wgVisualEditorParsoidAutoConfig = false;
$wgParsoidSettings = [
    'useSelser' => true,
    'rtTestMode' => false,
    'linting' => false,
];
$wgVirtualRestConfig['modules']['parsoid'] = [];
```

```sh
sudo joe /etc/nginx/sites-available/wiki-colabo-discuss
```

```yml
location /rest.php/ {
    try_files $uri $uri/ /rest.php?$query_string;
}
```

```sh
# test
sudo nginx -t
# restart
sudo service nginx restart
```

```sh
cd /var/www/wiki-colabo-discuss
# ./rest.php/localhost/v3/page/html/Main%20Page
```

https://discuss-wiki.colabo.space/rest.php/discuss-wiki.colabo.space/v3/page/html/Main_Page/2

https://discuss-wiki.colabo.space/rest.php/discuss-wiki.colabo.space/v3/page/html/Main%20Page

https://discuss-wiki.colabo.space/rest.php/discuss-wiki.colabo.space/v3/page/html/Main_Page/2?redirect=false&stash=true

https://discuss-wiki.colabo.space/api.php?action=visualeditor&format=json&paction=parse&page=Main_Page&uselang=en-gb&formatversion=2&oldid=2

```sh
# check if MediaWiki API is available
curl https://discuss-wiki.colabo.space/api.php
```

Check versions: https://discuss-wiki.colabo.space/index.php?title=Special:Version

https://www.mediawiki.org/wiki/Extension:VisualEditor#Linking_with_Parsoid_in_private_wikis
+ If you do set any property in $wgVirtualRestConfig['modules']['parsoid'] you will have to manually install Parsoid or VisualEditor will not work!


```sh
joe /var/www/wiki-colabo-discuss/LocalSettings.php
```

```php
$wgVirtualRestConfig['modules']['parsoid']['url'] = "https://discuss-wiki.colabo.space/parsoid"
```

```php
$wgVirtualRestConfig['modules']['parsoid'] = array(
	'url' => 'http://localhost:8142',
	'forwardCookies' => true
);
```

https://www.mediawiki.org/wiki/Parsoid/API

Try to use parsoid over visualeditor: 
https://discuss-wiki.colabo.space/api.php?action=visualeditor&format=json&paction=parse&page=Main_Page&uselang=en-gb&formatversion=2&oldid=1

Help:
+ https://www.mediawiki.org/wiki/API:Main_page
  + https://www.mediawiki.org/w/api.php?action=help&modules=visualeditor
+ https://discuss-wiki.colabo.space/api.php
  + https://discuss-wiki.colabo.space/api.php?action=help&modules=visualeditor



[Manual:How to debug](https://www.mediawiki.org/wiki/Manual:How_to_debug)

To see PHP errors, add this at the beginning of: `LocalSettings.php`:

```php
error_reporting( -1 );
ini_set( 'display_startup_errors', 1 );
ini_set( 'display_errors', 1 );
$wgDebugComments = true;
$wgDebugLogFile = "/var/log/mediawiki/debug-{$wgDBname}.log";
```

```sh
sudo mkdir /var/log/mediawiki/
sudo chgrp www-data -R /var/log/mediawiki/
sudo chown mprinc -R /var/log/mediawiki/
sudo chmod ug+rwx -R /var/log/mediawiki/
```

From `/etc/nginx/sites-available/wiki-colabo-discuss`:
/var/log/nginx/wiki-colabo-discuss.access.plus.log
/var/log/nginx/wiki-colabo-discuss.error.log

```php
error_reporting( -1 );
ini_set( 'display_errors', 1 );
$wgDebugLogFile = "/var/log/mediawiki/debug-{$wgDBname}.log";
```

```sh
joe /var/log/mediawiki/debug-
```

```yml
# catches anything starting with this location
location /parsoid/ {
    # take out the `parsoid/` from the proxy forward
    # (please see it the `url` in the `ghost-config.j2`)
    rewrite /parsoid/(.*) /$1  break;

    # tells server what is the real client address before proxy got in between
    proxy_set_header X-Real-IP $remote_addr;
    # comma separated list of proxy hopps
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    # This is what tells Connect that your session
    # can be considered secure (client <-> proxy),
    # even though the protocol node.js sees is only HTTP (proxy <-> server)
    # $scheme will be `https` if it was https between client and proxy
    proxy_set_header X-Forwarded-Proto $scheme;

    # Seting Host header
    # http://nginx.org/en/docs/http/ngx_http_core_module.html#var_host
    # proxy_set_header Host $http_host;
    proxy_set_header Host $host;

    proxy_pass http://127.0.0.1:;

    proxy_set_header X-NginX-Proxy true;
}
```

## Issues

[Topic on VisualEditor/Feedback](https://www.mediawiki.org/wiki/Topic:Rbnlhxzcs7xumz3a)


# Extension

https://www.mediawiki.org/wiki/Manual:Extensions
https://www.mediawiki.org/wiki/Category:Extensions_by_category
https://www.mediawiki.org/wiki/WYSIWYG_editor

## Extension: VisualEditor

[Private Wikis](https://www.mediawiki.org/wiki/Extension:VisualEditor#Linking_with_Parsoid_in_private_wikis)
[Topic on Extension talk:VisualEditor](https://www.mediawiki.org/wiki/Topic:Tm2qsg4ywsykmahr)

```php
wfLoadExtension( 'VisualEditor' );


// Optional: Set VisualEditor as the default for anonymous users
// otherwise they will have to switch to VE
$wgDefaultUserOptions['visualeditor-editor'] = "visualeditor";

// Don't allow users to disable it
$wgHiddenPrefs[] = 'visualeditor-enable';

// OPTIONAL: Enable VisualEditor's experimental code features
$wgDefaultUserOptions['visualeditor-enable-experimental'] = 1;

// Forward users' Cookie: headers to Parsoid. Required for private wikis (login required to read).
// If the wiki is not private (i.e. $wgGroupPermissions['*']['read'] is true) this configuration
// variable will be ignored.
//
// WARNING: ONLY enable this on private wikis and ONLY IF you understand the SECURITY IMPLICATIONS
// of sending Cookie headers to Parsoid over HTTP.
$wgVirtualRestConfig['modules']['parsoid']['forwardCookies'] = true;
```

### Install

```sh
sudo chgrp -R developers .
cd /var/www/wiki-colabo-discuss/extensions
git clone https://github.com/Mediawiki-wysiwyg/WYSIWYG-CKeditor.git WYSIWYG-src
ln -s WYSIWYG-src/WYSIWYG  WYSIWYG
ln -s WYSIWYG-src/SemanticForms SemanticForms
mv WikiEditor WikiEditor-org
ln -s WYSIWYG-src/WikiEditor WikiEditor
```

Activate WYSIWYG by adding following lines valid to your system at the bottom of your LocalSettings.php:

```sh
joe /var/www/wiki-colabo-discuss/LocalSettings.php

# WYSIWYG
# ---
# Default user options:
$wgDefaultUserOptions['riched_disable']               = false;
$wgDefaultUserOptions['riched_start_disabled']        = false;
$wgDefaultUserOptions['riched_use_toggle']            = true; 
$wgDefaultUserOptions['riched_use_popup']             = false;
$wgDefaultUserOptions['riched_toggle_remember_state'] = true;
$wgDefaultUserOptions['riched_link_paste_text']       = true;

// MW>=1.26 and versions of WYSIWYG >= "1.5.6_0 [B551+02.07.2016]"
wfLoadExtension( 'WYSIWYG' );

// MW>=1.26 and versions of WYSIWYG >= "1.5.6_0 [B551+02.07.2016]" has dependency
// to module of WikiEditor so it must be enabled too (or otherwise file
// extension.json has to be edited manually to remove dependency)
wfLoadExtension( 'WikiEditor' );
```

### Issues

+ [MW 1.33 - incompatible #125](https://github.com/Mediawiki-wysiwyg/WYSIWYG-CKeditor/issues/125)
+ https://www.mediawiki.org/wiki/Topic:V61itd7s851t2vm9

## Public wikipedia

[Manual:Preventing access](https://www.mediawiki.org/wiki/Manual:Preventing_access)

Necessary for PARSOID

```php
########################################
# Making public, Parsoid needs it (at the moment? :) )
########################################

# Disable reading by anonymous users
$wgGroupPermissions['*']['read'] = true;

# Disable anonymous editing
$wgGroupPermissions['*']['edit'] = true;

# Prevent new user registrations except by sysops
$wgGroupPermissions['*']['createaccount'] = true;
```

## Problem with http login

https://discuss.freedombox.org/t/solved-mediawiki-login-after-installation-not-possible/570

https://www.mediawiki.org/wiki/Topic:T7irqyk4rhfy3ohk

https://www.mediawiki.org/wiki/Thread:Project:Support_desk/Session_Hijacking_error_after_Update_1.19.14

https://community.fandom.com/f/p/2663713232388098737

https://stackoverflow.com/questions/38812604/cant-log-in-to-mediawiki-canceled-as-a-precaution-against-session-hijacking

https://www.mediawiki.org/wiki/Manual:$wgSessionCacheType

```php
$wgSessionCacheType = CACHE_DB;
$wgMainCacheType = CACHE_NONE
$wgMainCacheType = CACHE_DB;
```

## Error contacting the Parsoid/RESTBase server: http-bad-status

+ https://discuss-wiki.colabo.space/api.php?action=visualeditor&format=json&paction=parse&page=Main_Page&uselang=en-gb&formatversion=2&oldid=3&debug=true
+ https://discuss-wiki.colabo.space/api.php?action=visualeditor&format=json&paction=parse&page=Main_Page&uselang=en-gb&formatversion=2&oldid=0&debug=true
