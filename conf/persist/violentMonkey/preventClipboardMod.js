// ==UserScript==
// @name        preventClipboardMod
// @namespace   Violentmonkey Scripts
// @match       https://xuangubao.cn/*
// @grant       none
// @version     1.6
// @author      -
// @description 6/20/2021, 9:44:14 PM
// ==/UserScript==


/*
    document.onbeforecopy = function (e) {
        e.clipboardData.setData('text/plain',window.getSelection());
    };

    document.oncopy=function (e) {
        e.preventDefault();
        return false;
    }
*/

    Selection.prototype.selectAllChildren=function(){}

