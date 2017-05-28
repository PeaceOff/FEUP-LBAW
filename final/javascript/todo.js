$(document).ready(function(){

	var url = window.location.href;
        var anchor = '#' + url.substring(url.indexOf("#")+1);
        //$('[href="' + anchor + '"]').click();
        setup_todo_functions();

});

function todo_setTask_id(){
	$('.task-id-handler').attr('task_id',$(this).attr('task_id'));
	$('input.task-id-handler').attr('value',$(this).attr('task_id'));
}


function setup_information(){
	$(".btn-assign-task-id").click(todo_setTask_id);
	get_task_information();

	$('.btn-delete-task').click(function(){
		var task_id = $(this).attr('task_id'); 
		$.ajax({
			type: "POST",
			url: "../../actions/todo/action_delete_task.php",
			data:	{
					project_id: $_GET('project_id'),
					task_id: task_id 
					}
		}).done(function(arg){
			addWarning('success', 'Task Deleted!');
			$('.task-card[task_id='+task_id+']').remove();
		}).fail(function(arg){
				console.log(arg);
			addWarning('warning', 'Cannot Delete Task!');
		});
	});

}

function addUser(target, username, task_id){
	var template = $(".template .t_remove .deassign_user").clone(true);
	template.attr("title",username);
	template.attr("task_id", task_id);
	target.children("h5").after(template);
	console.log(target);
	template.find("i").attr("title",username);	
}

function setup_todo_functions(){
	
	setup_information();

	$(".assignUser").click(function(){
		var username = $(this).html();	
		var task_id = $(this).parent().attr('task_id'); 
		$.ajax({
			type: "POST",
			url: "../../actions/todo/action_assign_task.php",
			data:	{
				project_id: $_GET('project_id'),
				collaborator: username,
		   		task_id: task_id 
				}
		}).done(function(arg){
			var container = $(".task-card[task_id="+task_id+"] .collaborator");
			addUser(container, username, task_id);
			addWarning('success', 'User Assigned to the task!');
		}).fail(function(){
			addWarning('warning', 'Cannot Assign User!');
		});
	});

	$('.btn-change-task').click(function(){
		var task_id = $(this).parent().attr('task_id'); 
		var category = $(this).html();
		$.ajax({
			type: "POST",
			url: "../../actions/todo/action_assign_category.php",
			data:	{
					category: category,
					project_id: $_GET('project_id'),
					task_id: task_id 
					}
		}).done(function(arg){
			addWarning('success', 'Changed Category');
			$('.task-card[task_id='+task_id+']').remove();
		}).fail(function(){
			addWarning('warning', 'Cannot Change Category');
		});
	});

	

}
