attach_routes = (app) ->
  user = require('./user')
  routes = require('./index')

  app.get('/', routes.index)
  app.get('/home', routes.index)
  app.get('/popular/:page?', routes.popular)
  app.get('/latest/:page?', routes.latest)

  app.get('/about', routes.about)
  app.get('/search', routes.search)
  app.get('/download/:id', routes.download)
  app.get('/account', ensureAuthenticated, user.account)
  app.get('/signup', user.signup)
  app.post('/signup', user.signup_post)
  app.get('/login', user.login)
  app.get('*', routes.not_found)

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