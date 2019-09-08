var system = require('system');
var page = require('webpage').create();
var QT_QPA_PLATFORM = ''
export QT_QPA_PLATFORM

page.open(system.args[1], function()
{
    console.log(page.content);
    phantom.exit();
});
