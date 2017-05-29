<?php
require_once __DIR__ . '/vendor/autoload.php';
include_once '../../../config/init.php';
include_once($BASE_DIR .'database/users.php');

  const CLIENT_ID = '24514991017-9efgnfa8frjqohqclu3ftkmjfnhkmkde.apps.googleusercontent.com';
  const CLIENT_SECRET = 'jGi0J-wr4A9yVC4ghgglcA1j';
  const APPLICATION_NAME = 'Consord';

  $client = new Google_Client();
  $client->setApplicationName(APPLICATION_NAME);
  $client->setClientId(CLIENT_ID);
  $client->setClientSecret(CLIENT_SECRET);
  $client->setScopes(array( 'https://www.googleapis.com/auth/plus.me', 'https://www.googleapis.com/auth/userinfo.email', 'https://www.googleapis.com/auth/userinfo.profile', ));
  $client->setRedirectUri('https://gnomo.fe.up.pt/~lbaw1665/final/actions/authentication/google/action_login.php');


  $plus = new Google_Service_Plus($client);

  if (isset($_REQUEST['logout'])) {
     session_unset();
  }

  if (isset($_GET['code'])) {
    $client->authenticate($_GET['code']);
    $_SESSION['access_token'] = $client->getAccessToken();
    $redirect = 'http://' . $_SERVER['HTTP_HOST'] . $_SERVER['PHP_SELF'];
    header('Location: ' . filter_var($redirect, FILTER_SANITIZE_URL));
  }

  if (isset($_SESSION['access_token']) && $_SESSION['access_token']) {


    $client->setAccessToken($_SESSION['access_token']);
    $me = $plus->people->get('me');

    $id = $me['id'];
    $name =  $me['displayName'];
    $email =  $me['emails'][0]['value'];
    $profile_image_url = $me['image']['url'];
    $cover_image_url = $me['cover']['coverPhoto']['url'];
    $profile_url = $me['url'];


    $username = get_user_by_username($email);

    if($username == NULL)
      user_add($email, 'pw', $email,$name);

    $_SESSION['username'] = $email;
    $_SESSION['name'] = $name;

    header('Location:' . $BASE_URL . '/pages/authentication/home.php');

  } else {

    $authUrl = $client->createAuthUrl();
    header('Location: ' . $authUrl);
  }

?>
