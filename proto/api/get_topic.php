<?php

  include_once('../../config/init.php');
  include_once($BASE_DIR . 'database/todo.php');
  //include db

  $search=$_POST['category'];

  //$results= gettaskbycategory()
  echo json_encode($results);
?>
