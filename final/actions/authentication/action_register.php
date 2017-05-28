<?php

  include_once('../../config/init.php');
  include_once($BASE_DIR .'database/users.php');

  if( !isset($_POST['username']) 
	  || !isset($_POST['password']) 
	  || !isset($_POST['email']) ){
	header('Location:' . $BASE_URL.'/pages/authentication/home.php');
	  die();
  }

  $username = htmlentities($_POST['username'], ENT_QUOTES, "UTF-8");
  $username = trim($username);
  $username = strtolower($username);

  if(preg_match("/^up*/", $username)){
      	header("Location: " . $_SERVER['HTTP_REFERER']);
	die();
  }
  $password = password_hash($_POST['password'] , PASSWORD_DEFAULT);
  $email = htmlentities($_POST['email'], ENT_QUOTES, "UTF-8");

  try {
      if(!get_user_by_username($username))
        user_add($username, $password, $email,$username);

    } catch (PDOException $e) {
      $_SESSION['error_messages'][] = 'Error creating user: ' . $e->getMessage();

      $_SESSION['form_values'] = $_POST;
      header("Location: " . $_SERVER['HTTP_REFERER']);
      exit;
    }

  $_SESSION['username'] = $username;

  header("Location: " . '../../pages/profile/personalPage.php');
  exit();
?>
