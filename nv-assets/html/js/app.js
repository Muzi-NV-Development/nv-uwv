$(document).ready(function () {


    window.addEventListener('message', function (event) {
        var data = event.data;
        if (data.action == 'open') {
            openUI(data.text, data.style)
        }

    })
})

function openUI(text, style) {
    var parent = $('.noti-container')
    $(parent).html("");
    if (style == 'inform') {
        $(parent).append('<p id="noti-text"><i  id="inform"></i>' + text + '</p>')
    } else if (style == 'error') {
        $(parent).append('<p id="noti-text"><i  id="error"></i>' + text + '</p>')
    } else {
        $(parent).append('<p id="noti-text"><i class="fa fa-check" id="success"></i>' + text + '</p>')
    }
    $('.noti-container').fadeIn()
    setTimeout(
        function () {
            $('.noti-container').fadeOut()
        }, 4000);
}