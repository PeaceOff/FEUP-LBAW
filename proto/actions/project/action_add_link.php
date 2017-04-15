<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/project.php');

$project_id = $_POST['project_id'];
$linkPath = $_POST['linkName'];

print_r($_POST);

if(!isset($_SESSION['username'])){
	header('Location: ../../pages/authentication/home.php');
	exit();
}

if(!project_allowed($_SESSION['username'], $project_id)){
	header('Location: ../../pages/authentication/home.php ');
	exit();
}	

project_add_document($project_id, '', '', 'Link', $linkPath);

header('Location: ../../pages/project/projectPage.php?project_id=' . $project_id);

?>
