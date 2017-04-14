<div id="sidebar-left" class="col-sm-2 padding-0 minimized color-grey">
  <div class="left-sidebar-btn">
    <i class="fa fa-chevron-right hide-actor" target="sidebar-left" style="cursor : pointer"></i>
  </div>
  <ul class="sidebar-nav">
    {foreach from=$folders item=folder}
    <li class="open divider">
        <a href="#" data-toggle="collapse" data-target="#{$folder.id}">{$folder.name}<span class="caret"></span></a>
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


    <!-- Exemplo
      <li class="open divider">
          <a href="#" data-toggle="collapse" data-target="#folder1">Folder 1<span class="caret"></span></a>
          <ul class="collapse" id="folder1">
              <li>
                  <a href="../project/projectPage.php">Project 01</a>
              </li>
              <li>
                  <a href="../project/projectPage.php">Project 02</a>
              </li>
          </ul>
      </li>
    -->
