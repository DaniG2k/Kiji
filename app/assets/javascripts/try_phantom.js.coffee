page = require('webpage').create();
page.open('http://github.com/', function () {
    page.render('github.png');
    console.log("Status: #{status}");
    phantom.exit();
});
