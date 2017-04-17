{include file='project/addFile-form.tpl'}
{include file='project/addLink-form.tpl'}

<div class="col-md-12">
  <div class="container">
    <h1 class="text-center page-header">{$project.name}</h1>
    <p class="text-justify well">{$project.description}</p>
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
      {foreach from=$links item=link}
      <li>
        <a href="#" class="invisible link_deleteDocument" id='{$link.id}'><i class="fa fa-times delete-link fa-2x" aria-hidden="true"></i></a>
        <a href="{$link.path}">
          <i class="fa fa-globe fa-4x" aria-hidden="true"></i>
        </a>
      </li>
      {/foreach}
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
            {foreach from=$documents item=document}
            <li>
              <a class="cardLink" href="projectPage.php">
                <div class="col-lg-3 col-md-3 col-sm-6 col-xs-12">
                  <div class="card document">
                    <h2>{$document.name}</h2>
                    <img class="img-responsive" src="../../images/document-card.png" >
                    <div class="document-bottom">
                      <a class="btn icon-link btn-warning btn-sm" rel="publisher" href="#">
                        <i class="fa fa-download"></i>
                      </a>
                      <a class="btn icon-link btn-primary btn-twitter btn-sm" href="#">
                        <i class="fa fa-pencil"></i>
                      </a>
                      <a class="btn icon-link btn-danger btn-sm" rel="publisher" href="#">
                        <i class="fa fa-trash"></i>
                      </a>
                    </div>
                  </div>
                </div>
              </a>
              <li>
                {/foreach}
              </ul>
            </div>
            <div class="item"><!-- /Slide2 -->
              <ul class="thumbnails">

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
          <a  href="../../pages/todo/todoPage.php#to-do" > <img src="../../images/todo.png" class="img-responsive img-circle center-block" width="200"> </a>
        </div>


      </div>

      <!-- Progress Bar -->
      <div class="container text-center">
        Deadline : {$project.deadline}
        <div class="progress" id="progress-bar-div">
          <div class="progress-bar" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 60%;">
            <span class="sr-only">{$percent_complete}% Complete</span>
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
