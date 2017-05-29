
function createWarningBox(){

	var e = $(document.createElement('div'));
	e.addClass('box-alerts');
	$('body').append(e);

}

function addWarning(type, msg){

  var e = $(document.createElement('div'));
  var alertType = 'alert alert-';
	alertType += type;
	e.addClass(alertType);
	type = type.charAt(0).toUpperCase() + type.slice(1);
	var message = '<strong>'+ type  +'</strong>'+ msg;
	e.append(message);
	$('.box-alerts').append(e);
	setTimeout(function() {
		e.remove();
	}, 2000);
}


function addShow(index){
  var target = $(this).attr("data-target");

  $(this).click(function(){
    toggleSideBar(target);
  });
}

function toggleSideBar(target){
  if($(window).width()  < 768)
    $('.show').each(function(index){
      if($(this)[0].id != target)
        $(this).removeClass('show');
    });
  $("#"+target).toggleClass("show");
}

function toggler_addListener(){
  var togglers = $('.toggler');
  $('.toggler').click(function(){
    togglers.each(function(i){
      $(this).parent().removeClass('active');
    });
    $(this).parent().addClass('active');
  });

}

function $_GET(param) {
	var vars = {};
	window.location.href.replace( location.hash, '' ).replace(
		/[?&]+([^=&]+)=?([^&]*)?/gi, 
		function( m, key, value ) { 
			vars[key] = value !== undefined ? value : '';
		}
	);

	if ( param ) {
		return vars[param] ? vars[param].replace("#","") : null;
	}
	return vars.replace("#","");
}

function remove_document(){

	$('.link_deleteDocument').click(function() {

			var documentId= $(this).attr('id');
			var type_of_doc = $(this).attr('type_of_doc');
			var document_path = $(this).attr('document_path');
			var success;
			$.ajax({
				type: "POST",
				url: "../../actions/project/action_delete_document.php",
				data: {project_id: $_GET('project_id'), document_id: documentId , type_of_doc: type_of_doc, document_path: document_path}
			});
			
        	addWarning('success','Document deleted!');
			$(this).parents('li').remove();
	});

}

function remove_project(){

	$('.link_deleteProject').click(function() {
        var projectId= $('.link_deleteProject').parent().find('.project_id').val();
        handleRemoveProject(projectId,true, "Project deleted",$(this));
        });

    $('.link_deleteCollaboration').click(function() {
        var projectId= $('.link_deleteCollaboration').parent().find('.project_id').val();
        handleRemoveProject(projectId,false, "Collaboration deleted",$(this));
    });
}

function handleRemoveProject(projectId, is_owner,message,context) {

    $.ajax({
        type: "POST",
        url: "../../actions/profile/action_delete_project.php",
        data: {project_id: projectId, isOwner: is_owner}
    }).done(function(arg){
        var obj = JSON.parse(arg);
        if(obj.success) {
            addWarning("success", message);
            context.parent().parent().parent().remove();
        }else{
            addWarning("warning", message);
		}
    });
}





function remove_user(){
	$('.link_removeUser').click(function() {
			var username = $(this).attr('username');
			$.ajax({
				type: "POST",
				url: "../../actions/project/action_remove_user.php",
				data: { username: username, project_id: $_GET('project_id')}
			}).done(function(arg){
				addWarning('success','User Deleted!');
			}).fail(function(){
				addWarning('warning','User NOT Found!');
			});

			$(this).parent().parent().remove();
	});
}

function get_task_information(){

	$('.btn_edit_task').click(function() {
		var task_id = $(this).attr('task_id');
		$.ajax({
            		type: "post",
            		dataType: "json",
            		url: '../../api/get_task_info.php',
            		data: {'task_id' : task_id}
		}).done(function(arg){
			$('.task_description').html(arg['description']);
			$('.task_deadline').attr('value', arg['deadline']);
			$('.task_category').val(arg['category']);
		});

	});
}


function delete_notification(){

	$('.btn_delete_notification').click(function() {
		var notification_id = $(this).attr('notification_id');
		var toDelete = $('.notification-item[notification_id="'+notification_id+'"');
		var bell = $('.badge.badge-notify');
		bell.html(Number(bell.html())-1);
		toDelete.css("visibility",'hidden');
		toDelete.css("position",'fixed');
		$.ajax({
            		type: "POST",
            		url: "../../actions/profile///action_delete_notification.php",
			data: { 'notification_id': notification_id}
		}).done(function(){
			addWarning('success','Notification deleted!');
			toDelete.remove();
		}).fail(function(){
			bell.html(Number(bell.html())+1);
			toDelete.css('visibility','visible');
			toDelete.css("position",'relative');
			addWarning('warning','Problem deleting notification');
		});

	});
}

function delete_all_notifications(){

	$('.btn_delete_all_notifications').click(function() {
		var toDelete = $('.notification-item');
		var bell = $('.badge.badge-notify');
		var oldValue = bell.html();
		toDelete.css("visibility",'hidden');
		toDelete.css("position",'fixed');
		bell.html("0");
		$.ajax({
            		type: "POST",
            		url: "../../actions/profile/action_delete_all_notifications.php"
		}).done(function(){
			addWarning('success','All notifications deleted!');
			toDelete.remove();
		}).fail(function(){
			bell.html(oldValue);
			toDelete.css('visibility','visible');
			toDelete.css("position",'relative');
			addWarning('warning','Problem deleting all notifications');
		});

	});
}


function get_project_information(){

	$('.btn_project_edit').click(function() {
		var id = $(this).attr('project_id');
		$('.hidden_projectId').attr('value',id);

		$.ajax({
            		type: "post",
            		dataType: "json",
            		url: '../../api/get_project_info.php',
            		data: {'project_id' : id}
		}).done(function(arg){
			$('.project_folder').val(arg['folder']['id']);
			$('.project_description').html(arg['description']);
			$('.project_deadline').attr('value', arg['deadline']);
		});

	});
}

function get_collaboration_information(){

    $('.btn_collaboration_edit').click(function() {
        var id = $(this).attr('collaboration_id');
        $('.hidden_collaboration_id').attr('value',id);

        $.ajax({
            type: "post",
            dataType: "json",
            url: '../../api/get_project_info.php',
            data: {'project_id' : id}
        }).done(function(arg){
            $('.project_folder').attr('value', arg['folder']['name']);
        });

    });
}


function deassign_user_from_task(){

    $('.deassign_user').click(function() {

        var task_id = $(this).attr('task_id');
        var username = $(this).attr('title');
        var project_id = $_GET('project_id');
		var toDelete = $(this);

        $.ajax({
            type: "post",
            url: "../../actions/todo/action_deassign_task.php",
            data: {'task_id' : task_id , 'username' : username, 'project_id': project_id}
        }).done(function(arg){
        	toDelete.remove();
            addWarning('success','Deassigned');
        }).fail(function(arg){
            addWarning('warning','Problems deassigning user from task');
		});

    });
}


function add_user(){

	$('#form-addUser').keypress(function(e) {

		var elem = $(this);
		key = (e.keyCode)? e.keyCode : e.charCode;
		if( key == 13){
			elem.prev().click();
			return false;
		}
	});

    $('#form-addUser').prev().click(function() {

	    var elem = $('#form-addUser');
			var username = elem.val();

			$.ajax({
				type: "POST",
				url: "../../actions/project/action_add_user.php",
				data: { username: username, project_id: $_GET('project_id')}
			}).done(function(arg){
				addWarning('success','User successfully added!');
                addColaborator(username);
				elem.val("");
			}).fail(function(){
				addWarning('warning','User NOT Found!');
			});
    });
}

function addColaborator(username){
    var element = $('.template tr').clone(true);

    element.find('.template_name').html(username);
    element.find('.link_removeUser').attr('username',username);
    $('#project-users tbody').append(element);

}



function touch_addListener(){
  var touchPosition = {x:0,y:0};
  var calculate = false;
  var size = 20;
  document.addEventListener('touchstart',function(e){

    touchPosition.x = e.changedTouches[0].pageX;
    touchPosition.y = e.changedTouches[0].pageY;
    calculate = touchPosition.x < size || touchPosition.x > $(window).width() - size;
  }, false);
  document.addEventListener('touchend',function(e){
    if(!calculate)
      return;
    var diffx = e.changedTouches[0].pageX - touchPosition.x;
    var diffy = e.changedTouches[0].pageY - touchPosition.y;

    if(Math.atan2(Math.abs(diffy), Math.abs(diffx)) < Math.PI*15/180 && Math.abs(diffx) > 30){
      if(diffx < 0){
        toggleSideBar("sidebar-right");
      }else{
        toggleSideBar("sidebar-left");
      }
    }

  }, false);
}

function setupDatePickers(){
  $('.datetimepicker').attr('type', 'text');
  $(".datetimepicker").datetimepicker({
    format: 'DD/MM/YYYY'
  });
}

function openModals(){
  var get_vars = window.location.search.substring(1);
  var single_vars = get_vars.split('&');
  for (var i = 0; i < single_vars.length; i++)
  {
      var param_name = single_vars[i].split('=');
      if (param_name[0] == "action")
          $("#"+param_name[1]).modal('show');
  }
}

function remove_date(){

	var last_value;

	$(".remove_date").change(function (){
		if(this.checked) {
            $(".project_deadline").addClass("disabled");
			last_value =  $(".project_deadline").attr("value");
            $(".project_deadline").attr("value", "null");
        }else {
            $(".project_deadline").removeClass("disabled");
            $(".project_deadline").attr("value", last_value);
		}
	});
}



Dropzone.options.myDropzone = {

 	autoProcessQueue: false,
 	addRemoveLinks: true,
	uploadMultiple: true,
	url: "../../actions/project/action_add_document.php",

	  init: function() {
    		var submitButton = document.querySelector("#submit-all");
       		myDropzone = this;

	    	submitButton.addEventListener("click", function(e) {
			e.preventDefault();
			e.stopPropagation();
     			myDropzone.processQueue();
	   	});

		this.on("processingmultiple", function(files) {

		});


		this.on("sendingmultiple", function(files, http, formData) {
			formData.append('project_id', $_GET('project_id'));
		});

		this.on("successmultiple", function(files, response) {
      			location.reload();
		});

		this.on("error", function(files, response) {
      			
			
		});

		this.on("queuecomplete", function(files) {
			
      			

		});


 	 }

};


function validateLogin() {


	$(".sign_in").submit(function(event){
        if($(".sign_in").attr("login_conf") == 1){
            return true;
        }

        var username = document.forms["signIn-form"]["username"].value;
        var password = document.forms["signIn-form"]["password"].value;

        $.ajax({
            type: "post",
            url: "../../actions/authentication/action_login_checker.php",
            data: {'username' : username, 'password': password}
        }).done(function(arg){
            addWarning('success','Loged in');

			$(".sign_in").attr("login_conf", 1);
            $(".sign_in").submit();


        }).fail(function(arg){
			addWarning("warning", "The username or password is not correct");
		});

        event.preventDefault();
	});
}



function validateRegister(){

    $(".register").submit(function(event){
        if($(".register").attr("register_conf") == 1){
            return true;
        }

        var username = document.forms["signUp-form"]["username"].value;
        var password = document.forms["signUp-form"]["password"].value;
        var confirmPassword = document.forms["signUp-form"]["confirmPassword"].value;

        $.ajax({
            type: "post",
            url: "../../actions/authentication/action_register_checker.php",
            data: {'username' : username, 'password' : password, 'confirmPassword' : confirmPassword}
        }).done(function(arg){

            $(".register").attr("register_conf", 1);
            $(".register").submit();

            addWarning('success','Registed with success');
        }).fail(function(arg){

            if(arg.status == 400) {
                addWarning("warning", "username already exists");
            }else if(arg.status == 401){
                addWarning("warning", "you can not register with that username");
			}else if(arg.status == 402){
            	addWarning("warning", "confirmation of password failed");
			}
		});

        event.preventDefault();
    });
}


$(document).ready(function(){
  if($(".view").length > 0) $("body").addClass('view');

  setupTodoListeners();
  setupForumListeners();
  setupDatePickers();
  touch_addListener();
  toggler_addListener();
  openModals();
  add_user();
  remove_user();
  remove_project();
  remove_document();
  delete_notification();
  delete_all_notifications();
  get_project_information();
  get_collaboration_information();
  get_task_information();
  deassign_user_from_task();
  remove_date();
  validateLogin();
  validateRegister();
  open_forum_modals();
  setTimeout(function(){
    $("body").removeClass("preload");
  },500);
	createWarningBox();
  $('.hide-actor').each(addShow);

});
