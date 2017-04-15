<?php

function get_title_of_topic($idProject){
  global $conn;

  $stmt = $conn->prepare("SELECT title AS name, id FROM topic WHERE project_id = ?");
  $stmt->execute(array($idProject));
  return $stmt->fetchAll();
}

function get_posts_of_topic($idTopic){
  global $conn;

  $stmt = $conn->prepare("SELECT * FROM post WHERE topic_id = ?");
  $stmt->execute(array($idTopic));
  return $stmt->fetchAll();
}

function get_comments_of_post($idPost){
  global $conn;

  $stmt = $conn->prepare("SELECT *  FROM comment WHERE post_id = ?");
  $stmt->execute(array($idPost));
  return $stmt->fetchAll();
}

function add_comment($message, $date, $post_id, $commenter){
  global $conn;

  $stmt = $conn->prepare("INSERT INTO comment (message, date, post_id, commenter) VALUES (?,?,?,?)");
  $stmt->execute(array($message, $date, $post_id, $commenter));

}

function add_post($content, $date, $topic_id, $poster){
  global $conn;

  $stmt = $conn->prepare("INSERT INTO post (content, date, topic_id, poster) VALUES (?,?,?,?)");
  $stmt->execute(array($content, $date, $topic_id, $poster));

}

function add_topic($title, $project_id, $task_id, $type){
  global $conn;

  $stmt = $conn->prepare("INSERT INTO topic (title, project_id, task_id, TYPE) VALUES (?,?,?,?)");
  $stmt->execute(array($title, $project_id, $task_id, $type));

}

?>
