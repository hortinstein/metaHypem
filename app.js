require('coffee-script');
/**
 * Module dependencies.
 */
var express = require('express')
  , routes = {
    index: require('./routes/index').index,
    popular: require('./routes/index').popular,
    latest: require('./routes/index').latest,
    about: require('./routes/index').about,
    download: require('./routes/index').download,
    search: require('./routes/index').search
  }
  , user = require('./routes/user')
  , http = require('http')
  , path = require('path')
  , mongoose = require('mongoose')
  , passport = require('passport')
  , flash = require('connect-flash')
  , LocalStrategy = require('passport-local').Strategy;

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
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser('your secret here'));
  app.use(express.session());
  app.use(flash());
  app.use(expose_flash);
  app.use(passport.initialize());
  app.use(passport.session());
  app.use(add_user);
  app.use(app.router);
  app.use(require('stylus').middleware(__dirname + '/public'));
  app.use(express.static(path.join(__dirname, '/public')));
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

app.get('/', routes.index);
app.get('/home', routes.index);
app.get('/popular/:page?', routes.popular);
app.get('/latest/:page?', routes.latest);

app.get('/about', routes.about);
app.get('/search', routes.search);
app.get('/download/:id', routes.download);

/* Account Management and Passport Settings start Here */

//Here is the model for our user Accounts
var Account = require("./models/account");

// Define local strategy for Passport
// usernameField is how we tell it what input type name to look for
passport.use(new LocalStrategy({
    usernameField: 'email'
  },
  function(email, password, done) {
    Account.authenticate(email, password, function(err, user) {
        if (err) { return done(err); }
        if (!user) { return done(null, false, { message: 'Incorrect e-mail & password combination.' }); }
        return done(null, user);
    });
  }
));

/*
 If authentication succeeds, a session will be established and maintained via a cookie set in the user's browser.
Each subsequent request will not contain credentials, but rather a unique cookie that identifies the session. 
In order to support login sessions, Passport can serialize and deserialize user instances to and from the session.
*/
passport.serializeUser(function(user, done) {
  done(null, user._id);
});

passport.deserializeUser(function(id, done) {
  Account.findById(id, function (err, user) {
    done(err, user);
  });
});

app.get('/account', ensureAuthenticated, user.account);

app.get('/signup', user.signup);
app.post('/signup', user.signup_post);

app.get('/login', user.login);

//Setting the failureFlash option to true instructs Passport to flash an error message using the message given by the strategy's verify callback,
app.post('/login', 
  passport.authenticate('local', { failureRedirect: '/login', failureFlash: true }),
  function(req, res) {
    req.flash("success", "Welcome, " + req.user.username)
    res.redirect('/');
  });


app.get('/logout', function(req, res){
  req.logout();
  res.redirect('/');
});

// Simple route middleware to ensure user is authenticated.
//   Use this route middleware on any resource that needs to be protected.  If
//   the request is authenticated (typically via a persistent login session),
//   the request will proceed.  Otherwise, the user will be redirected to the
//   login page.
function ensureAuthenticated(req, res, next) {
  console.log("checking authentication");
  if (req.isAuthenticated()) { return next(); }
  res.redirect('/login')
}


server.listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});