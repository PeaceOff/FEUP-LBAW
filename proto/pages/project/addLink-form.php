<?php

$project_id = $_GET['project_id'];

$smarty->assign('project_id', $project_id); 

$smarty->display('project/addLink-form.tpl');

?>
