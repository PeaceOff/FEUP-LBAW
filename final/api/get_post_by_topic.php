<?php

  include_once('../config/init.php');
  include_once($BASE_DIR . 'database/forum.php');

  $topic_id = $_POST['topic_id'];

  $posts = get_posts_of_topic($topic_id);

  echo json_encode($posts);
?>

