<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/project.php');

if(!isset($_SESSION['username'])
	|| !isset($_POST['folder_id']) 
	|| !isset($_POST['project_id']) ){
    header('Location: ../../authentication/home.php');
    exit();
}

$proj_folder = htmlentities($_POST['folder_id'], ENT_QUOTES, "UTF-8");
$proj_id = htmlentities($_POST['project_id'], ENT_QUOTES, "UTF-8");
$old_folder_id = project_get_old_folder($proj_id, $_SESSION['username'])['id'];

project_remove_from_folder($proj_id,$old_folder_id);
project_change_folder($proj_id, $proj_folder);

header('Location: ../../pages/profile/personalPage.php');
exit();
?>
