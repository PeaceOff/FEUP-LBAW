<?php

    include_once('../config/init.php');
    include_once($BASE_DIR . 'database/forum.php');

    $post_id = $_POST['post_id'];

    $comments = get_comments_of_post($post_id);

    foreach ($comments as &$comment) {
        $comment['date'] = preg_replace('/\.[0-9]*/','',$comment['date']);
    }

    echo json_encode($comments);
?>