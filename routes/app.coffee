hypem_parser = require('hypemParser/hypemscraper')
http = require('http')
fs = require('fs')
request = require('request')
redis = require('redis')
Config = require('config')
check = require('validator').check

redis_client = redis.createClient(Config.Cache.port, Config.Cache.host)


index = (req, res) ->
  popular req, res
  
  
popular = (req, res) ->

  unless req.params.page
    req.params.page = 1
  else
    req.params.page = parseInt(req.params.page)

  page = req.params.page
  #At this point we have a valid query so lets return some tracks!
  hypem_parser.scrape "http://hypem.com/popular/#{page}", (valid_tracks)->
    options =
      id: 'home'
      tab: 'popular'
      title: 'Popular'
      songs: valid_tracks
      page: page

    res.render 'index', options
  
 
latest = (req, res) ->
  
  unless req.params.page
    req.params.page = 1
  else
    req.params.page = parseInt(req.params.page)

  page = req.params.page
  #At this point we have a valid query so lets return some tracks!
  hypem_parser.scrape "http://hypem.com/latest/#{page}", (valid_tracks)->
    options =
      id: 'home'
      tab: 'latest'
      title: 'Latest'
      songs: valid_tracks
      page: page

    res.render 'index', options
  
  
search = (req, res) ->

  unless req.params.page
    req.params.page = 1
  else
    req.params.page = parseInt(req.params.page)

  page = req.params.page

  unless req.query.query?
    #if there is no query argument then just return
    #the normal search page
    options =
      id: 'home'
      tab: 'search'
      title: 'Look for songs!'
      songs: []
      page: page

    res.render 'search', options
    return

  query = req.query.query

  try
    check(query).isUrl()
    #At this point they are trying to search for a specific url. Look for that!
    hypem_parser.scrape query, (valid_tracks)->
      options =
        id: 'home'
        tab: 'search'
        title: 'Look for songs!'
        songs: valid_tracks
        page: page

      res.render 'search', options
  catch error
    #At this point we have a valid query so lets return some tracks!
    hypem_parser.search query, (valid_tracks)->
      options =
        id: 'home'
        tab: 'search'
        title: 'Look for songs!'
        songs: valid_tracks
        page: page

      res.render 'search', options


about = (req, res) ->
  redis_client.get "global_downloads", (e,num_downloads) ->  
    options =
      id: 'about'
      title: 'About'
      downloads: num_downloads
    res.render 'about', options
not_found = (req, res) ->
    options =
      id: 'not_found'
      title: 'Not found...'
    res.render 'not_found', options

download = (req, res) ->
  song_id = req.params.id
  hypem_parser.get_download_url song_id, (track, download_url)->
    console.log("Returning download from: #{download_url}")
    res.set('Content-Type', 'audio/mpeg')
    res.set('Content-Disposition', 'attachment; filename="'+track.title+'.mp3"')
    request.get(download_url).pipe(res)
    #For some reason, express.js on a response end event emits a finish
    #http://www.samcday.com.au/blog/2011/06/27/listening-for-end-of-response-with-nodeexpress-js/
    res.on "finish", ()->
      console.log("Completed song download") 
      #Increase our global download count by 1 (not song specific so keeping here instead of scraper)
      redis_client.incr "global_downloads" 
      #Do song specific stuff like increase download count
      hypem_parser.song_downloaded(song_id)

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

exports.about = about
exports.download = download
exports.not_found = not_found