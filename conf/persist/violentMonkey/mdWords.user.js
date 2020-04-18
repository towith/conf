// ==UserScript==
// @name        New script 1
// @namespace   Violentmonkey Scripts
// @match       file:///*/*.md
// @grant       none
// @version     1.0
// @author      -
// @description 2/29/2020, 4:38:19 PM
// ==/UserScript==
//


var msgDiv;
var playStack = [];
var highlightStack = [];

var showTranslate = false;
var showFamiliar = false;
var remainCount;
var remainCurrent;

function setFamiliar(node, h1, value) {
    let key = "_m_" + h1.id;

    if (h1.id) {
        localStorage.setItem(key, value);
        return h1.id + ' <font color="yellow" >mark 1</font>';
    }
};

function doHideFamiliar(node, h1, ul) {
    if (node.familiarLevel == 1) {
        h1.style.display = 'none';
        ul.style.display = 'none';
    }
}

function hideFamiliar(h1, ul, playNode) {
    if (h1 && h1.id) {
        if (localStorage.getItem("_m_" + h1.id) == 1) {
            playNode.familiarLevel = 1;
            doHideFamiliar(playNode, h1, ul);
            remainCount = Math.max(remainCount - 1, 0);
        }
    }
};

function hideTranslate(ul) {
    if (ul && ul.children && ul.children.length == 2) {
        var t = ul.children[0];
        if (t) {
            t.style.display = 'none';
        }
    }
};

function toggleTranslate(node) {
    var ul = findUL(node);
    if (ul && ul.children && ul.children.length == 2) {
        var t = ul.children[0];
        if (t) {
            if (t.style.display == 'none') {
                t.style.display = '';
            } else {
                t.style.display = 'none';
            }
        }
    }

}


Audio.prototype.stop = function () {
    this.pause();
    this.currentTime = 0;
};

var nopromise = {
    catch: new Function()
};

Audio.prototype.solePlay = function () {
    while ((p = playStack.pop()) != null) {
        p.stop();
    }
    if (muted) {
        return;
    }
    // prevent others
    (this.play() || nopromise).catch(function () {
        console.log('Do not panic,Actually is ok;');
    });
    playStack.push(this);
}

var currentNodeI = 0;
var nearNode = null;
var numDiv;
var muted = false;

// var reachBegin = false;
// var reachEnd = false;

var t = setInterval(function () {
    if (/^(loaded|complete)$/.test(document.readyState))
        clearInterval(t), run();
}, 0);

var playNodes = document.getElementsByTagName('audio');
var wordNodes = document.getElementsByTagName('h1');

function ahkRequest(action) {
    if (action.startsWith("play")) {
        if (muted) {
            return;
        }
    }
    var xmlHttpRequest = new XMLHttpRequest();
    xmlHttpRequest.open("GET", "http://127.0.0.1:11031/" + action, true);
    xmlHttpRequest.onreadystatechange = function () {
        console.log(this.readyState);
        console.log(this.responseText);
    }
    xmlHttpRequest.send();
}


function repositionRemainCurrent(){
    remainCurrent = 0;
    for (i = 0; i <= currentNodeI; i++) {
        if (playNodes[i].familiarLevel != 1) {
            remainCurrent++;
        }
    }
}

function updateStatus() {
    if (!numDiv) {
        numDiv = document.createElement("span");
        document.body.appendChild(numDiv);
        numDiv.style.position = 'fixed';
        numDiv.style.color = 'grey';
        numDiv.style.margin = '1em';
        numDiv.style.padding = '0.3em 1em';
        numDiv.style.background = 'lightblue';
        numDiv.style.borderRadius = '5%';
        numDiv.style.right = 0;
    }
    numDiv.innerText = remainCurrent + '/' + remainCount + (" [" + ((muted == false) ? "Unmute" : "Mute") ) + "/" + ( ((showFamiliar == false) ? "UnFami" : "Fami") ) + "/" + (((showTranslate == false) ? "UnTrans" : "Trans") + "]");
}

window.onbeforeunload = function (e) {
    localStorage.setItem(getCurrentItemTitle(),currentNodeI);
    // e.returnValue="abc"
    // return "abc"
};

function getCurrentItemTitle(){
    ci = "CurrentItem_" + location.href.substring(location.href.lastIndexOf("/") + 1, location.href.indexOf("."))
    return ci;
}

run = function () {
    ;

    if ('scrollRestoration' in history) {
        history.scrollRestoration = 'manual';
    }


    setTimeout(function () {

        // for (i = 0; i < playNodes.length; i++) {
        //     var node = playNodes[i];
        //     node.childNodes[1].src = node.childNodes[1].src.replace('https://', 'http://');
        // }

        window.scrollTo(0, document.body.scrollHeight);
        // close left window
/*         window.dispatchEvent(new KeyboardEvent("keydown", {key: 'g'}));
        window.dispatchEvent(new KeyboardEvent("keydown", {key: 'x'}));
        window.dispatchEvent(new KeyboardEvent("keydown", {key: '0'}));
 */

        // ensure page load and parse
        if (playNodes == null || playNodes.length == 0) {
            if (parseInt(localStorage.getItem('maxTry')) > 10) {
                return
            }
            location.reload();
            if (localStorage.getItem('maxTry') == null) {
                localStorage.setItem('maxTry', 1);
            } else {
                localStorage.setItem('maxTry', parseInt(localStorage.getItem('maxTry')) + 1);
            }
        } else {
            localStorage.setItem('maxTry', 0);
        }

        // param control
        // get init index
        var initKind="byRestore";
        if ((k = location.href.indexOf("#")) != -1) {
            var word = location.href.substring(k + 1);
            word = word.trim().toLowerCase();
            for (l = 0; l < wordNodes.length; l++) {
                var wordNode = wordNodes[l];
                if (wordNode.id && wordNode.id == word) {
                    currentNodeI = l;
                    repositionRemainCurrent();
                    initKind="byWordSearch";
                    break;
                }
            }

        }

        if (location.search.indexOf("&appended") != -1) {
            currentNodeI = playNodes.length - 1;
            initKind = "byLast";
        }

        if (location.search.indexOf("&translate") != -1) {
            showTranslate = true;
        }

        if (location.search.indexOf("&familiar") != -1) {
            showFamiliar = true;
        }


        // screen words
        remainCount = playNodes.length;
        for (let playNodeKey in playNodes) {
            var playNode = playNodes[playNodeKey];
            var ul = findUL(playNode);
            var h1 = findH1FromUl(ul);
            if (!showFamiliar) {
                hideFamiliar(h1, ul, playNode);
            }
            if (!showTranslate) {
                hideTranslate(ul);
            }
        }
        ci = localStorage.getItem(getCurrentItemTitle())
            // var curNode = playNodes[currentNodeI];
            // handleCurrentNode(curNode);
        if (initKind=="byLast") {
            if (playNodes[currentNodeI].familiarLevel) {
                toNext();
            }
            remainCurrent = Math.min(1, remainCount);
        } else if(initKind=="byRestore"){
            if (ci && !isNaN(ci)){
                currentNodeI=parseInt(ci)
                repositionRemainCurrent()
            }else{ // to the most ahead
                if (playNodes[currentNodeI].familiarLevel) {
                    toPrev();
                }
                remainCurrent = remainCount;
            }
        }



        if (location.search.indexOf("&muted") != -1) {
            muted = true;
        }


        if (remainCount > 0) {
               // change style
        document.getElementsByClassName('markdown-body')[0].style.fontSize='28px'
        document.getElementsByClassName('markdown-body')[0].style.maxWidth='100%'
        
        s=document.createElement('style')
        s.innerText='ul li h2 { display:none }'
        document.head.appendChild(s)


        
            // try {
            //     playNodes[playNodes.length - 1].solePlay();
            // } catch (e) {
            // }

            var word = null;
            var node = playNodes[currentNodeI];
            scrollToNode(node);
            // var params = node.children[0].src.split('&');
            // for (i = 0; i < params.length; i++) {
            //     var s = params[i];
            //     var sArr = s.split('=');
            //     if (sArr.length == 2) {
            //         if (s[0] == 'q') {
            //             word = sArr[1];
            //             break;
            //         }
            //     }
            // }

            if (currentNodeI == playNodes.length - 1) {
                if (word != null && word.length > 0) {
                    ahkRequest("play?word=" + word);
                    // ahkRequest("mdLoaded");
                }
            }
            // display number
        }
        updateStatus();
 


    }, 400);

}

function showMsg(msg, seconds) {
    if (!msgDiv) {
        msgDiv = document.createElement("span");
        document.body.appendChild(msgDiv);
        msgDiv.style.position = 'fixed';
        msgDiv.style.margin = '1em';
        msgDiv.style.padding = '0.3em 1em';
        msgDiv.style.background = '#bcbcbc';
        msgDiv.style.borderRadius = '5%';
        msgDiv.style.right = 0;
        msgDiv.style.top = '3em';
    }
    msgDiv.style.display = '';
    msgDiv.innerHTML = msg;
    setTimeout(function () {
        msgDiv.innerText = '';
        msgDiv.style.display = 'none';
    }, seconds || 5000)
}

function findNearNode() {
    var scrollY = window.scrollY;
    for (i = 0; i < playNodes.length; i++) {
        var node = playNodes[i];
        var nodeOffset = node.offsetTop;
        if (nodeOffset >= scrollY) {
            nearNode = node;
            currentNodeI = i;
            break;
        }
    }
    return nearNode;
};

function findUL(startNode) {
    var curNode = startNode;
    if (curNode == null || !curNode.tagName) {
        return null;
    }
    var maxTry = 0;
    while (curNode.tagName.toUpperCase() != 'UL') {
        curNode = curNode.parentNode;
        maxTry++;
        if (maxTry > 100) {
            console.error("excess max try")
            return null;
        }
    }
    var previousElementSibling = curNode.previousElementSibling;
    if (previousElementSibling && curNode.previousElementSibling.tagName.toUpperCase() == 'H1') {
        return curNode;
    }

    curNode = curNode.parentNode;
    while (curNode.tagName.toUpperCase() != 'UL') {
        curNode = curNode.parentNode;
        maxTry++;
        if (maxTry > 100) {
            console.error("excess max try")
            return null;
        }
    }
    return curNode;
}

function findH1FromUl(ulNode) {
    if (ulNode) {
        previousElementSibling = ulNode.previousElementSibling;
        if (previousElementSibling && ulNode.previousElementSibling.tagName.toUpperCase() == 'H1') {
            return previousElementSibling;
        }
    }
    return null;
}

function findH1(startNode) {
    var ulNode = findUL(startNode);
    return findH1FromUl(ulNode);
}

function scrollToNode(nearNode) {
    var h1 = findH1(nearNode);
    window.scrollTo(0, h1.offsetTop);
    // do highlight
    while ((n = highlightStack.pop()) != null) {
        n[0].style.borderBottom = n[1];
        n[0].style.color = '';
    }

    highlightStack.push([h1, h1.style.borderBottom]);

    if (h1) {
        h1.style.color = 'darkturquoise';
        h1.style.borderBottom = '1px solid red';
    }
}

function handleCurrentNode(node) {
    if (node != null && node.familiarLevel != 1) {
        scrollToNode(node);
        node.solePlay();
        return true;
    }
    if (currentNodeI == 0 || currentNodeI == (playNodes.length - 1)) {
        throw "end";
    }
    return false;
}

// 1
function toPrev() {
    var c = currentNodeI;
    try {
        do {
            currentNodeI = Math.max(currentNodeI - 1, 0);
            var curNode = playNodes[currentNodeI];
        } while (!handleCurrentNode(curNode)) ;
    } catch (e) {
        currentNodeI = c;
        handleCurrentNode(playNodes[currentNodeI]);
        console.error(e);
    }
    remainCurrent = Math.max(remainCurrent - 1, Math.min(1, remainCount));
}

function toNext() {
    var c = currentNodeI;
    try {
        do {
            currentNodeI = Math.min(currentNodeI + 1, playNodes.length - 1);
            var curNode = playNodes[currentNodeI];
        } while (!handleCurrentNode(curNode)) ;

    } catch (e) {
        currentNodeI = c;
        handleCurrentNode(playNodes[currentNodeI]);
        console.error(e);
    }
    remainCurrent = Math.min(remainCurrent + 1, remainCount);
}

function handleNearby(node) {
    if (!handleCurrentNode(node)) {
        toNext();
    }
}

function unsetFamiliar(node, h1, value) {
    let key = "_m_" + h1.id;
    if (value == localStorage.getItem(key)) {
        localStorage.removeItem(key);
        return h1.id + ' <font color="blue">unmark 1</font>';
    }
    return h1.id + " <font color='red'>not marked</font>";
}

// document.onkeypress = function (event) {
document.onkeydown = function (event) {
    const prevCode = 'ArrowLeft';
    const nextCode = 'ArrowRight';
    const playCode = 'ArrowDown';
    const repositionCode = 'ArrowUp';
    const muteToggleCode = 'Backslash';
    const markFamiliarCode = 'Digit1';
    const toggleTransCode = 'Digit7';
    const picCode = 'Equal';

    console.log('the code is:' + event.code);

    if (event.code == prevCode) {
        if (event.altKey) {
           currentNodeI=-1;
           remainCurrent=0;
           toNext();
        }else{
           var curNode = toPrev();
        }
    } else if (event.code == nextCode) {
        if (event.altKey) {
          currentNodeI=playNodes.length;
          remainCurrent=remainCount+1;
          toPrev();
        }else{
          toNext();
        }
    } else if (event.code == playCode) {
        var curNode = playNodes[currentNodeI];
        curNode.solePlay();
        event.preventDefault();
    } else if (event.code == repositionCode) {
        var nearNode = findNearNode();
        console.log(nearNode);
        handleNearby(nearNode);
        repositionRemainCurrent();
        event.preventDefault();
    } else if (event.code == muteToggleCode) {
        muted = !muted;
    } else if (event.code == markFamiliarCode) {
        var curNode = playNodes[currentNodeI];
        var ul = findUL(curNode);
        var h1 = findH1FromUl(ul);
        var familiar;
        if (event.shiftKey) {
            familiar = unsetFamiliar(curNode, h1, 1);
        } else {
            familiar = setFamiliar(curNode, h1, 1);
        }
        if (remainCurrent == remainCount) {
            toPrev();
        } else {
            toNext();
            remainCurrent = Math.min(remainCurrent - 1, remainCount);
        }

        hideFamiliar(h1, ul, curNode)
        showMsg(familiar + " ", 3000)
    } else if (event.code == toggleTransCode) {
        var curNode = playNodes[currentNodeI];
        toggleTranslate(curNode);
    } else if(event.code==picCode){
        var w;
        if(event.shiftKey){
            w = window.getSelection().toString();
        }else{
            var curNode = playNodes[currentNodeI];
            var ul = findUL(curNode);
            var h1 = findH1FromUl(ul);
            if(h1){
                w=h1.id
            }
        }
        ahkRequest("run?run=" + encodeURIComponent('vivaldi.exe --profile-directory="Profile 4" "https://cn.bing.com/images/search?q=' + (w && w.trim())) + '"')
    }
    updateStatus();
}

