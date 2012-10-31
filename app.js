require('coffee-script');
/**
 * Module dependencies.
 */
var express = require('express')
  , routes = {
    index: require('./routes/index').index,
    signup: require('./routes/index').signup,
    login: require('./routes/index').login,
    login_post: require('./routes/index').login_post,
    about: require('./routes/index').about,
    download: require('./routes/index').download,
    search: require('./routes/index').search
  }
  , api = require('./routes/api')
  , user = require('./routes/user')
  , http = require('http')
  , path = require('path');

var app = express();
var server = http.createServer(app);

app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser('your secret here'));
  app.use(express.session());
  app.use(app.router);
  app.use(require('stylus').middleware(__dirname + '/public'));
  app.use(express.static(path.join(__dirname, 'public')));
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

app.get('/', routes.index);
app.get('/home', routes.index);

app.get('/login', routes.login);
app.post('/login', routes.login_post);

app.get('/signup', routes.signup);

app.get('/about', routes.about);
app.get('/search', routes.search);
app.get('/download/:id', routes.download);
app.get('/api/search', api.search);
app.get('/users', user.list);

server.listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});
