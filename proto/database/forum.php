<?php

function getTitleOfTopic($idProject){
  global $conn;

  $stmt = $conn->prepare("SELECT title FROM topic WHERE project_id = ?");
  $stmt->execute(array($idProject));
  return $stmt->fetchAll();
}

function getPostsOfTopic($idTopic){
  global $conn;

  $stmt = $conn->prepare("SELECT * FROM post WHERE topic_id = ?");
  $stmt->execute(array($idTopic));
  return $stmt->fetchAll();
}

function getCommentsOfPost($idPost){
  global $conn;

  $stmt = $conn->prepare("SELECT *  FROM comment WHERE post_id = ?");
  $stmt->execute(array($idPost));
  return $stmt->fetchAll();
}

function addComment($message, $date, $post_id, $commenter){
  global $conn;

  $stmt = $conn->prepare("INSERT INTO comment (message, date, post_id, commenter) VALUES (?,?,?,?)");
  $stmt->execute(array($message, $date, $post_id, $commenter));

}

function addPost($content, $date, $topic_id, $poster){
  global $conn;

  $stmt = $conn->prepare("INSERT INTO post (content, date, topic_id, poster) VALUES (?,?,?,?)");
  $stmt->execute(array($content, $date, $topic_id, $poster));

}

function addTopic($title, $project_id, $task_id, $type){
  global $conn;

  $stmt = $conn->prepare("INSERT INTO topic (title, project_id, task_id, TYPE) VALUES (?,?,?,?)");
  $stmt->execute(array($title, $project_id, $task_id, $type));

}

?>
