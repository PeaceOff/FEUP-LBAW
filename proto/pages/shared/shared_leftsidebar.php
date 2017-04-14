<?php

include_once($BASE_DIR . 'database/users.php');

$notifications = user_get_folders_populated($_SESSION['username']);
$folders = array();

foreach ($notifications as $key => $value) {
  $data = array();

  if($folders[$value['folder_id']]){
    $data = $folders[$value['folder_id']];
  }else{
    $data['name'] = $value['folder_name'];
    $folders[$value['folder_id']] = $data;
  }

  if(!$data['projects'])
    $data['projects'] = array();

  $project = array();
  $project['name'] = $value['project_name'];
  $project['id'] = $value['project_id'];  

  array_push($data['projects'],$project);
}

print_r($folders);
$smarty->assign('folders', $folders);

$smarty->display('common/leftSidebar.tpl');

?>
