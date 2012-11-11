hypem_parser = require('hypemParser/hypemscraper');
AM = require('accountManager/accountManager')
Config = require('config');
redis = require('redis')
redis_client = redis.createClient(Config.Cache.port, Config.Cache.host)

account = (req, res) ->
  unless req.params.page
    req.params.page = 1
  else
    req.params.page = parseInt(req.params.page)

  page = req.params.page
  #At this point we have a valid query so lets return some tracks!
  hypem_parser.scrape "http://hypem.com/#{req.user.hypem_username}/#{page}", (valid_tracks)->
    options =
      id: 'account'
      title: 'Welcome'
      tab: 'hypem_user_parse'
      songs: valid_tracks
      page: page
    res.render 'users/account', options

login = (req, res) ->
  options =
    id: 'login'
    title: 'Please Login!'
    tab: 'hypem_user_parse'

  res.render 'users/login', options

signup = (req, res) ->
  options =
    id: 'signup'
    title: 'Signup!'
  res.render 'users/signup', options

playlist = (req, res) ->
  redis_client.smembers('playlist::'+req.user.username, (e,r)->
    tracks = []
    multi = redis_client.multi()
    for song in r
      multi.hgetall(song)
    multi.exec( (e, r) ->
        options =
          id: 'playlist'
          title: 'Playlist!'
          tab: 'playlist'
          songs: r
        res.render 'users/playlist', options
    )
    tracks_json = JSON.stringify(tracks)
  )
  

signup_post = (req, res) ->
  new_account =
    email: req.body.email 
    pass: req.body.password
    username: req.body.email
    hypem_username: req.body.username

  AM.signup new_account, (err)->
    if err
      req.flash('error', err)
      options =
        id: 'signup'
        title: 'Signup!'

      res.render 'users/signup', options
    else
      console.log("Created new account ")
      req.flash("success", "Welcome #{new_account.username}")
      req.login new_account, (err)->
      res.redirect("/account")

add_to_playlist = (req,res) ->
  redis_client.sadd('playlist::'+req.user.username, req.body.songid)

#signup
exports.signup = signup
exports.signup_post = signup_post
exports.login = login
exports.account = account
exports.add_to_playlist = add_to_playlist
exports.playlist = playlist