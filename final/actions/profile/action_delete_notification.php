<?php
	
	include_once('../../config/init.php');
	include_once($BASE_DIR . 'database/users.php');

	if(!isset($_SESSION['username']) 
		|| !isset($_POST['notification_id'])){
		header('Location: ../../pages/authentication/home.php');
		http_response_code(401);
		exit();
	}

	$notification_id = htmlentities($_POST['notification_id'], ENT_QUOTES, "UTF-8");
	
	if(!user_delete_notification($notification_id)){
		http_response_code(401);
		exit();
	}

	header('Location:'. $BASE_URL . 'pages/authentication/home.php');
	exit();
?>
