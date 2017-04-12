

  window.fbAsyncInit = function() {
    FB.init({
      appId      : '260793837663013',
      xfbml      : true,
      version    : 'v2.8'
    });
    FB.AppEvents.logPageView();

    FB.getLoginStatus(function(response) {
      if (response.status === 'connected') {
        console.log('We are connected.');
        document.getElementById('login').style.visibility = 'hidden';
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
               document.getElementById('login_status').innerHTML =  response.name;
           });
          } else {
           console.log('User cancelled login or did not fully authorize.');
          }

    }, {scope: 'email'});//scope is the list of permissions
  }



    function logout() {
      FB.logout(function(response) {
        document.getElementById('login_status').innerHTML = '';
      });
    }
