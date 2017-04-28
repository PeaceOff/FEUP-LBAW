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
            $data['id'] = $value['folder_id'];
        }

        if(!$data['projects'])
            $data['projects'] = array();

        $project = array();
        $project['name'] = $value['project_name'];
        $project['id'] = $value['project_id'];
        $project['page'] = '../project/projectPage.php?project_id=' . $project['id'];
        array_push($data['projects'],$project);
        $folders[$value['folder_id']] = $data;

    }

    $smarty->assign('folders', $folders);
    $smarty->display('common/leftSidebar.tpl');
    $smarty->display('profile/addFolder-form.tpl');
?>
