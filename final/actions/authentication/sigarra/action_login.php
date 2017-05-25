<?php
  include_once('../../../config/init.php');
  include_once($BASE_DIR .'database/users.php');

  if(!isset($_SERVER['UPortoNMec'])){
	header('Location:'. $BASE_URL .'pages/authentication/home.php');
	die();
  }

  $name = htmlentities($_SERVER['displayName'], ENT_QUOTES, "UTF-8");
  $username =  htmlentities($_SERVER['Mail'] ,ENT_QUOTES, "UTF-8");
  $username = trim($username);
  $username = strtolower($username);
  $email =  htmlentities($_SERVER['Mail'] ,ENT_QUOTES, "UTF-8");
  $password = 'pw';
  $nextPage = 'Location:'. $BASE_URL. '/pages/authentication/home.php';
  $result = get_user_by_username($username);

  if($result == NULL)
	   user_add($username, $password, $email, $name);


  $_SESSION['username'] = $username;
  $_SESSION['name'] = $name;

  header($nextPage);
  exit();
?>
