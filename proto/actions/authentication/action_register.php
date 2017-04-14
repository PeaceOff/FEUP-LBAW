<?php

  include_once('../../config/init.php');
  include_once($BASE_DIR .'database/users.php');

  $name=$_POST['username'];
  $pw=$_POST['password'];
  $email=$_POST['email'];

  try {
      if(!get_user_by_username($name))
        user_add($name, $pw, $email);

    } catch (PDOException $e) {
      $_SESSION['error_messages'][] = 'Error creating user: ' . $e->getMessage();

      $_SESSION['form_values'] = $_POST;
      header("Location: " . $_SERVER['HTTP_REFERER']);
      exit;
    }

  $_SESSION['username'] = $name;


  header("Location: " . $BASE_DIR . 'pages/profile/personalPage.php');

?>
