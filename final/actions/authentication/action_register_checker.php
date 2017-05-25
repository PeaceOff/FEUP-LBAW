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

if(preg_match("/^up*/", $username)){
    http_response_code(401);
    exit();
}

if(!get_user_by_username($username)){
    http_response_code(200);
    exit();
}else{
    http_response_code(400);
    exit();
}

?>
