<?php
    include_once('../../config/init.php');
    
    $project_id = $_GET['project_id'];
    $forums = get_title_of_topic($project_id);
?>
