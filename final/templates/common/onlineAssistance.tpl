<div id="online_assistance" class="modal fade col-md-6 col-md-offset-3">
    <div class="modal-content modal-out">

        <div class="modal-header text-center">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title">Online assistance</h4>
        </div>

        <div class="modal-body">
            <form  id ="assistance" action="../../actions/assistance/send_email.php" method="post" style="display:block">

                <div class="form-group input-group width-100">
                    <label for="name"> Name</label>
                    <input class="form-control" type="text"  tabindex="1" id="name" name="name" value="" required="" >
                </div>

                <div class="form-group input-group width-100">
                    <label for="email"> Email</label>
                    <input class="form-control" type="email"  tabindex="2" id="email" name="email" value="" required="" >
                </div>

                <div class="form-group input-group width-100">
                    <label for="subject"> Subject</label>
                    <input class="form-control" type="text"  tabindex="3" id="subject" name="subject" value="" required=""  >
                </div>

                <div class="form-group input-group width-100">
                    <label for="content"> Message </label>
                    <textarea class="form-control resizable-horizontal" id="content" name="content" rows="3" tabindex="4" required="" ></textarea>
                </div>

                <div class="text-center">
                    <input class="btn btn-success " type="submit" name="send" value="send" tabindex="5">
                </div>

            </form>
        </div>
    </div>
</div>
