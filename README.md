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


##Deployment##

###Linode###

####Introduction####
Currently we have deployment options available on linode on the host 198.74.50.232 or via the domain [fzakaria.com](http://fzakaria.com). You can log onto the linode machine via SSH
`ssh <username>@fzakaria.com`.

####Setup####
The server is setup with [Nginx](http://nginx.org/) (pronounced EngineX) as the front end to Node.JS. The choice of a front-end HTTP server is important. Nginx is an event based HTTP server (similar to Node.JS) and is therefore non blocking. Although we could have just run the node server as is, having the Nginx front-end allows us to run multiple sites easily (such as my wordpress blog).

####Running####
On the Linode machine you can use [forever](https://github.com/nodejitsu/forever) to start the node app as a daemon. Typical commands are 
