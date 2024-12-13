$(document).ready(function(){

	getAdmins();
	
	function getAdmins(){
		$.ajax({
			url : '../admin/classes/Admin.php',
			method : 'POST',
			data : {GET_ADMIN:1},
			success : function(response){
				console.log(response);
				var resp = $.parseJSON(response);

				if (resp.status == 202) {
					var adminHTML = '';

					$.each(resp.message, function(index, value){
						adminHTML += '<tr>'+
										'<td>#</td>'+
										'<td>'+ value.name +'</td>'+
										'<td>'+ value.email +'</td>'+
										'<td>'+ value.is_active +'</td>'+
										// '<td><a class="btn btn-sm btn-danger"><i class="fas fa-trash-alt"></i></a></td>'+
										'<td><a pid="'+value.id+'" class="btn btn-sm btn-danger delete-user" style="color:#fff;"><i class="fas fa-trash-alt"></i></a></td>'+

										'</tr>';
					});

					$("#admin_list").html(adminHTML);

				}else if(resp.status == 303){
					$("#admin_list").html(resp.message);
				}

				

				

			}
		})
		
	}
	

	$(".add-brand").on("click", function(){

		alert();

	});

});

$(document.body).on('click', '.delete-user', function(){


	var pid = $(this).attr('pid');
	if (confirm("Are you sure to delete this user ?")) {
		$.ajax({

			url : '../admin/classes/Admin.php',
			method : 'POST',
			data : {DELETE_USER: 1, pid:pid},
			success : function(response){
				console.log(response);
				var resp = $.parseJSON(response);
				if (resp.status == 202) {
					alert('User delete successfully')
				}else if (resp.status == 303) {
					alert(resp.message);
				}
			}

		});
	}else{
		alert('Cancelled');
	}
});