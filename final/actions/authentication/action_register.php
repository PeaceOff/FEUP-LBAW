<?php

  include_once('../../config/init.php');
  include_once($BASE_DIR .'database/users.php');

  $username = $_POST['username'];
  $username = trim($username);
  $username = strtolower($username);

  $password = password_hash($_POST['password'] , PASSWORD_DEFAULT);
  $email = $_POST['email'];

  try {
      if(!get_user_by_username($username))
        user_add($username, $password, $email);

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
