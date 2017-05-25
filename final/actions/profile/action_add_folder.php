<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/users.php');

if(!isset($_SESSION['username']) || !isset($_POST['folderName'])){
    header('Location: ../../authentication/home.php');
    http_response_code(401);
    exit();
}

$folder_name = htmlentities($_POST['folderName'], ENT_QUOTES, "UTF-8");

user_add_folder($folder_name, $_SESSION['username']);

header('Location: ' . $_SERVER['HTTP_REFERER']);
exit();
?>
