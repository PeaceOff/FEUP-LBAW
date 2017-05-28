<?php


  function search_post_content($query,$project_id) {
    global $conn;
        $stmt = $conn->prepare("SELECT * FROM post,topic WHERE to_tsvector('english',content) @@ to_tsquery('english',? ) AND post.topic_id=topic.id AND topic.project_id = ? AND topic.task_id IS NULL");

        try{
            $stmt->execute(array($query,$project_id));
				}catch(Exception $e){
					error_log("DB Error:" . $e->getMessage());
				}
    return $stmt->fetchAll();
  }

  function search_task($query,$project_id) {
      global $conn;

        $stmt = $conn->prepare("SELECT * FROM task WHERE (to_tsvector('english',description) @@ to_tsquery('english', ? ) OR to_tsvector('english',name) @@ to_tsquery('english', ? )) AND project_id=?");

        try{
          $stmt->execute(array($query,$query,$project_id));
				}catch(Exception $e){
					error_log("DB Error:" . $e->getMessage());
				}
    return $stmt->fetchAll();
  }

  function search_topic_title($query,$project_id) {
    global $conn;
        $stmt = $conn->prepare("SELECT * FROM topic WHERE to_tsvector('english',title) @@ to_tsquery('english',?) AND project_id=? AND task_id IS NULL ");



        try{
          $stmt->execute(array($query,$project_id));
				}catch(Exception $e){
					error_log("DB Error:" . $e->getMessage());
				}
    return $stmt->fetchAll();
  }

?>
