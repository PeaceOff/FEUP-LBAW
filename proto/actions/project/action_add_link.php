<?php

$project_id = $_POST['project_id'];
$linkPath = $_POST['linkName'];

if(!isset($_SESSION['username'])){
	header('Location: ../../pages/authentication/home.php');
	exit();
}

if(project_allowed($_SESSION['username'], $linkPath)){
	header('Location: ../../pages/authentication/home.php ');
	exit();
}	

project_add_document($project_id, '', '', 'Link', $linkPath);

?>
