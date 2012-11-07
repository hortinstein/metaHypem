#MetaDownloaderSite#

##Development##

###Installation###
1. `git clone` the current metaHypem repository + any other development packages (i.e. hypemParser or accountManager)
2.  execute `sudo npm link` in all node packages that will be under development
3.  execute `sudo npm link <package name>` in metaHypem to link to the development package.
4.  Launch the server with hot reload on code change `supervisor -e 'node|js|html|jade|coffee|css' app.js`

##Deployment##

###Linode###

####Introduction####
Currently we have deployment options available on linode on the host 198.74.50.232 or via the domain [fzakaria.com](http://fzakaria.com). You can log onto the linode machine via SSH
`ssh <username>@fzakaria.com`.

####Setup####
The server is setup with [Nginx](http://nginx.org/) (pronounced EngineX) as the front end to Node.JS. The choice of a front-end HTTP server is important. Nginx is an event based HTTP server (similar to Node.JS) and is therefore non blocking. Although we could have just run the node server as is, having the Nginx front-end allows us to run multiple sites easily (such as my wordpress blog).
Redis is currently running on the same linode instance as a caching layer.

####Running####
On the Linode machine you can use [forever](https://github.com/nodejitsu/forever) to start the node app as a daemon. Typical commands are `forever start app.js` or `forever list` to see a list of all running node applications.

####Common Operations####
1. `sudo service nginx restart` - restart the nginx server
2. `sudo nginx_ensite <sitename>` (or nginx_dissensite) - enable/disable the site configuration file for each virtual host (found in /etc/nginx/sites-available/)

##TO DO##
1. Polish AccountManager branch
2. Merge AccountManager branch into master branch
3. Create Release branch
4. Tag a commit in Release branch as 0.1
5. Deploy to Linode release branch 
6. 404 and 505 page
7. Setup production vs development settings. For instance in production stylus shouldnt generate CSS and it should just serve the static file
8. Add TTL for hypemParser records
9. Change layout to use accordian style from Github
10. Added new node user on linode and add alex, me and node to www-data group.
11. register domain metahypem.com with google
12. Setup domain to point to app on linode
13. Setup Google App account
14. Polish About page (add donations)