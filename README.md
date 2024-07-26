# Ikariam Empire Overview
Fork of [MrFix's "Empire Overview"](https://greasyfork.org/fr/scripts/456297-empire-overview) to fix it under Firefox.

## Get started

### For end-users and Ikariam's players
- Watch this repository to survey its futures releases.

### For developers or contributors
- Retrieve and clone this repository on your desktop,
- Install PHP for Windows ;
  - Open 'cmd' terminal from your repository clone,
  - Call "bin\get-php",
- Or setup your PHP environment manually ;
  - Create "config\php-env.bat" file ;
    - See "config\php-env.bat.dist" as template,
    - OpenSSL extension required for Composer,
    - Call "bin\get-ca-bundle" to obtain root certificates for Curl & OpenSSL,
  - Call "bin\env" to check your configuration,
  - Install Composer ;
    - Call "bin\get-composer",
    - Call "composer install", 
- Start PHP built-in web server,
  - Call "bin\php-server",
-   Open ["http://localhost/"](http://localhost/) in any web browser.

## ToDos: for repository project
- [x] Create dev environment ;
  - [x] setup CLI environment,
  - [x] try serve dev release with PHP built-in server ;
    - see "sandbox" branch,  
    - [x] test with static file, seem OK ;
      - need disable Firefox AdBlock (uBlock Origin),
      - [x] test with require main.js,
        - Tampermonkey keep cached required files
      - [ ] test live updating,
        - need to serve meta.js rendered with PHP to push new version number related to files modification,
  - [ ] service to manage dev release
- [ ] batch to build release ;
  - [ ] try use twig to render final js file,
    - [x] batch & environment to use composer
  - [ ] meta template,
  - [ ] dev release with require of main.js,
  - [ ] GreasyFork release for [webhook](https://greasyfork.org/fr/users/webhook-info).

## ToDos: fixes for userscript

### Any browser or scripts manager
- [ ] meta namespace more specific,
- [ ] meta includes & excludes without regexp,
- [ ] meta author formatted ;
  - https://sourceforge.net/p/greasemonkey/wiki/Metadata_Block/#author
  - [ ] find how to format several authors,
- [ ] not fetch corruption value from town hall (while revolution),
- [ ] lost transports data (while show army advisor view),
- [ ] don't support Pluton deity bonus,
- [ ] sometime lost satisfaction (cause unknown),
- [ ] missing or wrong french translation,
- [ ] wrong unit training remained time,
- [ ] restore standard window.console,
  - Ikariam replace it with badly shim.

### Firefox
- [x] analyze in progress...
  - fetch cities list, seem ok,
  - fetch city buildings and levels, seem ok,
  - fetch cities resources, seem ok,
  - fetch cities troops, seem ok,
  - [ ] review any fetching source code,
- [ ] can't close any window ;
  - **critical issue**
  - TypeError: $(...).find(...).dropdown is not a function
- [ ] buildings tab click error ;
  - TypeError: building is undefined

### Chrome
- nothing specific known.

