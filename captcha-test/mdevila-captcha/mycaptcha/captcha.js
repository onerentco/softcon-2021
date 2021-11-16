var Captcha = {
    parentDiv : document.querySelector("div.arrocap"),
    maxChar : 6,
    showInput : false,
    showRandom : false,
    value : null,
    arrayValue : null,
    arrowValue : [],
    arrowClass : ["ArrowLeft","ArrowUp","ArrowRight","ArrowDown"],
    customSalt : "W@1AXp2Ax4AfwQ",
    el : null,
    el_arrow : null,
    input : null,
    el_arrow_btn_div : null,
    el_arrow_btn : null,
    init : function(params = []) {
        
        if(typeof params.showInput != "undefined") {
            Captcha.showInput = params.showInput;
        }

        if(typeof params.showRandom != "undefined") {
            Captcha.showRandom = params.showRandom;
        }

        if(typeof params.customSalt != "undefined") {
            Captcha.customSalt = params.customSalt;
        }

        //create element for captcha text
        Captcha.createElement();
        Captcha.createArrowButton();

        Captcha.set();
        Captcha.events();
    },
    createElement : function () {
        var id = "captcha_text";
        var el_arrow_id = "captcha_arrow";
        var input_id = "captcha_input";
        var el_arrow_btn_div = "arrowButton_content";

        Captcha.parentDiv.innerHTML += `
            <div class="arrowcap_content">
                <p id="${id}" style="display: ${Captcha.showRandom ? "block" : "none"}"></p>
                <p id="${el_arrow_id}"></p>
                <input type="text" name="" id="${input_id}" disabled style="display: ${Captcha.showInput ? "block" : "none"}" placeholder="Captcha" required>
                <div class="${el_arrow_btn_div}"></div>
            </div>
        `;

        Captcha.el = document.getElementById(id);
        Captcha.el_arrow = document.getElementById(el_arrow_id);
        Captcha.input = document.getElementById(input_id);
        Captcha.el_arrow_btn_div = document.querySelector(`div.${el_arrow_btn_div}`);
    },
    createArrowButton : function() {
        var arrow_button_class = "arrowButton";
        for(x = 0; x < Captcha.arrowClass.length; x++) {
            Captcha.el_arrow_btn_div.innerHTML += `<button class="${arrow_button_class}" data-arrow="${Captcha.arrowClass[x]}"><span class="arrow ${Captcha.arrowClass[x]}"></span></button>`;
        }

        Captcha.el_arrow_btn = document.querySelectorAll(`button.${arrow_button_class}`);
    },
    create : function() {
        const str = atob("YUFiQmNDZERlRWZGZ0doSGlJakprS2xMbU1uTm9PcFBxUXJSc1N0VHVVdlZ3V3hYeVl6WjA5MTIzNDU2Nzg5");
        var strCaptcha = "";

        for (x = 0; x < Captcha.maxChar; x++) {
            strCaptcha += "<span>" + str[Math.floor(Math.random() * str.length)] + "</span>";
        }

        return strCaptcha;
    },
    set : function () {
        var captcha_value = Captcha.create();
        var clean_value = captcha_value.replace(/(<([^>]+)>)/ig, '');
        Captcha.el.innerHTML = captcha_value;
        Captcha.value = Captcha.encrypter(clean_value);
        Captcha.arrayValue = clean_value.split("");

        Captcha.setArrowValue();
    },
    setArrowValue : function() {
        Captcha.arrowValue = [];
        for (x = 0; x < Captcha.arrayValue.length; x++) {
            var arrow_index = Math.floor(Math.random() * 4); //random number from 0 to 3

            Captcha.arrowValue.push({
                key: Captcha.arrayValue[x],
                arrow_value: Captcha.arrowClass[arrow_index]
            });
        }

        var arrowVal = Captcha.arrowValue;
        var strArrow = "";
        if (arrowVal.length > 0) {
            for(x = 0; x < arrowVal.length; x++) {
                strArrow += `<span class="arrow ${arrowVal[x].arrow_value}"></span>`;
            }
        }

        Captcha.el_arrow.innerHTML = strArrow;
    },
    events : function() {
        Captcha.arrowEvent();
        Captcha.reset();
    },
    reset : function () {
        Captcha.set();
        Captcha.input.value = "";
    },
    arrowEvent : function() {
        document.onkeydown = function (event) {
            Captcha.arrowClick(event.key);
        }

        let arrowBtn = Captcha.el_arrow_btn;
        for (i = 0; i < arrowBtn.length; i++) {
            arrowBtn[i].onclick = function() {
                var arrowKey = this.getAttribute('data-arrow');
                Captcha.arrowClick(arrowKey);
                return false;
            }
        }
    },
    arrowClick : function(arrowKey) {
        var captcha_input = Captcha.input;
        var input_value = captcha_input.value;
        var i = input_value.length;

        if (i < Captcha.arrowValue.length) {
            if (arrowKey == Captcha.arrowValue[i].arrow_value) {
                Captcha.el_arrow.children.item(i).style.borderColor = "green";
                captcha_input.value += Captcha.arrowValue[i].key;
            } else {
                Captcha.el_arrow.children.item(i).style.borderColor = "red";
            }
        }
    },
    encrypter : function(str) {
        return btoa(Captcha.customSalt + str + Captcha.customSalt);
    },
    isCorrect : function() {
        var userInputCaptcha = Captcha.input.value;

        if (Captcha.value !== Captcha.encrypter(userInputCaptcha)) {
            return false;
        } else {
            return true;
        }
    }
}