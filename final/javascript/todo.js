current_task = 0;
$(document).ready(function(){

 setupUser();

});

function setupUser(){
	assignUser project_id

	$(".assignUser").click(function(){
		var username = $(this).html();	
		var task_id = current_task; 
		$.ajax({
			type: "POST",
			url: "../../actions/todo/action_assign_task.php",
			data:{
				project_id: $_GET('project_id'),
				collaborator: username,
		   		task_id: current_task}
		}).done(function(arg){
			console.log(arg);
		});
	});
}
