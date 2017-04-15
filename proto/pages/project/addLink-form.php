<?php

$project_id = $_GET['id'];

$smarty->assign('project_id', $project_id); 

$smarty->display('project/addLink-form.tpl');

?>
