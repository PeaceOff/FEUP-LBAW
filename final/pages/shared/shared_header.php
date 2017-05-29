<?php
	include_once($BASE_DIR . 'database/users.php');
	if(isset($_SESSION['username']) || isset($_SESSION['name'])){
		$username = $_SESSION['username'];
		$name = $_SESSION['name'];
		$smarty->assign('name',$name);
		$result = user_get_notifications($username);
		$notifications=array();

		foreach($result as $value){
			$data['description'] = $value['description'];
			$data['time'] = $value['time'];
			$data['id'] = $value['notification_id'];

			if(strcmp($value['type'],'Invite') == 0 )
				$data['invite'] = true;
			else
				$data['invite'] = false;

			array_push($notifications,$data);
		}

		$smarty->assign('notifications',$notifications);
		$smarty->assign('notification_number',count($notifications));
	}

	$smarty->display('common/navbar.tpl');

?>
