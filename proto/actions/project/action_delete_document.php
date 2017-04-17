<?php
	session_start();
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/project.php');

	if(!isset($_SESSION['username'])){
		header('Location: ../../pages/authentication/home.php');
		exit();
	}

	$username = $_SESSION['username'];
	$document_id = $_POST['document_id'];
	$project_id = $_POST['project_id'];

	if(!project_manager($username,$project_id)){
		header('Location: ../../pages/authentication/home.php');
		exit();
	}

	echo "Boas";
	project_delete_document($document_id);

?>
