<?php
  include_once('../../../config/init.php');
  include_once($BASE_DIR .'database/users.php');
  print_r($_POST);
  
  $username = htmlentities($_POST['username'], ENT_QUOTES, "UTF-8");
  $username = trim($username);
  $username = strtolower($username);
  $password = $_POST['password'];
  $nextPage = 'Location:'. $BASE_URL. '/pages/authentication/home.php';
  $result = get_user_by_username($username);

  if($result != NULL){
    if(password_verify($password, $result['password'])){
      $_SESSION['username'] = $username;
      $nextPage = 'Location:'. $BASE_URL .' pages/profile/personalPage.php';
    }
  }

  //header($nextPage);
  exit();
?>
