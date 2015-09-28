/* ================================================================================
 * FireSSH plugin settings
 * /Users/hardikar/Library/Application Support/Firefox/Profiles/tbcgka20.default/extensions/firessh@nightlight.ws
 * ================================================================================
 */

(function() {

// Command to start ssh in the current tab/split
commands.addUserCommand(
    ['ssh', 'term[inal]'],
    "Open a ssh terminal to a host in the current tab/split",
    function(args, bang, count) {
        liberator.execute("open chrome://firessh/content/firessh.xul#account="+args)
    },
    { /* extras */
        completer: function (context) completion.url(context, "l"),
        argCount: "1",
        bang: false,
        count: false,
        literal: false,
    },
    true /* replace */
);

mappings.addUserMap([modes.NORMAL],
        ['<C-S>'],
        '',
        function () {
            commandline.open(':', 'ssh ', modes.EX);
        }
    );

autocommands.add("LocationChange", ".*", 
    function(){
        modes.passAllKeys = /chrome:\/\/firessh\/content\/firessh.xul/.test(buffer.URL);
    });

})();

