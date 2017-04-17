<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/project.php');

$project_id = $_POST['project_id'];
$username = $_POST['username'];

print_r($_POST);

if(!isset($_SESSION['username'])){
	header('Location: ../../pages/authentication/home.php');
	exit();
}

if(!project_manager($_SESSION['username'], $project_id)){
	header('Location: ../../pages/authentication/home.php ');
	exit();
}	

project_remove_collaborator($username, $project_id);

header('Location: ../../pages/project/projectPage.php?project_id=' . $project_id);

?>
