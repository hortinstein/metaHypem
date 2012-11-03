mongoose = require('mongoose')
Account = require("../models/account")
hypem_parser = require('hypemParser/hypemscraper');

account = (req, res) ->
  unless req.params.page
    req.params.page = 1
  else
    req.params.page = parseInt(req.params.page)

  page = req.params.page
  #At this point we have a valid query so lets return some tracks!
  hypem_parser.scrape "http://hypem.com/#{req.user.username}/#{page}", (valid_tracks)->
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

  new_account = new Account(req.body)

  console.log("Created new account ")

  new_account.validate (err)->
    if err
      req.flash('error', "You are missing some fields!" )
      options =
        id: 'signup'
        title: 'Signup!'

      res.render 'users/signup', options
    else
      new_account.save (err)->
        if err
          req.flash('error', "This e-mail has already been registered." )
          options =
            id: 'signup'
            title: 'Signup!'
          res.render 'users/signup', options
        else
          req.flash("success", "Welcome #{new_account.username}")
          req.login new_account, (err)->
          res.redirect("/account")


#signup
exports.signup = signup
exports.signup_post = signup_post
exports.login = login
exports.account = account