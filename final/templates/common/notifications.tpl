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
        <a href="#" class="btn_delete_all_notifications"> <h4 class="notifications-title pull-right ">Dismmiss all    <i class="fa fa-arrow-right" aria-hidden="true"></i></h4> </a>
        {/if}
      </div>
    </li>
    <li class="divider"></li>
    <li>
    <div class="notifications-wrapper" style="overflow-y:scroll;">
      {foreach from=$notifications item=notification}
        <div class="notification-item" data-notification_id="{$notification.id}">
          <div class="item-title">{$notification.description}</div>
          <p class="item-info">{$notification.time}</p>
          <div class="notification-links pull-right">

            <a class="notificationOnNavBar btn_delete_notification my_clickable" data-notification_id="{$notification.id}"><i class="fa fa-check fa-2x " aria-hidden="true"></i>  </a>

          </div>
        </div>
      {/foreach}
     </div>
    </li>
    <li class="divider"></li>
  </ul>
</div>
