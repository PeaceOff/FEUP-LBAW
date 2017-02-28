<?php
include_once '../templates/header.php';
include_once '../templates/navbar.php';
include_once '../templates/leftSidebar.php';
?>

<div class="col-md-12 center-block" >
  <h2 class="text-center page-header">Project Title - Todo Board</h2>
  <ul class="nav nav-tabs">
    <li class="nav-item active">
      <a class="nav-link toggler" href="#to-do">To Do</a>
    </li>
    <li class="nav-item">
      <a class="nav-link toggler"  href="#doing">Doing</a>
    </li>
    <li class="nav-item">
      <a class="nav-link toggler" href="#done">Done</a>
    </li>
    <li class="nav-item dropdown">
      <a class="nav-link dropdown-toggle" data-toggle="dropdown"
        href="#" role="button" aria-haspopup="true" aria-expanded="false">
        Category</a>
      <div class="dropdown-menu">
        <a class="dropdown-item" href="#">High Priority</a>
        <a class="dropdown-item" href="#">Low Priority</a>
        <a class="dropdown-item" href="#">Art work</a>
      </div>
    </li>
  </ul>

  <div class="container-fluid">
    <div id="to-do" class="selectable">
      <div class="card col-xs-3">
        <div class="card-block">
          <h3 class="card-title">Special title treatment 1</h3>
          <p class="card-text">With supporting text below as a natural lead-in to additional content.</p>
          <a href="#" class="btn btn-primary">Go somewhere</a>
        </div>
      </div>
      <div class="card col-xs-3">
        <div class="card-block">
          <h3 class="card-title">Special title treatment 2</h3>
          <p class="card-text">With supporting text below as a natural lead-in to additional content.</p>
          <a href="#" class="btn btn-primary">Go somewhere</a>
        </div>
      </div>
    </div>
    <div id="doing" class="selectable">
      <div class="card col-xs-3">
        <div class="card-block">
          <h3 class="card-title">Special title treatment 3</h3>
          <p class="card-text">With supporting text below as a natural lead-in to additional content.</p>
          <a href="#" class="btn btn-primary">Go somewhere</a>
        </div>
      </div>
      <div class="card col-xs-3">
        <div class="card-block">
          <h3 class="card-title">Special title treatment 4</h3>
          <p class="card-text">With supporting text below as a natural lead-in to additional content.</p>
          <a href="#" class="btn btn-primary">Go somewhere</a>
        </div>
      </div>
    </div>
    <div id="done" class="selectable">
      <div class="card col-xs-3">
        <div class="card-block">
          <h3 class="card-title">Special title treatment 5</h3>
          <p class="card-text">With supporting text below as a natural lead-in to additional content.</p>
          <a href="#" class="btn btn-primary">Go somewhere</a>
        </div>
      </div>
    </div>
  </div>
</div>
<?php
include_once '../templates/rightSidebar.php';

include_once '../templates/footer.php';
?>
