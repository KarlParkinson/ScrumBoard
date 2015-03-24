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
	taskBody = ui.item.children().text();
	updateTaskStatus(taskId, taskBody, columnStatus);
    }
 
    var order = [];
    var toBeSorted = $('#' + columnStatus + '-tasks-container li');
    toBeSorted.each(function(i) {
	order.push({ id: $(this).attr("data-id"), position: i+1 });
    });
    updateOrder(order);
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
	console.log("hello there");
	$.get($("#boards_search").attr("action"), $("#boards_search").serialize(), null, "script");
	return false;
    });
};
