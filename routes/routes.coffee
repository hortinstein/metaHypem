api = require('./api')
user = require('./user')

return_routes = () ->
  return {
    index: require('./index').index,
    popular: require('./index').popular,
    latest: require('./index').latest,
    signup: require('./accounts').signup,
    signup_post: require('./accounts').signup_post,
    login: require('./accounts').login,
    login_post: require('./accounts').login_post,
    about: require('./index').about,
    download: require('./index').download,
    search: require('./index').search
  }

attach_routes = (app) ->
  routes = return_routes()
  app.get('/', routes.index);
  app.get('/home', routes.index);
  app.get('/popular/:page?', routes.popular);
  app.get('/latest/:page?', routes.latest);
  app.get('/login', routes.login);
  app.post('/login', routes.login_post);
  app.get('/signup', routes.signup);
  app.post('/signup', routes.signup_post);
  app.get('/about', routes.about);
  app.get('/search', routes.search);
  app.get('/download/:id', routes.download);
  app.get('/api/search', api.search);
  app.get('/users', user.list);

exports.return_routes = return_routes
exports.attach_routes = attach_routes