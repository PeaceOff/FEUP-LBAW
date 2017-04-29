<?php
  include_once('../../../config/init.php');
  include_once($BASE_DIR .'database/users.php');
  
  if(!isset($_SERVER['UPortoNMec'])){
	header('Location:'. $BASE_URL .'pages/authentication/home.php');
	die();
  }
  $username = 'up' . htmlentities($_SERVER['UPortoNMec'] ,ENT_QUOTES, "UTF-8");
  $username = trim($username);
  $username = strtolower($username);
  $email = $username . '@'. $username; 
  $password = 'pw'; 
  $nextPage = 'Location:'. $BASE_URL. '/pages/authentication/home.php';
  $result = get_user_by_username($username);

  if($result != NULL){
	$_SESSION['username'] = $username;
  }else{
	user_add($username, $password, $email);
	$_SESSION['username'] = $username;
  }

  header($nextPage);
  exit();
?>
