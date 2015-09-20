/*
 *  Vimperator commands and mappings for Tile Tabs Firefox plugins
 *
 *  TODO :
 *  Also C-W C[HJKL]
 *
 *  Read about VIM moving windows - and implement some of them.. 
 *
 * @author hardikar
 */

(function() {

// If tileTabs isn't defined/loaded, ignore this plugin
if (typeof tileTabs != 'object') {
    // Don't load this plugin
    return;
}

function SplitAndOpen(args){
    liberator.execute("emenu Tile.Tile New Tab.Below");
    liberator.execute("open " + args);
}

function VerticalSplitAndOpen(args){
    liberator.execute("emenu Tile.Tile New Tab.Right");
    liberator.execute("open " + args);
}


function SyncScrolling(args){
    liberator.execute("syncscroll emenu Tile.Sync Scroll");
}

function getAllChildPanelsInLayout(layout) {
    var allChildPanels = [];

    if (! layout) return allChildPanels;

    var stack = []
    stack.push(layout.rootTile); 
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


// Cycle through tiles in the same tab
function CycleTiles(){
    // Get all child panels by traversing the tree for the current layout
    var selectedLayout = tileTabs.lastActiveLayout;
    var allChildPanels = getAllChildPanelsInLayout(selectedLayout);

    // Get the index of the current tab among the child panels
    var selectedTab = tileTabs.lastSelectedTab;
    var currentTileIndex = allChildPanels.map(function (e) e.panelID)
            .indexOf(selectedTab.linkedPanel);

    // Compute the panelID of the next tab
    var nextTileIndex = (currentTileIndex + 1) % allChildPanels.length;
    var nextPanelId = allChildPanels[nextTileIndex].panelID;

    // Get panelIDs of all open tabs mapped to their index
    var openTabPanelIdsToIndexMap = {};
    Array.prototype.slice.call(config.browser.tabs)
        .map(function (cur, i) openTabPanelIdsToIndexMap[cur.linkedPanel] = i);


    // Find out the next buffer's index we want to change to
    var nextIndex = openTabPanelIdsToIndexMap[nextPanelId];

    if (nextIndex) {
        liberator.execute("buffer! " + (nextIndex+1));
    }
    // Do nothing if we failed
}


// Select with direction in mind
// direction in ['up', 'down', 'left', 'right']
function SelectTileVertical(direction){
    // Get all child panels by traversing the tree for the current layout
    var selectedLayout = tileTabs.lastActiveLayout;
    var selectedTab = tileTabs.lastSelectedTab;

    var selectedTile = tileTabs.findTileByPanel(selectedLayout.rootTile, selectedTab.linkedPanel);

    alert(selectedTile);
}


// Select with direction in mind
// direction in ['up', 'down', 'left', 'right']
function SelectTile(direction){
    alert(direction == 'down');
    if (direction == 'up' || direction == 'down')
        SelectTileVertical(direction);
}


// Horizontal split command
commands.addUserCommand(
    ['sp[lit]', 'sp'],
    "Open in a horizontal split window",
    function(args, bang, count) {
        SplitAndOpen(args);
    },
    { /* extras */
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
        VerticalSplitAndOpen(args);
    },
    { /* extras */
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

//command! cycletiles js CycleTiles()

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
//nnoremap <C-W><C-W> :cycletiles<CR>
})();
