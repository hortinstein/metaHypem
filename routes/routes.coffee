attach_routes = (app) ->
  user = require('./user')
  metahypem = require('./app')

  app.get('/', metahypem.index)
  app.get('/home', metahypem.index)
  app.get('/popular/:page?', metahypem.popular)
  app.get('/latest/:page?', metahypem.latest)

  app.get('/about', metahypem.about)
  app.get('/search', metahypem.search)
  app.get('/download/:id', metahypem.download)
  app.get('/account/:page?', ensureAuthenticated, user.account)
  app.get('/signup', user.signup)
  app.post('/signup', user.signup_post)
  app.get('/login', user.login)

# Simple route middleware to ensure user is authenticated.
#   Use this route middleware on any resource that needs to be protected.  If
#   the request is authenticated (typically via a persistent login session),
#   the request will proceed.  Otherwise, the user will be redirected to the
#   login page.
ensureAuthenticated = (req, res, next) ->
  console.log("checking authentication")
  if req.isAuthenticated() 
    return next()
  res.redirect('/login')


exports.attach_routes = attach_routes