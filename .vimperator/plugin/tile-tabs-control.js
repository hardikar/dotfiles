/*
 *  Vimperator commands and mappings for Tile Tabs Firefox plugins
 *
 *  Mappings :
 *  <C-W><C-W>      cycle through windows in the same tab
 *  <C-W>j          select pane below
 *  <C-W>k          select pane above
 *  <C-W>h          select pane left
 *  <C-W>l          select pane right
 *  <C-W>z          Zoom out selected pane
 *
 *  Added commands vsplit, split, syncscroll
 *
 * @author hardikar
 */

(function() {

// If tileTabs isn't defined/loaded, ignore this plugin
if (typeof tileTabs != 'object') {
    // Don't load this plugin
    return;
}

function SplitAndOpenBelow(args){
    liberator.execute("emenu Tile.Tile New Tab.Below");
    liberator.execute("open " + args);
}
function SplitAndOpenAbove(args){
    liberator.execute("emenu Tile.Tile New Tab.Above");
    liberator.execute("open " + args);
}

function VerticalSplitAndOpenRight(args){
    liberator.execute("emenu Tile.Tile New Tab.Right");
    liberator.execute("open " + args);
}

function VerticalSplitAndOpenLeft(args){
    liberator.execute("emenu Tile.Tile New Tab.Left");
    liberator.execute("open " + args);
}

function SyncScrolling(args){
    liberator.execute("emenu Tile.Sync Scroll");
}

function getAllChildPanelsFromTile(rootTile) {
    var allChildPanels = [];

    var stack = [];
    stack.push(rootTile);
    while(stack.length >= 1) {
        var tile = stack.pop();
        for(var i = 0; i < tile.childTiles.length; i+=1){
            stack.push(tile.childTiles[i]);
        }
        if (tile.type === "panel") {
            allChildPanels.push(tile);
        }
    }
    return allChildPanels;
}

function SelectBufferByPanelId(panelId) {

    // Get panelIDs of all open tabs mapped to their index
    var openTabPanelIdsToIndexMap = {};
    Array.prototype.slice.call(config.browser.tabs)
        .map(function (cur, i) openTabPanelIdsToIndexMap[cur.linkedPanel] = i);


    // Find out the next buffer's index we want to change to
    var index = openTabPanelIdsToIndexMap[panelId];

    if (index) {
        liberator.execute("buffer! " + (index+1));
    }
}

function mod(n, m) {
    return ((n % m) + m) % m;

}


// Cycle through tiles in the same tab
function CycleTiles(){
    // Get all child panels by traversing the tree for the current layout
    var selectedLayout = tileTabs.lastActiveLayout;
    if (! layout)
        return;

    var allChildPanels = getAllChildPanelsFromTile(selectedLayout.rootTile);

    // Get the index of the current tab among the child panels
    var selectedTab = tileTabs.lastSelectedTab;
    var currentTileIndex = allChildPanels.map(function (e) e.panelID)
            .indexOf(selectedTab.linkedPanel);

    // Compute the panelID of the next tab
    var nextTileIndex = mod(currentTileIndex - 1, allChildPanels.length);
    alert(nextTileIndex);
    var nextPanelId = allChildPanels[nextTileIndex].panelID;

    SelectBufferByPanelId(nextPanelId);
}


// Internal method that does the tree traversal
// watchType in ['hsplit', 'vsplit']
// d in [-1, 1]
function SelectTileInternal(watchType, d){
    // Setup current layout, tab, tile
    var selectedLayout = tileTabs.lastActiveLayout;
    var selectedTab = tileTabs.lastSelectedTab;
    var selectedTile = tileTabs.findTileByPanel(selectedLayout.rootTile, selectedTab.linkedPanel);

    // Traverse back up the tree to find the "correct" kind of parent.
    var tile = selectedTile;
    while (tile) {
        var parentTile = tile.parentTile;
        if ( parentTile.type == watchType ){
            //Bingo
            break;
        } else {
            tile = parentTile;
        }
    }
    if (!tile || !parentTile){
        // We failed, return quietly
        return;
    } else {
        var currentTileIndex = parentTile.childTiles.indexOf(tile);

        var nextTileIndex = mod(currentTileIndex + d, parentTile.childTiles.length);
        var nextTile = parentTile.childTiles[nextTileIndex];

        var nextPanelId = "";
        if (nextTile.type != 'panel') {
            // oh well we must list all out child panels then
            var allChildPanels = getAllChildPanelsFromTile(nextTile);
            // ff we find any, just grab that panelID
            nextPanelId = allChildPanels.length >= 1 ? allChildPanels[0].panelID : "";
        }else {
            // our sibling is a panel
            nextPanelId = nextTile.panelID;
        }

        SelectBufferByPanelId(nextPanelId);
    }
}


// Select with direction in mind
// direction in ['up', 'down', 'left', 'right']
function SelectTile(direction){
    var d = (direction == 'down' || direction == 'right') ? 1 : -1;
    var watchType = (direction == 'up' || direction == 'down') ? 'hsplit': 'vsplit';
    SelectTileInternal(watchType, d);
}


// Horizontal split command
commands.addUserCommand(
    ['sp[lit]', 'sp'],
    "Open in a horizontal split window",
    function(args, bang, count) {
        if ("-above" in args)
            SplitAndOpenAbove(args);
        else
            SplitAndOpenBelow(args);
    },
    { /* extras */
        options: [
            [["-above"], commands.OPTION_NOARG],
            [["-below"], commands.OPTION_NOARG]
        ],
        completer: function (context) completion.url(context, "l"),
        argCount: "*",
        bang: false,
        count: false,
        literal: false,
    },
    true /* replace */
);
   
// Vertical split command
commands.addUserCommand(
    ['vs[plit]', 'vsp', 'vs'],
    "Open in a vertical split window",
    function(args, bang, count) {
        if ("-left" in args)
            VerticalSplitAndOpenLeft(args);
        else
            VerticalSplitAndOpenRight(args);
    },
    { /* extras */
        options: [
            [["-left"], commands.OPTION_NOARG],
            [["-right"], commands.OPTION_NOARG]
        ],
        completer: function (context) completion.url(context, "l"),
        argCount: "*",
        bang: false,
        count: false,
        literal: false,
    },
    true /* replace */
);


// Sync Scrolling
commands.addUserCommand(
    ['sync[scroll]'],
    "Sync scrolling between open panes",
    function(args, bang, count) {
        SyncScrolling();
    },
    { /* extras */
        argCount: "0",
        bang: false,
        count: false,
        literal: false,
    },
    true /* replace */
);


mappings.addUserMap([modes.NORMAL],
        ['<C-W><C-W>'],
        '',
        function () {
            CycleTiles();
        }
    );
mappings.addUserMap([modes.NORMAL],
        ['<C-W><C-V>'],
        '',
        function () {
            VerticalSplitAndOpen("");
        }
    );
mappings.addUserMap([modes.NORMAL],
        ['<C-W><C-S>'],
        '',
        function () {
            SplitAndOpen("");
        }
    );

mappings.addUserMap([modes.NORMAL],
        ['<C-W>j'],
        '',
        function () {
            SelectTile("down");
        },
        { /* extras */
            noremap: true
        }
    );
mappings.addUserMap([modes.NORMAL],
        ['<C-W>k'],
        '',
        function () {
            SelectTile("up");
        },
        { /* extras */
            noremap: true
        }
    );
mappings.addUserMap([modes.NORMAL],
        ['<C-W>h'],
        '',
        function () {
            SelectTile("left");
        },
        { /* extras */
            noremap: true
        }
    );
mappings.addUserMap([modes.NORMAL],
        ['<C-W>l'],
        '',
        function () {
            SelectTile("right");
        },
        { /* extras */
            noremap: true
        }
    );


mappings.addUserMap([modes.NORMAL],
        ['<C-W>z'],
        '',
        function () {
            liberator.execute("emenu Tile.Expand Tile");
        },
        { /* extras */
            noremap: true
        }
    );

})();
