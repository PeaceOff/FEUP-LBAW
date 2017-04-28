<?php

    include_once('../config/init.php');
    include_once($BASE_DIR . 'database/forum.php');

    $post_id = $_POST['post_id'];

    $comments = get_comments_of_post($post_id);

    echo json_encode($comments);
?>