<?php

  include_once('../../config/init.php');
  include_once($BASE_DIR .'database/users.php');

  $name=$_POST['username'];
  $pw=$_POST['password'];
  $email=$_POST['email'];


  user_add($name, $pw, $email);


  header("Location: " . $BASE_DIR . 'pages/profile/personalPage.php');

?>
