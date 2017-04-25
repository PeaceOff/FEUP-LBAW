<?php
	session_start();
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/project.php');

	if(isset($_SESSION['username'])){
		$username = $_SESSION['username'];
		$document_id = $_POST['document_id'];
		$project_id = $_POST['project_id'];

		if(project_manager($username,$project_id)){
			project_delete_document($document_id);
		}
	}

	header('Location: ' . $_SERVER['HTTP_REFERER']);
	exit();
?>
