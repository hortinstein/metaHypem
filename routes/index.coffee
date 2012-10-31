hypem_parser = require('hypemParser/hypemscraper');
http = require('http')
fs = require('fs')
request = require('request')
#
#GET home page.
#

index = (req, res) ->
  options =
    id: 'home'
    tab: 'popular'
    title: 'Look for songs!'
  res.render 'index', options
  
  
popular = (req, res) ->
  options =
    id: 'home'
    tab: 'popular'
    title: 'Look for songs!'
  res.render 'index', options
  
 
latest = (req, res) ->
  options =
    id: 'home'
    tab: 'latest'
    title: 'Look for songs!'
  res.render 'index', options
  
  
search = (req, res) ->

  unless req.query.query?
    #if there is no query argument then just return
    #the normal search page
    options =
      id: 'home'
      tab: 'search'
      title: 'Look for songs!'
      songs: []
    res.render 'search', options
    return

  #At this point we have a valid query so lets return some tracks!
  hypem_parser.search query, (valid_tracks)->
    options =
      id: 'home'
      tab: 'search'
      title: 'Look for songs!'
      songs: valid_tracks

    res.render 'search', options

about = (req, res) ->
  options =
    id: 'about'
    title: 'About'
  res.render 'about', options

login = (req, res) ->
  options =
    id: 'login'
    title: 'Please Login!'
  res.render 'login', options

login_post = (req, res) ->
  options =
    id: 'login_post'
    title: 'Please Login!'
  console.log('login info, need call to acctMgr', req.body)
  res.render "login", options

signup = (req, res) ->
  options =
    id: 'signup'
    title: 'Signup!'
  res.render 'signup', options

signup_post = (req, res) ->
  options =
    id: 'signup'
    title: 'Signup!'
  console.log('signup info, need call to acctMgr', req.body)
  res.render 'signup', options

download = (req, res) ->
  song_id = req.params.id
  hypem_parser.get_download_url song_id, (download_url)->
    console.log("Returning download from: #{download_url}")
    
    res.set('Content-Type', 'audio/mpeg')
    res.set('Content-Disposition', 'attachment')
    request(download_url).pipe(res)
  (err)->
    console.error(err)

#general flow
exports.index = index
exports.about = about
exports.download = download

#main tabs
exports.popular = popular
exports.latest = latest
exports.search = search

#signup
exports.signup = signup
exports.signup_post = signup_post
exports.login = login
exports.login_post = login_post

exports.about = about
exports.download = download