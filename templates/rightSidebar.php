<div id="sidebar-right" class="col-sm-2 padding-0 dockable minimized color-black">
    <div class="right-sidebar-btn">
        <i class="fa fa-chevron-left hide-actor" target="sidebar-right" style="cursor : pointer"></i>
    </div>
    <ul class="sidebar-nav">
        <li class="open divider">
            <a href="#" data-toggle="collapse" data-target="#folder1-right">Users<span class="caret"></span></a>
            <ul class="collapse" id="folder1-right">
                <li>
                    <a href="#">User A</a>
                </li>
                <li>
                    <a href="#">User B</a>
                </li>
            </ul>
        </li>
    </ul>
    <div class="container">
        <ul class="btn-group-vertical">
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
