<?php
  include_once('../../config/init.php');
  include_once($BASE_DIR .'database/users.php');

  $username=htmlentities($_POST['username'], ENT_QUOTES, "UTF-8");
  $username = trim($username);
  $username = strtolower($username);

  $password=$_POST['password'];

  if(get_user_by_username($username) != NULL){
    $_SESSION['username'] = $username;
  }

  header("Location: " . '../../pages/profile/personalPage.php');
  exit;

?>
