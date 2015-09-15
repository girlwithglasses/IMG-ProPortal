function showDialog(dataUrl, target) {
    YAHOO.namespace("example.container");
    if (!YAHOO.example.container.wait) {
        initializeWaitPanel();	
    }

    var callback = { 
        success: handleSuccess, 
        argument: [target],
        failure: function(req) { 
            YAHOO.example.container.wait.hide(); 
        } 
    };

    if (dataUrl != null && dataUrl != "") {
        YAHOO.example.container.wait.show(); 
        var request = YAHOO.util.Connect.asyncRequest
          ('GET', dataUrl, callback);
    } 
}

function handleSuccess(req) {
    var bodyText = "";
    var headerText = "";

    try {
        response = req.responseXML.documentElement;
        var header = response.getElementsByTagName("header");
	if (header != null && header[0] != null) {
            headerText = header[0].childNodes[0].nodeValue;
        }

        var text = response.getElementsByTagName("text");
	if (text != null) {
            for (var i = 0; i < text.length; i++) {
                if (text[i] != null) {
		    if (i > 0) {
			bodyText += "<br/>";
		    }
		    bodyText += text[i].firstChild.data;
		}
	    }
	} else {
	    bodyText = "";
	}

	var imgText = "";
        var script = response.getElementsByTagName("script");
	if (script != null && script[0] != null) {
            script = script[0].childNodes[0].nodeValue; 
            //imgText += "<script src="+script+"></script>\n ";
            bodyText += "<br/><script src="+script+"></script>\n ";
	}
        var maptext = response.getElementsByTagName("maptext");
	if (maptext != null && maptext[0] != null) {
            maptext = maptext[0].firstChild.data;
            imgText += maptext;
	}

        var url = response.getElementsByTagName("url");	
        if (url != null && url[0] != null) {
       	    url = url[0].childNodes[0].nodeValue;
            imgText +=  "<img src="+url+" alt="+url+" border=0 ";
	    var imagemap = response.getElementsByTagName("imagemap");
	    if (imagemap != null && imagemap[0] != null) {
                imagemap = imagemap[0].childNodes[0].nodeValue;
                imgText += "USEMAP="+imagemap;
	    }
            imgText += ">";
	}

	if (imgText.length > 0) {
	    bodyText = bodyText+"<br/>"+imgText;
	}

	var target = req.argument[0];
	if (target != null) {
	    // add hidden var for select box id:
	    bodyText += "<input type='hidden' name='mytarget' id='mytarget' value='"+target+"' />";
	}

    } catch(e) {
	alert("EXCEPTION: "+e);
    }
                        
    YAHOO.example.container.dialog1.setHeader(headerText);
    YAHOO.example.container.dialog1.setBody("<div id='dialog1' style='height:350px; position:relative; overflow-y: auto;'>"+bodyText+"</div>");
    YAHOO.example.container.dialog1.render("container");

    if (bodyText == "") {	
        YAHOO.example.container.dialog1.hide();
    } else {
        YAHOO.example.container.dialog1.show();
    }

    YAHOO.example.container.wait.hide();
} 

function initDialog(elementId) {
    if (!YAHOO.example.container.dialog1) {
        YAHOO.example.container.dialog1 = new YAHOO.widget.Dialog
            ("dialog1",
	     {
		 //width:"480px",
		 //height: "180px",
		 //autofillheight: false,
		 visible:false,
                 draggable:true,
		 underlay:"none",
		 zindex:"10",
		 constraintoviewport:true,
		 //context:['anchor','tl','br']
		 buttons:[{text:"Submit", handler:handleSubmit, isDefault:true}, 
	                  {text:"Cancel", handler:handleCancel}]
	     });
        YAHOO.example.container.dialog1.render(elementId);
        YAHOO.example.container.dialog1.validate = function() {
	    return true;
	}
        YAHOO.example.container.dialog1.center();
    }
}

var handleSubmit = function() {
    YAHOO.example.container.dialog1.doSubmit();

    var startElement = document.getElementById("dialog1");
    var els = startElement.getElementsByTagName('input');
    var select;

    var target = document.getElementById('mytarget');
    if (target != null && target !== undefined) {
	var val = target.value;
	select = document.getElementById(val);
    }

    if (select == null || select === undefined) {
	alert("ERROR: cannot find html element - select box!");
	return;
    }

    for (var i=0; i < els.length; i++) {
	var e = els[i];
	var name = e.name;
	var val = e.value;

	if (e.type == "checkbox" && e.checked == true) {
	    var opt = document.createElement("option");
	    opt.value = "wfs:" + val;
	    opt.innerHTML = val;
	    select.appendChild(opt);
	} 
    }

    YAHOO.example.container.dialog1.hide();
    //this.submit(); 
};

var handleCancel = function() { 
    this.cancel(); 
};

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
