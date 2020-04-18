// ==UserScript==
// @name        cninfoX
// @namespace   Violentmonkey Scripts
// @match       http://www.cninfo.com.cn/*
// @grant       none
// @version     1.5
// @author      -
// @description 6/20/2021, 4:22:40 PM
// ==/UserScript==


window.bovSearchStock=function(code){
  console.log('code:' + code);
  var codeInput=document.getElementsByClassName('el-input__inner')[2];
  var clearBtn=document.getElementsByClassName('el-button el-button--text')[2];
  clearBtn && clearBtn.click();
  codeInput.value=code;
  codeInput.dispatchEvent(new Event('input'));
  setTimeout(function(){
    document.getElementsByClassName('el-button query-btn')[0].click();    
  },500)
}
