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
    title: 'Look for songs!'
  res.render 'index', options

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

search = (req, res) ->

  query = req.query.query

  hypem_parser.search query, (valid_tracks)->
    options =
      id: 'home'
      title: 'Look for songs!'
      songs: valid_tracks

    res.render 'search', options

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




exports.search = search
exports.signup = signup
exports.signup_post = signup_post
exports.login = login
exports.login_post = login_post
exports.index = index
exports.about = about
exports.download = download