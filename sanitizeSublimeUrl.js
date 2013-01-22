var fs = require('fs');
var url = fs.readFileSync('./sublimeUrl.txt').toString().replace(/ /g, '%20');
console.log(url);

