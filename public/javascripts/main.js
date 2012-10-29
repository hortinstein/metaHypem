$(document).ready(function() {
    var songs = $('#songs');
    var socket = io.connect('http://localhost');
    /*
    SOCKET HANDLING 
    */

    socket.on('connect', function() {
        console.log("connected");
    });
    socket.on('message', function(message){
        songs.append(message +'<br>'); 
    }) ;
});