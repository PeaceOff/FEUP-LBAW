<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/users.php');

if(!isset($_POST['username'])){
	header("Location:" . $_SERVER['HTTP_REFERER']);
	die();
}

$username = htmlentities($_POST['username'], ENT_QUOTES, "UTF-8");
$username = trim($username);
$username = strtolower($username);

$password = $_POST['password'];
$confirmPassword = $_POST['confirmPassword'];
$email = htmlentities($_POST['email'], ENT_QUOTES, "UTF-8");

if(strcmp($password, $confirmPassword) != 0){
    http_response_code(402);
    exit();
}

if(preg_match("/^up*/", $username)){
    http_response_code(401);
    exit();
}

if(!get_user_by_username($username) && !get_email($email)){
    http_response_code(200);
    exit();
}else{
    http_response_code(400);
    exit();
}

?>
