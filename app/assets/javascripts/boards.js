// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

var updateTaskStatus = function(taskId, taskBody, taskStatus) {
    var task = {status: taskStatus, body: taskBody};
    $.ajax({
	type: "PATCH",
	url: window.location.pathname + '/tasks/' + taskId,
	data: {task: task}
    });
}

var updateOrder = function(order) {
    $.ajax({
	type: "PUT",
	url: window.location.pathname + '/tasks/sort',
	data: {order: order}
    });
}

var updateRespond = function(event, ui) {
    var taskStatus = ui.item.attr("data-cat");
    var columnStatus = ui.item.parent().parent().attr("id");
    if (taskStatus != columnStatus) {
	ui.item.attr("data-cat", columnStatus);
	taskId = ui.item.attr("data-id");
	taskBody = ui.item.find(".task").text();
	updateTaskStatus(taskId, taskBody, columnStatus);
    }
 
    var order = [];
    var toBeSorted = $('#' + columnStatus + '-tasks-container li');
    toBeSorted.each(function(i) {
	order.push({ id: $(this).attr("data-id"), position: i+1 });
    });
    updateOrder(order);
};

var mouseInTask = function() {
    $(this).find(".edit-delete").css("display", "block");
}

var mouseOutTask = function() {
    $(this).find(".edit-delete").css("display", "none");
}

var mouseHoverBind = function() {
    $('.task-list-entry').hover(mouseInTask, mouseOutTask);
    console.log("mouse in and out bound");
}

var closePopUpForm = function() {
    $('.square').css('display', 'block');
    $('.form-container').css('display', 'none');
}

var showPopUpForm = function() {
    $('.square').css('display', 'none');
    $(".form-container").css("display", "block");
}

var closeImgBind = function() {
    $('close-form-img').click(function(event) {
	$('.square').css('display', 'block');
	closePopUpForm();
    });
}

$ ( init );

function init() {
    $('.draggable').draggable({
	containment: '.flex-container',
	cursor: 'move',
	revert: true
    });
    
    $('.sortable').sortable({
	update: updateRespond,
	connectWith: '.connected-sortable'
    }).disableSelection();

    $("#boards_search input").keyup(function() {
	$.get($("#boards_search").attr("action"), $("#boards_search").serialize(), null, "script");
	return false;
    });

    $('.close-form-img').click(function(event) {
	$('.square').css('display', 'block');
	$('.form-container').css('display', 'none');
    });

    mouseHoverBind();

    $('#search-field').val('');
};
