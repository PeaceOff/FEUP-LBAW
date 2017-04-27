<?php
	include_once($BASE_DIR . 'database/users.php');

	if(isset($_SESSION['username'])){
		$username = $_SESSION['username'];
		$smarty->assign('username',$username);
		$result = user_get_notifications($username);

		$notifications=array();

		foreach($result as $value){
			$data['description'] = $value['description'];
			$data['time'] = $value['time'];

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
