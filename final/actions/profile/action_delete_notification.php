<?php
	
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/users.php');

	if(!isset($_SESSION['username'])){
		header('Location: ../../pages/authentication/home.php');
		http_response_code(401);
		exit();
	}

	$notification_id = $_POST['notification_id'];
	
	if(!user_delete_notification($notification_id)){
		http_response_code(401);
		exit();
	}

	header('Location:'. $BASE_URL . 'pages/authentication/home.php');
	exit();
?>
