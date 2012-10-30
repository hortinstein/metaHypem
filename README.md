MetaDownloaderSite~!

Installation:

1. Download/Clone metaHypem from Github
2. Download/Clone hypemParser from Github
3. cd hypemParser
4. sudo npm link
5. cd metaHypem
6. npm link hypemParser

Tips:

1 - Install supervisor (npm install -g supervisor) and run with the command
` supervisor -e 'node|js|html|jade|coffee|css' app.js `
This performs server restarts on code change! :)
