<?php

  include_once('../../config/init.php');
  include_once($BASE_DIR . 'database/todo.php');

  $topic_id=$_POST['topic_id'];

  $posts= get_posts_of_topic($topic_id);

  foreach($posts as $post){
	$post['comments'] = get_comments_of_post($post['id']);
  }

  echo json_encode($posts);
?>
