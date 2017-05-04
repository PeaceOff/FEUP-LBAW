function onSignIn(googleUser) {
    var profile = googleUser.getBasicProfile();
    console.log('ID: ' + profile.getId()); // Do not send to your backend! Use an ID token instead.
    console.log('Name: ' + profile.getName());
    console.log('Image URL: ' + profile.getImageUrl());
    console.log('Email: ' + profile.getEmail()); // This is null if the 'email' scope is not present.
}

function signOut() {
    var auth2 = gapi.auth2.getAuthInstance();
    auth2.signOut().then(function () {
        console.log('User signed out.');
    });
}

/*
//Facebook Login
  window.fbAsyncInit = function() {
  FB._https = true;
    FB.init({
      appId      : '260793837663013',
      xfbml      : true,
      cookie     : true,
      version    : 'v2.8'
    });
    FB.AppEvents.logPageView();

    FB.getLoginStatus(function(response) {
      if (response.status === 'connected') {
        console.log('We are connected.');

        FB.api('/me', function(response) {

            document.getElementById('login_status').innerHTML =  response.name;
        });

      } else if (response.status === 'not_authorized') {
        console.log('We are not logged in.');
      } else {
        console.log('You are not logged into Facebook.');
      }
    });



  };

  (function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     js.src = "//connect.facebook.net/en_US/sdk.js";
     fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));


      // login with facebook with extra permissions
     function login() {
       FB.login(function(response) {

         if (response.authResponse) {
              FB.api('/me', function(response) {
                  console.log('Good to see you, ' + response.email + '.');
                  var name = response.name;


              });
             } else {
              console.log('User cancelled login or did not fully authorize.');
             }

       }, {scope:'email'});//scope is the list of permissions
     }



       function logout() {
         FB.logout(function(response) {
         });
       }
*/
