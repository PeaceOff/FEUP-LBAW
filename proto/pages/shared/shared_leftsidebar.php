<?php


$notifications = user_get_notifications($_SESSION['username']);
$folders = array();

foreach ($variable as $key => $value) {
  $data = array();
  if($folders[$value['folder_id']]){
    $data = $folders[$value['folder_id']];
  }else{
    $data['name'] = $value['folder_name'];
    $folders[$value['folder_id']] = $data;
  }

  if(!$data['projects'])
    $data['projects'] = array();

  arraypush($data['projects'],array( ['name'] => $value['project_name'] ,['id'] => $value['project_id']));
}

$smarty->assign('folders', $folders);

$smarty->display('common/leftSidebar.tpl');

?>
