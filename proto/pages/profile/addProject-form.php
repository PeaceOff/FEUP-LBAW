<?php

include_once($BASE_DIR . 'database/users.php');

$folders = user_get_folders($_SESSION['username']);

$smarty->assign('folders2',$folders);
$smarty->display('profile/addProject-form.tpl');

?>
