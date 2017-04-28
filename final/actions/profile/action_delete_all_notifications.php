<?php
	
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/users.php');

	if(!isset($_SESSION['username'])){
		header('Location: ../../authentication/home.php');
		exit();
	}

	$username = $_SESSION['username'];
	
	if(!user_delete_all_notifications($username)){
		http_response_code(401);
		exit();
	}

	header('Location: ../../pages/profile/personalPage.php');
	exit();
?>
