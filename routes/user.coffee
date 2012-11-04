hypem_parser = require('hypemParser/hypemscraper');
AM = require('accountManager/accountManager')

try
  config = require('../config.json')
catch error 
  console.log(error,"no config")
AM.setup(config)


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
      songs: valid_tracks
      page: page

    res.render 'users/account', options

login = (req, res) ->
  options =
    id: 'login'
    title: 'Please Login!'

  res.render 'users/login', options

signup = (req, res) ->
  options =
    id: 'signup'
    title: 'Signup!'
  res.render 'users/signup', options

signup_post = (req, res) ->
  new_account =
    email: req.body.email 
    username: req.body.email 
    pass: req.body.password
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


#signup
exports.signup = signup
exports.signup_post = signup_post
exports.login = login
exports.account = account