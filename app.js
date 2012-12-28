require('coffee-script');

var express = require('express')
  , AM = require('accountManager/accountManager')
  , routes = require('./routes/routes')
  , hypemParser = require('hypemParser/hypemscraper')
  , Config = require('config')
  , http = require('http')
  , path = require('path')
  , mongoose = require('mongoose')
  , passport = require('passport')
  , flash = require('connect-flash')
  , LocalStrategy = require('passport-local').Strategy
  //http://www.hacksparrow.com/use-redisstore-instead-of-memorystore-express-js-in-production.html
  , RedisStore = require('connect-redis')(express);

/*Let us setup all our databases and configurations
that are specific to development or production settings.
These shoudl go at the start so all setup can initialize any database
connections we need as early as possible
*/
AM.setup(Config.AM, function(err) {
  if (err){
    console.log("Error building/setting up DB...", err);
  }
});

hypemParser.setup(Config.Cache);

var app = express();
var server = http.createServer(app);

// Helper function to add user to every response object for views
var add_user = function(req, res, next){
  res.locals.user = req.user;
  next();
  };

// Expose the flash function to the view layer
var expose_flash = function(req, res, next) {
    res.locals.flash = function(type) { return req.flash(type) };
    next();
  }

app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(require('stylus').middleware(__dirname + '/public'));
  app.use(express.static(__dirname + '/public'));
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser('your secret here'));
  //app.use(express.session());
  //In production environments we shouldn't be using the basic express.session management but rather Redis one.
  //This configuration assumes localhost redis client.
  app.use(express.session({ store: new RedisStore, secret: 'meandalexaremakingsuchacoolsite' }));
  app.use(flash());
  app.use(expose_flash);
  app.use(passport.initialize());
  app.use(passport.session());
  app.use(add_user);
  app.use(app.router);
});

app.configure('development', function(){
  app.use(express.errorHandler({showStack: true, dumpExceptions: true}));
});
app.configure('production', function(){
});


/* Account Management and Passport Settings start Here */
// Define local strategy for Passport
// usernameField is how we tell it what input type name to look for
passport.use(new LocalStrategy({
    usernameField: 'email',
    passwordField: 'password'
  },
  function(email, password, done) { 
    console.log(email,password)
    AM.manualLogin(email, password, function(err, user) {
        if (err || !user)   { return done(null, false, { message: err }); }
        if (!user) { return done(null, false, { message: 'Incorrect e-mail & password combination.' }); }
        return done(null, user);
    })
  }
));

/*
 If authentication succeeds, a session will be established and maintained via a cookie set in the user's browser.
Each subsequent request will not contain credentials, but rather a unique cookie that identifies the session. 
In order to support login sessions, Passport can serialize and deserialize user instances to and from the session.
*/
passport.serializeUser(function(user, done) {
  done(null, user.email);
});

passport.deserializeUser(function(id, done) {
  AM.getByEmail(id, function (err, user) {
    if (err) {
      //We have a problem finding the user, so invalidate the existing login session.
      done(null, false, { message: err } );
    }
    else{
      done(null, user);
    }
  });
});

//Setting the failureFlash option to true instructs Passport to flash an error message using the message given by the strategy's verify callback,
app.post('/login', 
  passport.authenticate('local', { failureRedirect: '/login', failureFlash: true }),
  function(req, res) {
    req.flash("success", "Welcome, " + req.user.username)
    res.redirect('/');
  });

app.get('/logout', function(req, res){
  req.flash("success", " Logged out of account " + req.user.username)
  req.logout();
  res.redirect('/');
});

routes.attach_routes(app);

//The following was taken from http://veebdev.wordpress.com/2012/03/27/expressive-way-to-handle-errors-in-expressjs/
// It is the "expressive.js way to handle errors."
// These will only show up on production environment.
app.use(function(err, req, res, next){
  if (err instanceof NotFound) {
    res.render('404', { title: 'Not found 404', error: err });
  } else {
    res.render('500', { title: 'Error', error: err });
  }
});

app.get('/404', function(req, res, next){
  // trigger a 404 since no other middleware
  // will match /404 after this one, and we're not
  // responding here
  next();
});

app.get('/403', function(req, res, next){
  // trigger a 403 error
  var err = new Error('not allowed!');
  err.status = 403;
  next(err);
});

app.get('/500', function(req, res, next){
  // trigger a generic (500) error
  next(new Error('keyboard cat!'));
});

/* Since this is the last non-error-handling
 middleware use()d, we assume 404, as nothing else
 responded.
 */
app.get('/*', function(req, res){
    throw new NotFound;
});

function NotFound(msg){
    this.name = 'NotFound';
    Error.call(this, msg);
    Error.captureStackTrace(this, arguments.callee);
}


server.listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});