var url = "";
var toCallbackTabContent = false;
var tabNames;
var tabIds;

function setUrl(aUrl) {
	url = aUrl;
	toCallbackTabContent = true;
}

function displayTabContent(id) {
	if (document.getElementById(id) == null) {
		return;
	}
	if (document.getElementById(id).innerHTML == "") {
		showDiv(id);
	}
}

function showDiv(id) {
    YAHOO.namespace("example.container");
    if (!YAHOO.example.container.wait) { 
    	initializeWaitPanel(); 
    } 
 
    var callback = {
    	success: handleSuccess,
        failure: function(req) { 
        	YAHOO.example.container.wait.hide();
        },
        argument: id
    };
    
    var name = getTabName(id);
    var idUrl = url + "&id=" + id + "&tabName=" + name;
    if (idUrl != null && idUrl != "") {
		//window.alert("showDiv idUrl=" + idUrl);
        YAHOO.example.container.wait.show(); 
        var request = YAHOO.util.Connect.asyncRequest('GET', idUrl, callback);
    } 
}

function handleSuccess(req) {
    try { 
    	id = req.argument;
		//window.alert("handleSuccess id=" + id);
        response = req.responseXML.documentElement;
        var html = response.getElementsByTagName('div')[0].firstChild.data;
		//window.alert("handleSuccess html=\n" + html);
        document.getElementById(id).innerHTML = html;
		//window.alert("handleSuccess html done\n");
        var evalElement = document.getElementById('evalMe');
        if (evalElement) {
			eval(evalElement.innerHTML);
        }
    } catch(e) {
    	//window.alert(e);
    }
    YAHOO.example.container.wait.hide();
}

function setTabNames(namesStr, idsStr) {
	tabNames = namesStr.split(',');
	tabIds = idsStr.split(',');
    //alert("tabNames: " + tabNames);
    //alert("tabIds: " + tabIds);
}

function getTabName(id) {
	var name = "";
    if (tabNames != null && tabIds != null) {
		for (var i = 0; i < tabIds.length; i++) {
			if (tabIds[i] == id) {
				name = tabNames[i];
				break;
			}
		}
    }
	return name;
}

function getIdx(state) {
    // "state" can be "tab0", "tab1" or "tab2".
	var idx = state.substr(3);
	if (tabIds != null) {
		for (var i = 0; i < tabIds.length; i++) {
			if (tabIds[i] == state) {
				idx = i;
				break;
			}
		}
	}
    //alert("getIdx: " + state + " " + idx);
	return idx;
}

var splitSymbol = " :: ";
var bookmarkedTabViewState = YAHOO.util.History.getBookmarkedState("tabview");
var initialTabViewState = bookmarkedTabViewState || "tab0";

var tabView;

YAHOO.util.History.register("tabview", initialTabViewState, function (state) {
    //window.alert("inside registered function");
    loadState(state);
});

//load and display the specified state
function loadState(state) {
    //window.alert("loadState: " + state + "\ntabNames: " + tabNames + "\ntabIds: " + tabIds);
    var idx = getIdx(state);
    tabView.set("activeIndex", idx);
    if (toCallbackTabContent) {
        displayTabContent(state);
    }

    if (tabNames != null && idx < tabNames.length) {
        var orgTitle = document.title;
        var index = orgTitle.indexOf(splitSymbol);
        if (index >=0 ) {
            orgTitle = orgTitle.substring(0, index);
        }
        document.title = orgTitle + splitSymbol + tabNames[idx];
    }
}

function handleTabViewActiveTabChange (e) {
    var newState, currentState;
 
    newState = "tab" + this.getTabIndex(e.newValue);
	if (tabIds != null) {
		newState = tabIds[this.getTabIndex(e.newValue)];
    }
	//window.alert("handleTabViewActiveTabChange newState: " + newState);
 
    try {
    	currentState = YAHOO.util.History.getCurrentState("tabview");
	    // The following test is crucial. Otherwise, we end up circling forever.
	    // Indeed, YAHOO.util.History.navigate will call the module onStateChange
	    // callback, which will call tabView.set, which will call this handler
	    // and it keeps going from here...
	    if (newState != currentState) {
	        YAHOO.util.History.navigate("tabview", newState);
	    }
    } catch (e) {
    	tabView.set("activeIndex", getIdx(newState));
    }
}

function initTabView () {
    // Instantiate the TabView control...
    tabView = new YAHOO.widget.TabView("tabviewFrame");
    tabView.addListener("activeTabChange", handleTabViewActiveTabChange);
}

// Use the Browser History Manager onReady method to instantiate the TabView widget.
YAHOO.util.History.onReady(function () {
	var currentState;
 
    initTabView();
 
    // This is the tricky part... The onLoad event is fired when the user
    // comes back to the page using the back button. In this case, the
    // actual tab that needs to be selected corresponds to the last tab
    // selected before leaving the page, and not the initially selected tab.
    // This can be retrieved using getCurrentState:
    currentState = YAHOO.util.History.getCurrentState("tabview");
    //window.alert("OnReady currentState: " + currentState);
    loadState(currentState);
});
 
// Initialize the browser history management library.
try {
    YAHOO.util.History.initialize("tabviewFrame-history-field", "tabviewFrame-history-iframe");
} catch (e) {
    // The only exception that gets thrown here is when the browser is
    // not supported (Opera, or not A-grade) Degrade gracefully.
    initTabView();
}

function gotoTab(name) {
    var state = "tab0";
    if (tabNames != null && tabIds != null) {
        for (var i = 0; i < tabNames.length; i++) {
            if (tabNames[i] == name) {
                state = tabIds[i];
                break;
            }
        }
    }
    loadState(state);
}
