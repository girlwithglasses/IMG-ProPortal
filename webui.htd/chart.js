function showImage(imageUrl) {
    YAHOO.namespace("example.container");
    if (!YAHOO.example.container.wait) {
        initializeWaitPanel();	
    }

    var callback = { 
        success: handleSuccess, 
        failure: function(req) { 
            YAHOO.example.container.wait.hide(); 
        } 
    };
 
    if (imageUrl != null && imageUrl != "") {
        YAHOO.example.container.wait.show(); 
        var request = YAHOO.util.Connect.asyncRequest
          ('GET', imageUrl, callback);
    } 
}

function handleSuccess(req) {
    var bodyText = "";
    var headerText = "";

    try {
        response = req.responseXML.documentElement;
        var header = response.getElementsByTagName
            ("header")[0].childNodes[0].nodeValue;
        headerText = header;

        var url = response.getElementsByTagName
            ("url")[0].childNodes[0].nodeValue;
        bodyText = url;

	var imagemap = response.getElementsByTagName
            ("imagemap")[0].childNodes[0].nodeValue;
        var script = response.getElementsByTagName 
            ("script")[0].childNodes[0].nodeValue; 
        var maptext = response.getElementsByTagName
            ("maptext")[0].firstChild.data;

        bodyText = "<script src="+script+"></script>\n "+maptext+
                   "<img src="+url+" alt="+url+
                   " border=0 USEMAP="+imagemap+">";

    } catch(e) {
    }
                        
    YAHOO.example.container.panel1.setHeader(headerText);
    YAHOO.example.container.panel1.setBody(bodyText);
    YAHOO.example.container.panel1.render("container");

    if (bodyText == "") {	
        YAHOO.example.container.panel1.hide();
    } else {
        YAHOO.example.container.panel1.show();
    }

    YAHOO.example.container.wait.hide();
} 

function initPanel(elementId) {
    if (!YAHOO.example.container.panel1) {
        YAHOO.example.container.panel1 = new YAHOO.widget.Panel
            ("panel1",
              {
                // width:"480px", 
                visible:false,
                underlay:"none",
                zindex:"10",
                // constraintoviewport:true,
                context:['anchor','tl','br']
              });
        YAHOO.example.container.panel1.render(elementId);
    }
}

function initializeWaitPanel() {
    if (!YAHOO.example.container.wait) {
        // display a temporary panel while waiting for external content to load
        YAHOO.example.container.wait = new YAHOO.widget.Panel 
            ("wait", 
              { width: "240px",
                fixedcenter: true,
                close: false,
                draggable: false, 
                zindex:"12", 
                modal: true, 
                visible: false 
              }); 
 
        YAHOO.example.container.wait.setBody 
          ("<b>Loading, please wait...</b>" + 
           '<img src="http://us.i1.yimg.com/us.yimg.com/i/us/per/gr/gp/rel_interstitial_loading.gif" />'); 
        YAHOO.example.container.wait.render(document.body);
 
        var cancelLink = document.createElement('a'); 
        YAHOO.util.Dom.setStyle(cancelLink, 'cursor', 'pointer');
        cancelLink.appendChild(document.createTextNode('Cancel'));
        YAHOO.util.Event.on(cancelLink, 'click',
                            YAHOO.example.container.wait.hide,
                            YAHOO.example.container.wait, true);
        YAHOO.example.container.wait.appendToBody(document.createElement('br'));
        YAHOO.example.container.wait.appendToBody(cancelLink);
        YAHOO.util.Dom.setStyle
                (YAHOO.example.container.wait.body, 'text-align', 'center');
        YAHOO.util.Dom.addClass(document.body, 'yui-skin-sam'); 
    } 
}
