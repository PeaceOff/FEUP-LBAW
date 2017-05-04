<?php
  include_once('../config/init.php');
  include_once($BASE_DIR . 'database/users.php');

  if(!isset($_SESSION['username'])){
    header('Location: ../pages/authentication/home.php');
    exit();
  }

  $username = $_SESSION['username'];

  $results = user_get_statistics($username);
  echo json_encode($results);

?>
