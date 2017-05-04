<?php

  include_once('../config/init.php');
  include_once($BASE_DIR . 'database/forum.php');

  $topic_id = $_POST['topic_id'];

  $posts = get_posts_of_topic($topic_id);

  foreach ($posts as &$post) {
    $post['date'] = preg_replace('/\.[0-9]*/','',$post['date']);
  }

  $reversed = array_reverse($posts);

  echo json_encode($reversed);
?>

