{include file='common/header.tpl'}
{include file='todo/addTask-form.tpl'}
{include file='todo/assignCategory-form.tpl'}
{include file='todo/assignUser-form.tpl'}

<div class="container center-block" >
  <a class="link-no-style" href="projectPage.php"> <h1 class="text-center "> {$project_title} </h1> </a>
  <h3 class= "text-center page-header">Todo Board</h3>
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
      <ul class="dropdown-menu">
        <li><a href="#">High Priority</a></li>
        <li><a href="#">Low Priority</a></li>
        <li><a href="#">Art work</a></li>
      </ul>
    </li>
    <li class="nav-item">
      <a class="nav-link" data-toggle="modal" data-target="#createTask">+ Add Task</a>
    </li>
  </ul>
</div>
<div class="container margin-top-10">
  <div id="to-do" class="selectable">

    {foreach from=$tasks item=task}
    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12">
      <div class="card cardhandler">
        <div class="cardheader-todo">
          <div class="title outliner">
              Task Title
            <h5>Category</h5>
          </div>

        </div>
        <div class="desc"> Do mesmo modo, a estrutura atual da organização talvez venha a ressaltar a relatividade dos procedimentos normalmente adotados. O incentivo ao avanço tecnológico, assim como o consenso sobre a necessidade de qualificação desafia a capacidade de equalização das diversas correntes de pensamento.</div>
        <div class="people-envolved">
            <div class="owner">
              <h5>Owner</h5>
              <img class="avatar  icon-link img-circle" src="https://scontent.flis1-1.fna.fbcdn.net/v/t1.0-9/10685589_1467742693508948_4411023630260921835_n.jpg?oh=caf7288a15d35ccef8f663ec42ff24aa&oe=5933C887" alt="avatar">
            </div>
            <div class="collaborator">
              <h5>People Assigned</h5>
              <img class="avatar  icon-link img-circle" src="https://scontent.flis1-1.fna.fbcdn.net/v/t1.0-9/13907004_674374722711579_3540600821708478848_n.jpg?oh=4e5f211754e996c7375a68412c3809aa&oe=59259BF0" alt="avatar">
              <img class="avatar img-circle icon-link" src="https://scontent.flis1-1.fna.fbcdn.net/v/t1.0-9/12688317_1211046208923914_7204990918498495324_n.jpg?oh=544a63728bafb55ff66721f54b7196a3&oe=5928FEF7" alt="avatar">

              <a class="btn icon-link btn-success btn-sm" data-toggle="modal" data-target="#assign-user-modal">
                  <i class="fa fa-plus"></i>
              </a>
            </div>

        </div>

        <div class="bottom">
          <a class="btn icon-link btn-primary  btn-sm" >
            <i class="fa fa-pencil"></i>
          </a>
          <a class="btn icon-link btn-warning btn-sm"  data-toggle="modal" data-target="#assign-category-modal">
            <i class="fa fa-arrows"></i>
          </a>
          <a class="btn icon-link btn-info btn-sm" data-toggle="modal" data-target="#forum1">
            <i class="fa fa-comments-o"></i>
          </a>
          <a class="btn icon-link btn-danger btn-sm"  >
            <i class="fa fa-trash"></i>
          </a>

        </div>
      </div>
    </div>
    {/foreach}

  </div>

  <div id="doing" class="selectable">
  </div>

  <div id="done" class="selectable">
  </div>
</div>


{include file='common/footer.tpl'}
