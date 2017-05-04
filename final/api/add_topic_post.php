<?php
	include_once('../config/init.php');
	include_once($BASE_DIR . 'database/forum.php');
	include_once($BASE_DIR . 'database/project.php');

	if(!isset($_SESSION['username']) || !isset($_POST['project_id'])){
		header('Location: ../pages/authentication/home.php');
		exit();
	}

	$username = $_SESSION['username'];

	$project_id = $_POST['project_id'];

	if(!project_allowed($username,$project_id)){
		header('Location: ../pages/authentication/home.php');
		exit();
	}

	$content = $_POST['post_content'];
	$topic_id = $_POST['forum_id'];

	$id = add_post($content, $topic_id, $username);

	if(!$id){
		exit();
	}

	$result['id'] = $id;
	$result['content'] = $content;
	$result['poster'] = $username;
	date_default_timezone_set('Europe/Lisbon');
	$date = date('Y/m/d H:i:s', time());
	$result['date'] = $date;

	echo json_encode($result);
?>
