<?php

$project_id = $_POST['project_id'];
$linkPath = $_POST['linkName'];

include_once($BASE_DIR . '/database/project.php');

if(!isset($_SESSION['username'])){
	header('Location: ../authentication/home.php');
	exit();
}

if(project_allowed($_SESSION['username'], $linkPath)){
	header('Location: ../authentication/home.php ');
	exit();
}	

project_add_document($project_id, '', '', 'Link', $linkPath);

?>
