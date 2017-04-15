<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/project.php');

$project_id = $_POST['project_id'];
$linkPath = $_POST['linkName'];

if(!isset($_SESSION['username'])){
	header('Location: ../../pages/authentication/home.php');
	exit();
}

if(!project_allowed($_SESSION['username'], $project_id)){
	header('Location: ../../pages/authentication/home.php ');
	exit();
}	

$uploadDir = '../../files/';
$uploadfile = $uploaddir . basename($_FILES['userfile']['name']);


move_uploaded_file($_FILES['userfile']['tmp_name'], $uploadfile)

project_add_document($project_id, $_FILES['userfile']['tmp_name'], '', 'Document', $uploadfile);

header('Location: ../../pages/project/projectPage.php?project_id=' . $project_id);

?>
