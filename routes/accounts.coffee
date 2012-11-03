http = require('http')

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
  
#signup
exports.signup = signup
exports.signup_post = signup_post
exports.login = login
exports.login_post = login_post