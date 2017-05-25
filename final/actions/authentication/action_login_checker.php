
<?php
  include_once('../../config/init.php');
  include_once($BASE_DIR .'database/users.php');

  if( !isset($_POST['username']) 
	  || !isset($_POST['password']) ){
	header('Location:' . $BASE_URL.'/pages/authentication/home.php');
	  die();
  }
  $username = htmlentities($_POST['username'], ENT_QUOTES, "UTF-8");
  $username = trim($username);
  $username = strtolower($username);
  $password = $_POST['password'];
  $nextPage = 'Location: ../../pages/authentication/home.php';
  $result = get_user_by_username($username);
  
  
  if(preg_match("/^up*/", $username)){
    http_response_code(400);
    exit();
  }

  if($result != NULL){
    if(password_verify($password, $result['password'])){
        http_response_code(200);
        exit();
    }else{
        http_response_code(400);
        exit();
    }
  }

  http_response_code(400);
  exit();

?>
