<?php
	
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/users.php');

	if(!isset($_SESSION['username'])){
		header('Location: ../../authentication/home.php');
		exit();
	}

	$username = $_SESSION['username'];
	
	user_delete_all_notification($username);

	header('Location: ../../pages/profile/personalPage.php');
	exit();
?>