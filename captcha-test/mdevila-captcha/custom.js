//form submit
var form = document.getElementById("captcha_form");
form.onsubmit = function() {
    if (Captcha.isCorrect()) {
        alert("Success");
    } else {
        alert("Failed");
        return false;
    }
}


//reset
document.getElementById("btn_reset").onclick = function() {
    Captcha.reset();
    return false;
}