// ==UserScript==
// @name         Direct download from Google Play
// @namespace    StephenP
// @version      2.6.2
// @description  Adds APK-DL, APKPure, APKMirror and Evozi download buttons to Google Play when browsing apps. This script is based on yurenchen's "google play apk downloader".
// @author       StephenP
// @match        https://play.google.com/*
// @match        http://play.google.com/*
// @match        http://apkfind.com/store/captcha?app=*
// @grant        GM.xmlHttpRequest
// @connect      self
// @connect      apkpure.com
// @connect      apkfind.com
// @connect      apk-cloud.com
// @connect      winudf.com
// ==/UserScript==
var ui;
var wlButton;
var pageURL;
var title;
var appCwiz;
(function () {
    if (document.location.href.includes("apkfind") === true) {
        setInterval(unredirect, 100);
    } else {
        try {
            'use strict';
            var site = window.location.href.toString();
            ui = checkUI();
            pageURL = location.href;
            title = document.getElementById("main-title").innerHTML;
            if (ui >= 3) {
                var buttonsStyle = document.createElement("style");
                var styleString = '.ddlButton:visited{color: white;} .ddlButton:hover{opacity: 0.8;} .ddlButton:active{opacity: 0.6;} .ddlButton{color: white; border-radius: 4px; border: 1px; font-size: 14px; height: 46px; padding: 5px; font-weight: 500; font-family: "Roboto",sans-serif; position: relative; text-align: center; line-height: 46px;';
                if (ui == 3) {
                    styleString += ' margin-right: 4px;}';
                    buttonsStyle.innerHTML = styleString;
                }
                if (ui == 4) {
                    styleString += ' margin-left: 4px;}';
                    buttonsStyle.innerHTML = styleString;
                }
                document.body.appendChild(buttonsStyle);
            }
            if (pageURL.includes("details?id=")) {
                addButtons();
            }
            setInterval(checkReload, 2000);
        } catch (err) {
            console.log("main(): " + err);
        }
    }
})();

function unredirect() {
    var tot = document.body.children.length - 1;
    if (parseInt(document.body.children[tot].style.zIndex, 10) > 2) {
        if (document.body.children[tot].id == "") {
            document.body.children[tot].style.zIndex = "1";
            document.body.children[tot - 1].style.zIndex = "-1000";
        } else {
            document.body.children[tot].style.zIndex = "-1000";
        }
    }
}

function waitForRemovingButtons() {
    //if(title!=document.getElementById("main-title").innerHTML){
    if ((pageURL != location.href) || (isButtonVisible() === false)) {
        title = document.getElementById("main-title").innerHTML;
        pageURL = location.href;
        wlButton = null;
        if (location.href.includes("details?id=")) {
            if ((ui >= 3) && (document.getElementsByClassName("ddlButton").length > 0)) {
                try {
                    removePreviousCwiz();
                } catch (err) {
                    console.log(err + "; I was probably just trying to remove buttons that weren't there...");
                }
            }
            addButtons();
        }
    } else {
        setTimeout(waitForRemovingButtons, 1000);
    }
}

function checkReload() {
    if ((pageURL != location.href) || (isButtonVisible() === false)) {
        waitForRemovingButtons();
    }
}

function isButtonVisible() {
    var allButtons = document.getElementsByClassName("ddlButton");
    //console.log("how many buttons: "+allButtons.length);
    if (allButtons.length > 0) {
        for (var i = 0; i < allButtons.length; i++) {
            if (allButtons[i].offsetParent != null) {
                //console.log(i+true);
                return true;
            }
        }
        //console.log(i+false);
        return false;
    } else {
        if (document.location.href.includes("play.google.com/store/apps/details")) {
            console.log("apppage//" + false);
            return false;
        }
        //console.log("notapppage//"+false);
        return true;
    }
}

function addButtons() {
    var price = -1;
    var installButton = null;
    var instWishButtons = [];
    if (ui <= 2) {
        installButton = document.getElementsByClassName("buy")[0];
        try {
            price = installButton.firstElementChild.firstElementChild.getElementsByTagName("META")[1].content;
            //alert("Price: "+price);
        } catch (err) {
            console.error("Price not found. Maybe the app is already installed?");
            price = 0;
        }
    } else {
        instWishButtons = getUglyUIButtons();
        if (ui == 3) {
            installButton = instWishButtons[0];
        } else {
            installButton = instWishButtons[1];     //if the app is installed, the whishlist button is absent, so the install button is the first and only
            if (typeof installButton === 'undefined') {
                installButton = instWishButtons[0];
            }
        }
        do {
            installButton = installButton.parentNode;
        } while (installButton.tagName != "C-WIZ");
        try {
            price = installButton.firstElementChild.firstElementChild.getElementsByTagName("META")[1].content;
            //alert("Price: "+price);
        } catch (err) {
            console.error("Price not found. Maybe the app is already installed?");
            price = 0;
        }
        //determina c-wiz dell'app per poterlo radere al suolo al cambio di pagina
        var currentNode;
        currentNode = installButton.parentNode;
        do {
            if (currentNode.tagName == "C-WIZ") {
                appCwiz = currentNode;
            }
            currentNode = currentNode.parentNode;
        } while (currentNode.tagName != "BODY");
    }
    if (price == 0) {
        var html;
        var buttonslist;
        var id = location.search.match(/id=(.*)/)[1].split("&", 1);
        var apkpureURL = 'https://m.apkpure.com/genericApp/' + id + '/download';
        var evoziURL = 'https://apps.evozi.com/apk-downloader/?id=' + id;
        var apkdlURL = 'http://apkfind.com/store/download?id=' + id;
        var apkmirrorURL = 'https://www.apkmirror.com/?post_type=app_release&searchtype=apk&s=' + id;
        var apkleecherURL = 'https://apkleecher.com/download/dl.php?dl=' + id;
        var apiniteURL = "https://apknite.com/" + id + "#original-apk"
        wlButton = document.createDocumentFragment();
        var wishListButton;
        if (ui <= 2) {
            wishListButton = document.getElementsByClassName("id-wishlist-display")[0];
        } else {
            if (typeof instWishButtons[1] !== 'undefined') {
                wishListButton = instWishButtons[0];
                do {
                    wishListButton = wishListButton.parentNode;
                } while (wishListButton.tagName != "C-WIZ");
            }
        }
        if (ui == 1) {
            buttonslist = document.getElementsByClassName("details-actions")[0];
            var class1 = "medium play-button download-apk-button apps ";
            var apiNiteButton = '<span><a style="background-color: antiquewhite" href="' + apiniteURL + '" class=' + class1 + '>nite</a></span>';
            var apkdlButton2 = '<span><a style="background-color: aliceblue" href="' + apkdlURL + '" class=' + class1 + '>DL2</a></span>';
            html = '<span id="apkdlbutton"><a style="background-color: #009688" class=' + class1 + '>DL</a></span><span id="apkpurebutton"><a style="background-color: #24cd77" class=' + class1 + '>Pure</a></span><span><a href="' + evoziURL + '" style="background-color: #286090" class=' + class1 + '>Evozi</a></span><span><a href="' + apkmirrorURL + '" style="background-color: #FF8B14" class=' + class1 + '>MiRr</a></span>' + apiNiteButton + apkdlButton2;
        } else if (ui == 2) {
            buttonslist = document.getElementsByClassName("details-actions-right")[0];
            var class2 = "large play-button download-apk-button apps ";
            var apiNiteButton = '<span><a style="background-color: antiquewhite" href="' + apiniteURL + '" class=' + class2 + '>nite</a></span>';
            var apkdlButton2 = '<span><a style="background-color: aliceblue" href="' + apkdlURL + '" class=' + class2 + '>DL2</a></span>';
            html = '<span id="apkdlbutton"><a style="background-color: #009688" class=' + class2 + '>DL</a></span><span id="apkpurebutton"><a style="background-color: #24cd77" class=' + class2 + '>Pure</a></span><span><a href="' + evoziURL + '" style="background-color: #286090" class=' + class2 + '>Evozi</a></span><span><a href="' + apkmirrorURL + '" style="background-color: #FF8B14" class=' + class2 + '>MiRr</a></span>' + apiNiteButton + apkdlButton2;
        } else {
            buttonslist = installButton.parentNode;
            var apiNiteButton = '<span><a style="background-color: antiquewhite" href="' + apiniteURL + '" class=' + 'ddlButton' + '>nite</a></span>';
            var apkdlButton2 = '<span><a style="background-color: aliceblue" href="' + apkdlURL + '" class=' + 'ddlButton' + '>DL2</a></span>';
            html = '<span id="apkdlbutton"><a style="background-color: #009688" class="ddlButton">DL</a></span><span id="apkpurebutton"><a style="background-color: #24cd77" class="ddlButton">Pure</a></span><span><a href="' + evoziURL + '" style="background-color: #286090" class="ddlButton">Evozi</a></span><span><a href="' + apkmirrorURL + '" style="background-color: #FF8B14" class="ddlButton">MiRr</a></span>' + apiNiteButton + apkdlButton2;
        }
        if (ui <= 2) {
            wlButton.appendChild(wishListButton);
        } else {
            if (typeof wishListButton !== 'undefined') {
                wlButton.appendChild(wishListButton.firstChild.firstChild);
            }
        }
        buttonslist.innerHTML = buttonslist.innerHTML + html;
        buttonslist.appendChild(wlButton);

        var ddlButton1 = document.getElementById("apkdlbutton");
        ddlButton1.onclick = function () {
            ddl(this, apkdlURL);
        };
        var ddlButton2 = document.getElementById("apkpurebutton");
        ddlButton2.onclick = function () {
            ddl(this, apkpureURL);
        };
    }
}

function openLink(link) {
    window.open(link, "_self");
}

function ddlFinalApk(link, ddlButton) {
    console.log(link);
    if (link != "") {
        GM.xmlHttpRequest({
            method: "GET",
            url: link,
            timeout: 3000,
            ontimeout: function (response) {
                if (response.finalUrl.includes("winudf.com")) {
                    window.open(response.finalUrl, "_self");
                    ddlButton.onclick = function () {
                        openLink(response.finalUrl);
                    };
                    ddlButton.firstChild.innerHTML = "Ready!";
                } else {
                    ddlButton.firstChild.innerHTML = "Retry";
                }
            },
            onload: function (response) {
                if (response.finalUrl.includes("winudf.com")) {
                    window.open(response.finalUrl, "_self");
                    ddlButton.onclick = function () {
                        openLink(response.finalUrl);
                    };
                    ddlButton.firstChild.innerHTML = "Ready!";
                } else {
                    ddlButton.firstChild.innerHTML = "Retry";
                }
            }
        });
    } else {
        ddlButton.firstChild.innerHTML = "Failed!";
        ddlButton.firstChild.style.backgroundColor = "#CCCCCC";
        ddlButton.onclick = null;
    }
}

function ddl(ddlButton, ddlURL) {
    ddlButton.firstChild.innerHTML = "Loading...";
    if (ddlURL.includes("apkfind")) {
        try {
            var apkDlRequest1 = GM.xmlHttpRequest({
                method: "GET",
                url: ddlURL,
                onload: function (response) {
                    if (response.finalUrl.includes("/captcha?")) {
                        ddlButton.firstChild.setAttribute("href", response.finalUrl);
                        ddlButton.firstChild.innerHTML = "CAPTCHA";
                        ddlButton.onclick = null;
                    } else if (response.finalUrl.includes("app/removed")) {
                        ddlButton.firstChild.style.backgroundColor = "#CCCCCC";
                        ddlButton.firstChild.innerHTML = "Removed!";
                        ddlButton.onclick = null;
                    } else {
                        try {
                            var linkIntermediary = document.createElement("html");
                            linkIntermediary.innerHTML = response.response;
                            var link = "http:" + linkIntermediary.getElementsByClassName("mdl-button")[0].getAttribute("href");
                            ddlButton.firstChild.innerHTML = "Ready!";
                            openLink(link);
                            ddlButton.onclick = function () {
                                openLink(link);
                            };

                        } catch (err) {
                            ddlButton.firstChild.innerHTML = "Failed!";
                            ddlButton.firstChild.style.backgroundColor = "#CCCCCC";
                            ddlButton.onclick = null;
                            console.log(err);
                        }
                    }
                }

            });
        } catch (err) {
            ddlButton.firstChild.innerHTML = "Failed!";
            ddlButton.firstChild.style.backgroundColor = "#CCCCCC";
            ddlButton.onclick = null;
            console.log(err);
        }
    } else if (ddlURL.includes("apkpure")) {
        try {
            GM.xmlHttpRequest({
                method: "GET",
                url: ddlURL,
                onload: function (response) {
                    var apklink = response.responseText.substr(response.responseText.indexOf('https://download.apkpure.com/b/'), response.responseText.length - 1);
                    apklink = apklink.substr(0, apklink.indexOf('"'));
                    console.log(ddlURL);
                    ddlButton.firstChild.innerHTML = "Wait...";
                    //ddlButton.onclick=function(){GM.openInTab(apklink,"open_in_background");};
                    ddlFinalApk(apklink, ddlButton);

                }
            });
        } catch (err) {
            ddlButton.firstChild.innerHTML = "Failed!";
            ddlButton.firstChild.style.backgroundColor = "#CCCCCC";
            ddlButton.onclick = null;
            console.log(err);
        }
    }
    /*
  /*try{
      document.body.removeChild(document.getElementById('ddlFrame'));
  }
  catch(err){
  }
  finally{
      var hiddenFrame=document.createElement("iframe");
      hiddenFrame.style.width="";
      hiddenFrame.style.height="0";
      hiddenFrame.setAttribute('id', 'ddlFrame');
      hiddenFrame.setAttribute('src', ddlURL);
      hiddenFrame.setAttribute('frameborder', "0");
      document.body.appendChild(hiddenFrame);
  }*/
}

function getUglyUIButtons() {
    var matchingElements = [];
    var allElements = document.getElementsByTagName('button');
    for (var i = 0, n = allElements.length; i < n; i++) {
        if (allElements[i].getAttribute("data-item-id") !== null) {
            if (allElements[i].getAttribute("data-item-id").startsWith("%.@.") === true) {
                matchingElements.push(allElements[i]);
            }
        }
    }
    //alert(matchingElements.length); shows how many buttons for installation and whishlist are in the page
    return matchingElements;
}

function checkUI() {
    //Different UIs:
    //1=Mobile HTML
    //2=Desktop HTML
    //3=Mobile UglyUI
    //4=Desktop UglyUI
    var check;
    try {
        if (document.getElementsByClassName("action-bar-menu-button").length > 0) {
            check = 1;
        } else {
            if (document.getElementsByClassName("details-info").length > 0) {
                check = 2;
            } else {
                check = 4;
                var metaTags = document.head.getElementsByTagName("meta");
                for (var i = 0; i < metaTags.length; i++) {
                    if (metaTags[i].getAttribute("name") == "mobile-web-app-capable") {
                        check = 3;
                    }
                }
            }
        }
    } catch (err) {
        console.error('The user interface of Google Play Store was not recognized by "Direct Download from Google Play" script. This might result in unexpected behaviour of the page. Please report the error to the author on Greasyfork. Error: ' + err);
    }
    return check;
}

function removePreviousCwiz() {
    appCwiz.parentNode.removeChild(appCwiz);
}