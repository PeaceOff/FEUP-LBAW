<div id="sidebar-left" class="col-sm-2 padding-0 minimized color-grey">
  <div class="left-sidebar-btn">
    <i class="fa fa-chevron-right hide-actor" data-target="sidebar-left" style="cursor : pointer"></i>
  </div>
  <ul class="sidebar-nav">
     <li> <button type="button" class="btn btn-primary btn-block btn-sm " data-toggle="modal" data-target ="#addFolder"><i class="fa fa-plus" aria-hidden="true">       Create Folder</i></button>  </li>

    {foreach from=$folders item=folder}
        {if $folder.name neq "DEFAULT"}
            <li>
                <form action="../../actions/profile/action_delete_folder.php" method="post" >
                    <input type="hidden" name="folderName" value='{$folder.id}'>
                    <button type="submit" id="completed-task" class="btn btn-primary btn-block btn-sm remove-folder-btn">
                        <i class="fa fa-trash">    Delete Folder</i>
                    </button>
                </form>
            </li>
        {/if}

        <li class="open divider">
        <a class="my_clickable" data-toggle="collapse" data-target="#{$folder.id}">{$folder.name}<span class="caret"></span></a>
        <ul class="collapse" id="{$folder.id}">
          {foreach from=$folder.projects item=project}
            <li>
              <a href="{$project.page}">{$project.name}</a>
            </li>
          {/foreach}
        </ul>

      </li>
    {/foreach}
  </ul>
</div>
