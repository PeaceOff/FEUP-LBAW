<a class="btn dropdown-toggle"  id="dLabel" role="button" data-toggle="dropdown" >
  <i class="fa fa-bell" aria-hidden="true" style="font-size : 1.25em"></i>
  <span class="badge badge-notify">{$notification_number}</span>
</a>
<div class="dropdown-menu" role="menu" >
  <ul class="notifications padding-left-0" aria-labelledby="dLabel">
    <li>
      <div class="notification-heading">
        <h4 class="notifications-title">Notifications</h4>
        {if $notification_number != 0}
        <a href="#"> <h4 class="notifications-title pull-right">Dismmiss all    <i class="fa fa-arrow-right" aria-hidden="true"></i></h4> </a><!--TODO delete das notificacoes-->
        {/if}
      </div>
    </li>
    <li class="divider"></li>
    <li>
    <div class="notifications-wrapper" style="overflow-y:scroll;">
      {foreach from=$notifications item=notification}
        <div class="notification-item">
          <h4 class="item-title">{$notification.description}</h4>
          <p class="item-info">{$notification.time}</p>
          <div class="notification-links pull-right">
            {if $notification.invite}
            <a><i class="fa fa-check-circle fa-2x" aria-hidden="true"></i></a><!--TODO accept invite-->
            <a><i class="fa fa-times-circle fa-2x" aria-hidden="true"></i></a><!--TODO decline invite-->
            {else}
            <a><i class="fa fa-check fa-2x" aria-hidden="true"></i>  </a> <!--Delete notification-->
            {/if}
          </div>
        </div>
      {/foreach}
    </li>
    <li class="divider"></li>
  </ul>
</div>
      <!--Exemplos
        <div class="notification-item">
          <h4 class="item-title">David Azevedo Invited you to join LBAW-A3</h4>
          <p class="item-info">27-02-2017, one day ago</p>
          <div class="notification-links pull-right">
            <a><i class="fa fa-check-circle fa-2x" aria-hidden="true"></i></a>
            <a><i class="fa fa-times-circle fa-2x" aria-hidden="true"></i></a>
          </div>
        </div>


        <div class="notification-item">
          <h4 class="item-title">Marcelo Ferreira assigned you to a task on LBAW-A2</h4>
          <p class="item-info">27-02-2017, one day ago</p>
          <div class="notification-links pull-right">
            <a><i class="fa fa-check fa-2x" aria-hidden="true"></i>  </a>
          </div>
        </div>
-->
