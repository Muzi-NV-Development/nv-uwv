var button = undefined

$(document).ready(function () {


    window.addEventListener('message', function (event) {
        var data = event.data;
        if (data.action == 'open') {
            openUI()
        }

    })
})

$(document).on('click', '.btn', function (evt) {
    evt.preventDefault();
    button = this.id
    $('.confirm_button').fadeIn(500)
});

$(document).on('click', '.confirmbutton', function (evt) {
    closeUI()
    $.post('https://js-gemeente/givecart', JSON.stringify({
        type: button,
    }));
});

function openUI() {
    $(".tablet").fadeIn(1000);
}

function closeUI() {
    $(".tablet").fadeOut(1000);
    $('.confirm_button').fadeOut(500)
    $.post('https://js-gemeente/close', JSON.stringify({}));
}

$(document).on('keydown', function () {
    switch (event.keyCode) {
        case 27: // ESC
            closeUI()
            break;
    }
});