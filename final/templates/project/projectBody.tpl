{include file='project/addFile-form.tpl'}
{include file='project/addLink-form.tpl'}

<script type="text/javascript" src = "../../javascript/search.js"></script>


<div class="template searchResult">
  <a class="resultLink" href="#">
    <li class="container">
      <h2 class="col-xs-7 col-sm-5 col-md-3 col-lg-3 resultHeader">Title</h2>

      <div class="col-xs-5 col-sm-7 col-md-9 col-lg-9">
        <ul class="nav nav-pills nav-stacked">
          <li><h5 class="resultBody">Description</h5></li>
        </ul>
      </div>

    </li>
  </a>
</div>

<div class="col-md-12">
  <div class="container">
    <h1 class="text-center page-header">{$project.name}</h1>
  </div>

    <div class="container">
      <div class="well projectDescription"> {$project.description} </div>
    </div>


    <div class="container">
      <div class=" col-md-6 col-md-offset-3">
          <div class="form-group has-feedback" id="searchArea">
            <label for="searchQuery" class="sr-only">Search</label>
            <input type="text" class="form-control" name="search" placeholder="search" id="searchQuery">
            <span class="glyphicon glyphicon-search form-control-feedback "></span>
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
            <a class="my_clickable" data-toggle="modal" data-target="#addLink"> <i class="fa fa-plus" aria-hidden="true"></i></a>
            <a class="my_clickable" > <i class="edit-link fa fa-pencil" aria-hidden="true"></i> </a>
          {/if}
      </h3>

    </div>
    <ul class="links-ul list-inline" style="overflow-x:scroll; white-space: nowrap;">
      {foreach from=$links item=link}
      <li>
        <a href="#" class="invisible link_deleteDocument" data-type_of_doc='Link' id='{$link.id}'><i class="fa fa-times delete-link fa-2x" aria-hidden="true"></i></a>
        <a href="{$link.path}" title="{$link.path}" >
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
         <a class="my_clickable" data-toggle="modal" data-target="#uploadFile"> <i class="fa fa-plus" aria-hidden="true"></i> </a>
      {/if}

      </h3>
    </div>



    <ul class="list-inline documents" >
      {foreach from=$documents item=document}

        <li>
                <div class="card document">
                  <a class="cardLink" href="../../uploads/{$document.project_id}/{$document.name}" target="_blank">
                  <h3>{$document.name}</h3>
                  <img class="img-responsive" src="../../images/document-card.png" alt="file">
                  </a>
                  <div class="document-bottom">
                    <a class="btn icon-link btn-warning btn-sm" rel="publisher" href="../../uploads/{$document.project_id}/{$document.name}" download>
                      <i class="fa fa-download"></i>
                    </a>
                    <a class="btn icon-link btn-danger btn-sm link_deleteDocument" data-type_of_doc='Document' id='{$document.id}' data-document_path='{$document.path}'  rel="publisher">
                      <i class="fa fa-trash"></i>
                    </a>

                </div>
               </div>


        </li>

      {/foreach}
     </ul>





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
  
