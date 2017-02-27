<?php
include_once '../templates/header.php';
include_once '../templates/leftSidebar.php';
?>

<div class="col-md-12 center-block" >
  <h2 class="text-center bottom">Project Title - Todo Board</h2>
  <table class="table ">
    <thead>
      <tr>
        <th class="col-md-4">Todo</th>
        <th class="col-md-4">In Progress</th>
        <th class="col-md-4">Done</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td >
          <div class="card col-lg-3 col-md-3 col-sm-6 col-xs-12">
            <div class="card-block">
              <h3 class="card-title">Special title treatment</h3>
              <p class="card-text">With supporting text below as a natural lead-in to additional content.</p>
              <a href="#" class="btn btn-primary">Go somewhere</a>
            </div>
          </div></td>

          <td></td>
          <td>
            <div class="card col-lg-3 col-md-3 col-sm-6 col-xs-12">
              <div class="card-block">
                <h3 class="card-title">Special title treatment</h3>
                <p class="card-text">With supporting text below as a natural lead-in to additional content.</p>
                <a href="#" class="btn btn-primary">Go somewhere</a>
              </div>
            </div></td>

          </tr>

          <tr>
            <td >
              <div class="card col-lg-3 col-md-3 col-sm-6 col-xs-12">
                <div class="card-block">
                  <h3 class="card-title">Special title treatment</h3>
                  <p class="card-text">With supporting text below as a natural lead-in to additional content.</p>
                  <a href="#" class="btn btn-primary">Go somewhere</a>
                </div>
              </div></td>

              <td></td>
              <td>
              </td>

            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <?php
    include_once '../templates/rightSidebar.php';

    include_once '../templates/footer.php';
    ?>
