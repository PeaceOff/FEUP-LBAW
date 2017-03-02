<div id="sidebar-right" class="col-sm-2 padding-0 dockable minimized color-grey">
    <div class="right-sidebar-btn">
        <i class="fa fa-chevron-left hide-actor" target="sidebar-right" style="cursor : pointer"></i>
    </div>
    <ul class="nav nav-tabs">
      <li class="nav-item active">
        <a class="nav-link color-blue" href="#">Users</a>
      </li>
      <li class="nav-item">
        <a class="nav-link text-white" href="#">Add User</a>
      </li>
    </ul>
    <table class="table table-condensed table-style">
      <tr>
        <td>
          User A
        </td>
        <td class="align-right">
          <button href="" class="btn btn-danger btn-xs"> Remove </button>
        </td>
      </tr>
      <tr>
        <td>
          User B
        </td>
        <td class="align-right">
          <button href="" class="btn btn-danger btn-xs"> Remove </button>
        </td>
      </tr>
      <tr>
        <td>
          User C
        </td>
        <td class="align-right">
          <button href="" class="btn btn-danger btn-xs"> Remove </button>
        </td>
      </tr>
    </table>
    <div class="width-100">
        <ul class="btn-group-vertical width-100 padding-0">
            <li class="btn btn-primary" data-toggle="modal" data-target="#forum1">Forum Topic 1</li>
            <li class="btn btn-primary" data-toggle="modal" data-target="#forum1">Forum Topic 2</li>
            <li class="btn btn-primary" data-toggle="modal" data-target="#forum1">Forum Topic 3</li>
        </ul>
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
