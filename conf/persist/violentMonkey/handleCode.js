// ==UserScript==
// @name         handleCode
// @namespace   Violentmonkey Scripts
// @match         *://*/*
// @grant       none
// @version     1.1
// @author      -
// @description 5/22/2021, 5:52:54 PM
// ==/UserScript==


document.addEventListener('mousedown', handleCode);


function handleCode(e) {

    if (e.ctrlKey || e.altKey) {
        var b = e.target;
        while (true) {
            var t = b.innerText;
            if (t) {
                var m = t.matchAll(/(\d{6})(.*)/g).next();
                if (m) {
                    var code = m.value[1];
                    if (e.ctrlKey) {
                        ahkRequest("tdx?code=" + code + "&action=stock");

                    }
                    else if (e.altKey) {
                        copyToClip(code, code + " copied!");
                    }
                    e.preventDefault();
                    e.stopImmediatePropagation();
                    e.cancelBubble = true;

                }
                break;
            }
            b = b.parentElement;
        }
    };


}

function copyToClip(content, message) {
    var aux = document.createElement("input");
    aux.setAttribute("value", content);
    document.body.appendChild(aux);
    aux.select();
    document.execCommand("copy");
    document.body.removeChild(aux);
    ahkRequest("toolTip?msg=" + message);

}

function ahkRequest(action) {
    var xmlHttpRequest = new XMLHttpRequest();
    xmlHttpRequest.open("GET", "http://127.0.0.1:11031/" + action, true);
    xmlHttpRequest.onreadystatechange = function () {
        console.log(this.readyState);
        console.log(this.responseText);
    }
    xmlHttpRequest.send();
}

