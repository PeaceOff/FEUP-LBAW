{include file='project/addFile-form.tpl'}
{include file='project/addLink-form.tpl'}

<script type="text/javascript" src = "../../javascript/search.js"></script>

<div class="template searchResult">
  <a class="resultLink" href="#">
    <li class="container">
      <h2 class="col-xs-7 col-sm-5 col-md-3 col-lg-3 resultHeader">Title</h2>

      <ul class="col-xs-5 col-sm-7 col-md-9 col-lg-9 ">
        <li><span><h5 class="resultBody">Description</h5></span></li>
      </ul>
    </li>
  </a>
</div>

<div class="col-md-12">
  <div class="container">
    <h1 class="text-center page-header">{$project.name}</h1>
    <p class="text-justify well">{$project.description}</p>

    <div class="row">
      <div class=" col-md-6 col-md-offset-3">
          <div class="form-group has-feedback" id="searchArea">
            <label for="searchQuery" class="sr-only">Search</label>
            <input type="text" class="form-control" name="search" placeholder="search" id="searchQuery">
            <span class="glyphicon glyphicon-search form-control-feedback"></span>

            <ul id="searchResults">


            </ul>
          </div>
          </div>
    </div>
  </div>



  <div class="container">
    <script>
    $(document).ready(function () {
      $('.edit-link').click(function(){
        $('.links-ul li a:first-child').toggleClass("invisible");
      });
    });
    </script>
    <div class="page-header">
      <h3> Links
          {if $isManager }
            <a a data-toggle="modal" data-target="#addLink"> <i class="fa fa-plus" aria-hidden="true"></i></a>
        <a> <i class="edit-link fa fa-pencil" aria-hidden="true"></i> </a>
          {/if}
      </h3>

    </div>
    <ul class="links-ul list-inline" style="overflow-x:scroll; white-space: nowrap;">
      {foreach from=$links item=link}
      <li>
        <a href="#" class="invisible link_deleteDocument" type_of_doc='Link' id='{$link.id}'><i class="fa fa-times delete-link fa-2x" aria-hidden="true"></i></a>
        <a href="{$link.path}">
          <i class="fa fa-globe fa-4x" aria-hidden="true"></i>
        </a>
      </li>
      {/foreach}
    </ul>
  </div>

  <div class="container">
    <div class="page-header">
      <h3> Documents

      {if $isManager}
         <a data-toggle="modal" data-target="#uploadFile"> <i class="fa fa-plus" aria-hidden="true"></i> </a>
      {/if}

      </h3>
    </div>


    <div class="carousel slide" id="documentsCarrousel">
      <div class="carousel-inner">
        <div class="item active">
          <ul class="thumbnails padding-0">
            {foreach from=$documents item=document}
            <li>
              <a class="cardLink" href="../../uploads/{$document.project_id}/{$document.name}" target="_blank" >
                <div class="col-lg-2 col-md-3 col-sm-4 col-xs-4">
                  <div class="card document">
                    <h3>{$document.name}</h3>
                    <img class="img-responsive" src="../../images/document-card.png" alt="file">
                    <div class="document-bottom">
      		          <a class="btn icon-link btn-warning btn-sm" rel="publisher" href="../../uploads/{$document.project_id}/{$document.name}" download>
                        <i class="fa fa-download"></i>
                      </a>
                      <a class="btn icon-link btn-danger btn-sm link_deleteDocument" type_of_doc='Document' id='{$document.id}' document_path='{$document.path}'  rel="publisher">
                        <i class="fa fa-trash"></i>
                      </a>
                    </div>
                  </div>
                </div>
              </a>
              </li>
                {/foreach}
              </ul>
            </div>
            <div class="item">
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
          
        </div>

      </div>

      <div class="container">
        <div class="page-header">
          <h2> Todo </h2>
        </div>

        <div class="jumbotron">
          <a  href="../../pages/todo/todoPage.php?project_id={$project.id}#To-Do" > <img src="../../images/todo.png" alt="to do" class="img-responsive img-circle center-block" width="200"> </a>
        </div>
      </div>
      
      <div class="container text-center">
        Start : {$project.start} | Deadline : {$project.deadline}
        <div class="progress" id="progress-bar-div">
          <div class="progress-bar" role="progressbar" aria-valuenow="{$percent_complete}" aria-valuemin="0" aria-valuemax="100" style="width: {$percent_complete}%;">
            <span class="sr-only">{$percent_complete}% Complete</span>
          </div>
        </div>
      </div>
    </div>
  
