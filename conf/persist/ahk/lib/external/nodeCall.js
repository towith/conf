const readline = require('readline');
const fs = require('fs');

const funs = {};

var [proc, script, funcName, ...params] = process.argv;
console.log(funcName);
funs[funcName](params);
const sleep = (waitTimeInMs) => new Promise(resolve => setTimeout(resolve, waitTimeInMs));
sleep(2000);


