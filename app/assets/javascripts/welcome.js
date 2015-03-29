$(init);

function init() {
    $('#my-link').click(function(event) {
	$('.form-container').css('display', 'block');
    });

    $('#close-img').click(function(event) {
	$('.form-container').css('display', 'none');
    });
};
