<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/project.php');

if(!isset($_SESSION['username'])){
    header('Location: ../../authentication/home.php');
    exit();
}

$proj_folder = $_POST['folder_id'];
$proj_id = $_POST['project_id'];
$old_folder_id = project_get_old_folder($proj_id, $_SESSION['username'])['id'];

project_remove_from_folder($proj_id,$old_folder_id);
project_change_folder($proj_id, $proj_folder);

header('Location: ../../pages/profile/personalPage.php');
exit();
?>
