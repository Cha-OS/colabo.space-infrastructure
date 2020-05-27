# Conversion

https://pandoc.org/demos.html

pandoc -f html -t mediawiki -s KFInfrastructure.html -o KFInfrastructure.wiki

# Install

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
    + db user name: wiki
    + db pass: empty
    + next page
+ provide:
    + name: discuss-wiki
    + username: chaos
    + pass: from keepass
    + email: chaos.ngo@gmail.com
    + disable: Share data about this installation with MediaWiki developers
    + next page
+ set
    +  Private wiki
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
        + https://colabo.space/data/images/logos/colabo-logo-with-url.png
        + Enable Instant Commons
    + next
+ download: `LocalSettings.php`
+ upload `LocalSettings.php`
    + NOTE: this might be automated with ansible

# Extension

https://www.mediawiki.org/wiki/Manual:Extensions
https://www.mediawiki.org/wiki/Category:Extensions_by_category

## Extension:WYSIWYG

https://www.mediawiki.org/wiki/Extension:WYSIWYG
https://github.com/Mediawiki-wysiwyg/WYSIWYG-CKeditor/issues/125
+ овај одговор је помогао Лази, њега је испратио и прорадило је
+ https://github.com/Mediawiki-wysiwyg/WYSIWYG-CKeditor/issues/125#issuecomment-571145003
https://github.com/Mediawiki-wysiwyg/WYSIWYG-CKeditor/issues/122
https://www.mediawiki.org/wiki/Topic:To7pgn923finhvwd

Install

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