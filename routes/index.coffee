hypem_parser = require('hypemParser/hypemscraper');
http = require('http')
fs = require('fs')
request = require('request')



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
  #hypem_parser.popular (valid_tracks)->
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
  #hypem_parser.latest (valid_tracks)->
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
  options =
    id: 'about'
    title: 'About'
  res.render 'about', options

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

exports.about = about
exports.download = download