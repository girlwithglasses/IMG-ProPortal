/**
 * $Id: xml.js 29739 2014-01-07 19:11:08Z klchu $
 *
 * Javascript functions to load tree dynamically and create a http connection
 * to load inner html pages
 *
 * Ken
 */

/**
XML format

 <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
   <response>
   <label name="Alcaligenaceae">
       <id>Alcaligenaceae</id>
       <href> javascript:remoteSend(%22inner.cgi?xxxx%22)</href>
       <url>xml.cgi?section=TestTree%26xxxxx</url>
   </label>

   <label name="...">
       <id>... </id>
       <href>... </href>
       <url>... </url>
   </label>
   </response>
*/

/**
 * Is this a problem? because
 * its not synchronized and can be null if user clicks too fast
 *
 * So, far no, yahoo's api is doing event blocking on the tree
 */
var clickedNode;

/**
 *
 * see perl methods yuiPrintTreeFolderDynamic()
 */
var tree;

/**
 * Add children to parent nodes
 *
 * @param req http request object
 */
function xmlAddChildren(req) {
    
    // for tool tips
    //var contextElements = [];
    //var toolTipTitles = [];
   
    if(clickedNode != null) {
        xmlDocElement = req.responseXML.documentElement;
        labels  = xmlDocElement.getElementsByTagName('label');
   
        for(var i = 0; i < labels.length; i++) {
            mylabel = labels[i];
            // read xml file
            name = mylabel.getAttribute('name');
            myid = mylabel.getElementsByTagName('id')[0].firstChild.data;
            myurl = mylabel.getElementsByTagName('url')[0].firstChild.data;
            myhref = mylabel.getElementsByTagName('href')[0].firstChild.data;
            
            //mytooltip = mylabel.getElementsByTagName('tooltip');

            // href - is the right page url
            // url - is the '+' sign clicked url - to expand the tree
            
            // create child node
            var myobj = { label: name, 
                id: myid, 
                href:myhref, 
                url:myurl};
            var tmpNode = new YAHOO.widget.TextNode(myobj, clickedNode, false);
            
            //contextElements[contextElements.length] = tmpNode.getElId(); 
            
            // its null? - because the html has been reneder yet - ken
            //alert(tmpNode.getEl());
            
            //alert(mytooltip[0]);
            //if(mytooltip[0] != null) {
            //    toolTipTitles[toolTipTitles.length] =  mytooltip[0].firstChild.data;
            //} else {
            //    toolTipTitles[toolTipTitles.length] = "";
            //}
        }
        // tell parent node I'm done loading children
        // this reneders the html 
        clickedNode.loadComplete();
        clickedNode.refresh();
        
        //if(YAHOO.example.container == null) {
        //    YAHOO.namespace("example.container");
        //}
        //alert(document.getElementById(contextElements[0]));
        // now set the titles
        /*
        for(var i = 0; i < contextElements.length; i++) {
            document.getElementById(contextElements[i]).title = toolTipTitles[i];
        }
        if(YAHOO.example.container.tt != null) {
            YYAHOO.example.container.tt = new YAHOO.widget.Tooltip("tt2", { context:contextElements } );
        } else {
            YAHOO.example.container.tt = new YAHOO.widget.Tooltip("tt", { context:contextElements } ); 
        }
        */
        //YAHOO.example.container.tt1 = new YAHOO.widget.Tooltip("tt1", { context:"tree", 
        //text:"My text was set using the 'text' configuration property" });
        
        /*
            tooltip for tree really do not work
            since its by div id, so parent's tooltip are display with
            the children's tooltip too - ken
        */
    }
}

/**
 * Tree's event call method to load children nodes. Its called by yahoo's api
 * when clicking the tree's '+' sign.
 *
 * Note: any node with url tag equal to "mynull" is a leaf node.
 *
 * see tree.setDynamicLoad(loadDataForNode);
 */
function loadDataForNode(node, onCompleteCallback) { 
    // make parent node has a url defined
    if(node.data.url != null && node.data.url != "" 
        && node.data.url != "mynull") {
        clickedNode = node;
        var request = YAHOO.util.Connect.asyncRequest('GET', unescape(node.data.url), callback);
    } else {
        // leaf node
        clickedNode = null;
        // tell tree that this node has loaded its children
        onCompleteCallback();
    }
    // it must be here ? - no
    // onComfunction loadDataForNode(node, onCompleteCallback) { 

    // onCompleteCallback(); 
    // instead i use loadComplete() in the xmlAddChildren() method above
} 

/**
 * tree's http request successful
 *
 * @param o http request object
 */
var handleSuccess = function(o) {
    xmlAddChildren(o);
}

/**
 * tree's http request failure
 *
 * @param o http request object
 */
var handleFailure = function(o) {
    if(o.status == -1) {
        alert("Connection Timeout: " + o.statusText);
    } else if(o.status == 0) {
        alert("Server Error: " + o.statusText);
    } else {
        alert("Failure: " + o.statusText);
    }
    
    // if it does crash - unlock tree and tell parent
    // that the children were not loaded
    if(clickedNode != null) {
        clickedNode.loadComplete();
        clickedNode.collapse();
        // tell parent children not loaded
        clickedNode.dynamicLoadComplete = false;
        clickedNode.childrenRendered = false;
        clickedNode = null;
    }
}

/**
 * tree's http request callback object
 * time out set to 30 seconds
 */
var callback = {
    success: handleSuccess,
    failure: handleFailure,
    timeout: 30000
}

/**
 * load inner html pages
 * how i load the inner pages
 * note html's div id is "innerSection"
 *
 * @param args url for http request object. url will be unescaped.
 */
function remoteSend( args ) {
    var request = YAHOO.util.Connect.asyncRequest('GET', unescape(args), callback2);
       
    //alert(escape('"'));
       
    var e0 = document.getElementById( "innerSection" );
    e0.innerHTML = "<font color='red'><blink>Loading ...</blink></font>";
}

/**
 * inner html http request successful
 *
 * @param o http request object
 */
var handleSuccess2 = function(o) {
    var e = document.getElementById( 'innerSection' );
    e.innerHTML = o.responseText;
}

/**
 * inner html http request failure
 *
 * @param o http request object
 */
var handleFailure2 = function(o) {
    if(o.status == -1) {
        alert("Connection Timeout: " + o.statusText);
    } else if(o.status == 0) {
        alert("Server Error: " + o.statusText);
    } else {
        alert("Failure: " + o.statusText);
    }
}

/**
 * inner html pages http request callback object
 * time out set to 60000 msec
 */
var callback2 = {
    success: handleSuccess2,
    failure: handleFailure2,
    timeout: 60000
}



/*
 * JSON objects
 *
 * I using json since its easier than xml and its generic for yahoo tree's
 * data
 
 format:
 
 { "labels" : [
    {"label" : "l1", "id": "id1", "href": "h1", "url": "u1"},
    {"label" : "l2", "id": "id2", "href": "h2", "url": "u2"}
    ]
 }
 
 "lables" is the only thing required for the json parser
 "label" required for yahoo tree
 "id" required for yahoo tree
 "href" required for yahoo tree
  see yahoo docs for other reserved names
  anything else is extra for customizing
 
 */

function loadDataForNodeJSON (node, onCompleteCallback) { 
    // make parent node has a url defined
    if(node.data.url != null && node.data.url != "" 
        && node.data.url != "mynull") {
        clickedNode = node;
        
        //alert(node.data.url);
        
        var request = YAHOO.util.Connect.asyncRequest('GET', unescape(node.data.url), callback3);
    } else {
        // leaf node
        clickedNode = null;
        // tell tree that this node has loaded its children
        onCompleteCallback();
    }
} 

var handleSuccess3 = function(req) {
    if(clickedNode != null) {
        var jsontext = req.responseText;
        
        // this is not secure, can use a json parser - but I trust my own site
        var myObj = eval( '(' + jsontext + ')' );
        //var x = myObj.labels[0];
   
        for(var i = 0; i < myObj.labels.length; i++) {
            var mylabel = myObj.labels[i];
           
            // create child node

            if(mylabel.url == "mynull") {
                var tmpNode = new YAHOO.widget.TaskNode(mylabel, clickedNode, false, false);
                //var tmpNode = new YAHOO.widget.TextNode(mylabel, clickedNode, false);
            } else {
                var tmpNode = new YAHOO.widget.TextNode(mylabel, clickedNode, false);
            }
            
        }
        // tell parent node I'm done loading children
        // this reneders the html 
        clickedNode.loadComplete();
        clickedNode.refresh();
    }
}

var callback3 = {
    success: handleSuccess3,
    failure: handleFailure,
    timeout: 30000
}



/* ---------------------------------------------------------------------
 *
 * Taxonomy Tree save selection section
 *
 * ---------------------------------------------------------------------
 */

/**
 * Used to update genome selection cart count
 * it must be defined before callback variable
 *
 */
var handleSuccessCart = function(o) {
    var e = document.getElementById( 'innerSection' );
    e.innerHTML = o.responseText;
    
    //alert(o.responseText);
    
    var line = o.responseText;
    
    // value=
    var x = line.indexOf("mystart=")+8;
    var y = line.indexOf("=myend");
    var value = line.substring(x , y);
    
    //alert(value);
    
    e = document.getElementById( 'genomes' );
    var str = "<p> <span class='orgcount'>" + value + "</span><br/> genomes selected </p>";
    e.innerHTML = str;
} 

/**
 * save selection on inner html form save button
 */
function saveSelected(inner_cgi) {
    var f = document.mainForm;
    var msg = f.message.value;
    
    var taxons = '';

    for( var i = 0; i < f.length; i++ ) {
        var e = f.elements[ i ];
        if( e.type == "checkbox" &&  e.checked) {
            var t = e.value;
            if(taxons == '') {
                taxons = t;
            } else {
                taxons = taxons + '_' + t;
            }
        }
    }
    if(taxons != '') {
        remoteSend2(inner_cgi +"?section=TaxonomyTree&page=saveSelection&taxons=" + taxons);
    }
}

/**
 * save selection in taxonomy tree browser
 */
function treeSaveSelected(inner_cgi) {
    // now check what is selected in tree
    var topNodes = tree.getRoot().children;
    //alert("1 " + topNodes);
    //alert("2a " + topNodes[0].label);
    //alert("2b " + topNodes[0].data.url);
    //alert("2c " + topNodes[0].href);
    
    var list = "";
    list = findSelectedNodes(list, topNodes);
    //alert("list " + list);
    
    //alert("3: " + topNodes.length);
    if(list != "") {
        remoteSend2(inner_cgi +"?section=TaxonomyTree&page=saveSelection&taxons=" + list);
    }
}

/**
 * Finds which tree nodes have been selected - leaf nodes
 * 
 */
function findSelectedNodes(list, topNodes) {
    for(var i=0; i < topNodes.length; i++) {
        var child = topNodes[i].data.url;
        if(child == "mynull") {
            // leaf node
            //alert(topNodes[i].label + " checked? " + topNodes[i].checked);
            //alert(topNodes[i].label + " checkState? " + topNodes[i].checkState);
            if(topNodes[i].checked == true){
                    //alert("id: " + topNodes[i].data.id);
                
                if(list == "") {
                    list = topNodes[i].data.taxon_oid;
                } else {
                    list = list + "_" + topNodes[i].data.taxon_oid;
                }
            }               
        } else {
            list = findSelectedNodes(list, topNodes[i].children);
        }
    }
    return list;
}

/**
 * clears all selected tree nodes in taxonomy tree browser
 */
function clearSelectedNodes(topNodes) {
    for(var i=0; i < topNodes.length; i++) {
        var child = topNodes[i].data.url;
        if(child == "mynull") {
            // leaf node
            //alert(topNodes[i].label + " checked? " + topNodes[i].checked);
            //alert(topNodes[i].label + " checkState? " + topNodes[i].checkState);

            topNodes[i].uncheck();

            //alert(topNodes[i].label + " checked? " + topNodes[i].checked);
        } else {
            clearSelectedNodes(topNodes[i].children);
        }
    }
}

/**
 * used to update genome selection count cart
 */
var callbackCart = {
    success: handleSuccessCart,
    failure: handleFailure2,
    timeout: 30000
}

/**
 * used to update genome selection count cart
 */
function remoteSend2( args ) {
    var request = YAHOO.util.Connect.asyncRequest('GET', unescape(args), callbackCart);

    var e0 = document.getElementById( "innerSection" );
    e0.innerHTML = "<font color='red'><blink>Loading ...</blink><font>";
}
