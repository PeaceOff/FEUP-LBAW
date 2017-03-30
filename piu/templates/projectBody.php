<?php
include_once 'addFile-form.php';
include_once 'addLink-form.php';
?>

<div class="col-md-12">
  <div class="container">
    <h1 class="text-center page-header">Project Title</h1>
    <p class="text-justify well">Description :  Do mesmo modo, a consulta aos diversos militantes ainda não demonstrou convincentemente que vai participar na mudança das posturas dos órgãos dirigentes com relação às suas atribuições. Nunca é demais lembrar o peso e o significado destes problemas, uma vez que o fenômeno da Internet possibilita uma melhor visão global da gestão inovadora da qual fazemos parte.</p>


    <div class="row">
      <div class="col-sm-6 col-sm-offset-3">
        <div id="imaginary_container">
          <div class="input-group stylish-input-group">
            <input type="text" class="form-control"  placeholder="Search" >
            <span class="input-group-addon">
              <button type="submit">
                <span class="glyphicon glyphicon-search"></span>
              </button>
            </span>
          </div>
        </div>
      </div>
    </div>
  </div>



  <!-- LINKS -->
  <div class="container">

    <script>
    $(document).ready(function () {
      $('.edit-link').click(function(){
          $('.links-ul li a:first-child').toggleClass("invisible");

      });

    });

    </script>

    <div class="page-header">
      <h3> Links <a a data-toggle="modal" data-target="#addLink"> <i class="fa fa-plus" aria-hidden="true"></i></a> <a> <i class="edit-link fa fa-pencil" aria-hidden="true"></i> </a>   </h3>
    </div>


    <ul class="links-ul list-inline" style="overflow-x:scroll; white-space: nowrap;">
      <li>
        <a href="#" class="invisible"><i class="fa fa-times delete-link fa-2x" aria-hidden="true"></i></a>
        <a href="https://facebook.com">
          <i class="fa fa-facebook-square fa-4x" aria-hidden="true"></i>
        </a>
      </li>

      <li>
        <a href="#" class="invisible"><i class="fa fa-times delete-link fa-2x" aria-hidden="true"></i></a>
        <a href="https://google.com">
          <i class="fa fa-google-plus-square fa-4x" aria-hidden="true"></i>
        </a>
      </li>

      <li>
        <a href="#" class="invisible"><i class="fa fa-times delete-link fa-2x" aria-hidden="true"></i></a>
        <a href="https://twitter.com">
          <i class="fa fa-twitter-square fa-4x" aria-hidden="true"></i>
        </a>
      </li>

      <li>
        <a href="#" class="invisible"><i class="fa fa-times delete-link fa-2x" aria-hidden="true"></i></a>
        <a href="https://trello.com">
          <i class="fa fa-trello fa-4x" aria-hidden="true"></i>
        </a>
      </li>

      <li>
        <a href="#" class="invisible"><i class="fa fa-times delete-link fa-2x" aria-hidden="true"></i></a>
        <a href="https://github.com">
          <i class="fa fa-github fa-4x" aria-hidden="true"></i>
        </a>
      </li>

      <li>
        <a href="#" class="invisible"><i class="fa fa-times delete-link fa-2x" aria-hidden="true"></i></a>
        <a href="https://youtube.com">
          <i class="fa fa-youtube-play fa-4x" aria-hidden="true"></i>
        </a>
      </li>

    </ul>
  </div>

  <div class="container">
    <div class="page-header">
      <h3> Documents <a data-toggle="modal" data-target="#uploadFile"> <i class="fa fa-plus" aria-hidden="true"></i> </a> </h3>
    </div>


    <div class="carousel slide" id="documentsCarrousel">
      <div class="carousel-inner">
        <div class="item active"><!-- /Slide1 -->
          <ul class="thumbnails padding-0">
            <li>
              <a class="cardLink" href="projectPage.php">
                <?php include '../templates/document-card.php';?>
              </a>
              <li>

                <li>
                  <a class="cardLink" href="projectPage.php">
                    <?php include '../templates/document-card.php';?>
                  </a>
                  <li>

                    <li>
                      <a class="cardLink" href="projectPage.php">
                        <?php include '../templates/document-card.php';?>
                      </a>
                      <li>


                      </ul>
                    </div>
                    <div class="item"><!-- /Slide2 -->
                      <ul class="thumbnails">
                        <li>
                          <a class="cardLink" href="projectPage.php">
                            <?php include '../templates/document-card.php';?>
                          </a>
                          <li>
                            <li>
                              <a class="cardLink" href="projectPage.php">
                                <?php include '../templates/document-card.php';?>
                              </a>
                              <li>
                              </ul>
                            </div>
                          </div>

                          <nav>
                            <ul class="control-box pager">
                              <li><a data-slide="prev" href="#documentsCarrousel" class=""><i class="glyphicon glyphicon-chevron-left"></i></a></li>
                              <li><a data-slide="next" href="#documentsCarrousel" class=""><i class="glyphicon glyphicon-chevron-right"></i></a></li>
                            </ul>
                          </nav>
                          <!-- /.control-box -->
      </div><!-- /#documentsCarrousel -->

    </div>

    <div class="container">
      <div class="page-header">
        <h2> Todo </h2>
      </div>

      <div class="jumbotron">
        <a  href="todoPage.php#to-do" > <img src="../assets/todo.png" class="img-responsive img-circle center-block" width="200"> </a>
      </div>


    </div>

    <!-- Progress Bar -->
    <div class="container text-center">
      Deadline : 24-10-2017
      <div class="progress" id="progress-bar-div">
        <div class="progress-bar" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 60%;">
          <span class="sr-only">60% Complete</span>
        </div>
      </div>
    </div>
    <script>

    $(document).ready(function () {

      var percent = 65;
      $("#progress-bar-div").children(".progress-bar").attr("aria-valuenow",percent);
      $("#progress-bar-div").children(".progress-bar").width(percent+"%");
      $("#progress-bar-div").children(".progress-bar").children(".sr-only").html(percent + "% complete");
    });

    </script>
  </div>
</div>
