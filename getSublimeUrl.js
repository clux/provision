var Zombie = require('zombie');

(new Zombie()).visit("http://www.sublimetext.com/2" , function (e, browser, status) {
  var code = "document.querySelector('#dl_linux_64 a').href.replace(/ /g, '%20');";
  console.log(browser.evaluate(code));
});
