<?php
  include_once('../../config/init.php');

  session_destroy();
  header("Location: " . $BASE_DIR . '../../pages/authentication/home.php');
  exit;
?>
