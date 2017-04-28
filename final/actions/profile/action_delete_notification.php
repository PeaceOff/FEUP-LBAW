<?php
	
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/users.php');

	if(!isset($_SESSION['username'])){
		header('Location: ../../authentication/home.php');
		exit();
	}

	$notification_id = $_POST['notification_id'];
	
	user_delete_notification($notification_id);

	header('Location: ../../pages/profile/personalPage.php');
	exit();
?>
