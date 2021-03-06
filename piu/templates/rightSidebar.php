<?php
    include_once 'addTopic-form.php';
?>


<div id="sidebar-right" class="col-sm-2 padding-0 dockable minimized color-grey">
    <div class="right-sidebar-btn">
        <i class="fa fa-chevron-left hide-actor" target="sidebar-right" style="cursor : pointer"></i>
    </div>
    <ul class="nav nav-tabs">
      <li class="nav-item ">
        <a class="nav-link color-blue" data-toggle="collapse" data-target="#project-users">Users</a>
      </li>
      <li class="nav-item">
        <a class="nav-link text-white " data-toggle="collapse" data-target="#project-adding-users">Add User</a>
      </li>
    </ul>
    <div id="project-users" class="collapse in">
      <table  class="table table-condensed table-style">
        <tr>
          <td>
            <p>José Martins</p>
          </td>
          <td class="align-right">
            <a class="btn icon-link btn-danger btn-sm"  href="#">
              <i class="fa fa-trash"></i>
            </a>          </td>
        </tr>
        <tr>
          <td>
              <p>João Ferreira</p>
          </td>
          <td class="align-right">
            <a class="btn icon-link btn-danger btn-sm"  href="#">
              <i class="fa fa-trash"></i>
            </a>
          </td>
        </tr>
        <tr>
          <td>
            <p>David Azevedo</p>
          </td>
          <td class="align-right" aria-expanded="false">
            <a class="btn icon-link btn-danger btn-sm"  href="#">
              <i class="fa fa-trash"></i>
            </a>          </td>
        </tr>

        <tr>
          <td>
            <p>Marcelo Ferreira</p>
          </td>
          <td class="align-right" aria-expanded="false">
            <a class="btn icon-link btn-danger btn-sm"  href="#">
              <i class="fa fa-trash"></i>
            </a>          </td>
        </tr>
      </table>
    </div>
    <div id="project-adding-users" class="collapse">
      <div class="input-group form-group">
        <span class="input-group-addon" ><i class="glyphicon glyphicon-plus"></i></span>
        <input class="form-control" type="text" placeholder="Username" tabindex = "1" name="username" value="" required="" autofocus="">
      </div>
    </div>
    <ul class="nav nav-tabs">
      <li class="nav-item ">
        <a class="nav-link color-blue" data-toggle="collapse" data-target="#project-forum">Forum</a>
      </li>
      <li class="nav-item">
        <a class="nav-link text-white " data-toggle = "modal" data-target = "#addTopic">Add Topic</a>
      </li>
    </ul>
    <div id="project-forum" class="collapse in">
      <table  class="table table-condensed table-style ">
        <tr>
          <td>
            <button class="btn btn-primary" data-toggle="modal" data-target="#forum1"> Forum Topic 1 </button>
          </td>
          <td class="align-right">
            <a class="btn icon-link btn-danger btn-sm"  href="#">
              <i class="fa fa-trash"></i>
            </a>
          </td>
        </tr>
        <tr>
          <td>
            <button class="btn btn-primary" data-toggle="modal" data-target="#forum1">Forum Topic 2 </button>
          </td>
          <td class="align-right">
            <a class="btn icon-link btn-danger btn-sm"  href="#">
              <i class="fa fa-trash"></i>
            </a>
          </td>
        </tr>
        <tr>
          <td>
            <button class="btn btn-primary" data-toggle="modal" data-target="#forum1">Forum Topic 3 </button>
          </td>
          <td class="align-right">
            <a class="btn icon-link btn-danger btn-sm"  href="#">
              <i class="fa fa-trash"></i>
            </a>
          </td>
        </tr>
        <tr>
          <td>
            <button class="btn btn-primary" data-toggle="modal" data-target="#forum1">Forum Topic 4 </button>
          </td>
          <td class="align-right">
            <a class="btn icon-link btn-danger btn-sm"  href="#">
              <i class="fa fa-trash"></i>
            </a>
          </td>
        </tr>
      </table>
    </div>
    <?php include_once '../templates/forumExample.php'; ?>
</div>
<script>
    $(document).ready(function () {
        var get_vars = window.location.search.substring(1);
        var single_vars = get_vars.split('&');
        for (var i = 0; i < single_vars.length; i++)
        {
            var param_name = single_vars[i].split('=');
            if (param_name[0] == "forum")
                $("#"+param_name[1]).modal('show');
        }
    });
</script>
