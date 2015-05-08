$(document).ready(function(){
	$(".preview").hide();
	$(".editor").show();

  $("#editor-button-preview").click(function(){
  	$(this).addClass("btn-default");
  	$(this).removeClass("btn-link");
  	$("#editor-button-editor").removeClass("btn-default");
  	$("#editor-button-editor").addClass("btn-link");
  	
  	$(".editor").hide();
  	$(".preview").show();
  	
  	$(".preview").html($(".editor").val());
  });
  $("#editor-button-editor").click(function(){
  	$(this).addClass("btn-default");
  	$(this).removeClass("btn-link");
  	$("#editor-button-preview").removeClass("btn-default");
  	$("#editor-button-preview").addClass("btn-link");
  	
  	$(".editor").show();
  	$(".preview").hide();
  });
});
