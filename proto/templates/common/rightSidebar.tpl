 {include file='../../templates/forum/addTopic-form.tpl'}
<div id="sidebar-right" class="col-sm-2 padding-0 dockable minimized color-grey">
    <div class="right-sidebar-btn">
        <i class="fa fa-chevron-left hide-actor" target="sidebar-right" style="cursor : pointer"></i>
    </div>
    <ul class="nav nav-tabs">
      <li class="nav-item ">
        <a class="nav-link color-blue" data-toggle="collapse" data-target="#project-users">Users</a>
      </li>
	{if $isManager}
      <li class="nav-item">
        <a class="nav-link text-white " data-toggle="collapse" data-target="#project-adding-users">Add User</a>
      </li>
	{/if}
    </ul>
    <div id="project-users" class="collapse in">
      <table  class="table table-condensed table-style">
        {foreach from=$collaborators item=collaborator}
          <tr>
            <td>
              <p>{$collaborator.name}</p>
            </td>
            <td class="align-right">
	{if $isManager && $managerName != $collaborator.name}
              <a class="btn icon-link btn-danger btn-sm link_removeUser" username="{$collaborator.name}" href="#"><!--TODO delete user from project!-->
                <i class="fa fa-trash"></i>
              </a>
	{/if}
            </td>
          </tr>
        {/foreach}
      </table>
    </div>
    <div id="project-adding-users" class="collapse">
      <div class="input-group form-group">
        <span class="input-group-addon" ><i class="glyphicon glyphicon-plus"></i></span><!--TODO add user by name to project-->
        <input id="form-addUser" class="form-control" type="text" placeholder="Username" tabindex = "1" name="username" value="" required="" autofocus="">
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
        {foreach from=$forums item=forum}
        <tr>
          <td>
            <button class="btn btn-primary" data-toggle="modal" data-target="#{$forum.id}">{$forum.name}</button>
          </td>
	{if $isManager}
          <td class="align-right">
            <a class="btn icon-link btn-danger btn-sm"  href="#"><!-- TODO delete do forum-->
              <i class="fa fa-trash"></i>
            </a>
          </td>
	{/if}
        </tr>
        {/foreach}
      </table>
    </div>
    {include file='forum/forum.tpl'}<!--TODO para os templates e incluir-->
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
