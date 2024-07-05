# Ikariam Empire Overview
Fork of [MrFix's "Empire Overview"](https://greasyfork.org/fr/scripts/456297-empire-overview) to fix it under Firefox.

## Get started

### For end-users and Ikariam's players
- Watch this repository to survey its futures releases.

### For developers or contributors
- Retrieve and clone this repository on your desktop,
- Set your desktop web server to "public" directory ;
  - Set your PHP environment in "config\php-env.bat",
  - See "config\php-env.bat.dist" as template,
- Or create dedicated local web server with PHP for Windows ;
  - Open 'cmd' terminal from your repository clone,
  - Call "bin\get-php",
- Start your web server,
- Open local host in any web browser.

## ToDos
- [x] Create dev environment
  - [x] setup CLI environment
  - [ ] try serve dev release with PHP built-in server
- [ ] batch to build release
  - [ ] meta template
  - [ ] dev release with require of main.js
  - [ ] GreasyFork release for [webhook](https://greasyfork.org/fr/users/webhook-info)
- [ ] fix meta
  - [ ] namespace
- [ ] fix for Firefox
  - [ ] list console errors
