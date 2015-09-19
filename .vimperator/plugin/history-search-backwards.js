var PLUGIN_INFO = xml`
<VimperatorPlugin>
<name>{NAME}</name>
<description>History search backward like UNIX shell.</description>
<description lang="ja">UNIX シェルのような、C-rで履歴検索を行うプラグイン</description>
<minVersion>2.0</minVersion>
<maxVersion>2.0</maxVersion>
<updateURL>https://github.com/vimpr/vimperator-plugins/raw/master/history-search-backward.js</updateURL>
<author mail="hotchpotch@gmail.com" homepage="http://d.hatena.ne.jp/secondlife/">Yuichi Tateno</author>
<license>MIT</license>
<version>0.2</version>
<detail><![CDATA[
UNIX シェルのように、コマンドラインで C-r でヒストリ検索を行うプラグインです。map の変更設定は以下のように行えます。
>||
liberator.globalVariables.history_search_backward_map = ['<C-r>'];
||<

]]></detail>
</VimperatorPlugin>`;

(function() {
    let history_search_backwards = function() {
         let command = '';
         let completionsList = [[key, i] for ([i, key] in storage['history-command'])].
                                filter(function([key, i]) key).reverse().map(function (e) [e[0].value, e[1]]);
         commandline.input('bck-i-search: ', function(str) {
            try {
                liberator.execute(str);
            } catch(e) {};
            return;
         }, {
            completer: function(context) {
                context.anchored = false;
                context.title = ['CommandLine History', 'INDEX'];
                context.completions = completionsList;
            },
            default: command,
         });
    };

    mappings.addUserMap([modes.COMMAND_LINE, modes.NORMAL], 
        ['<C-r>'], 
        'History incremental search backward.', 
        history_search_backwards
    );
})();





