/* 
 * $Id: Workspace.js 34102 2015-08-24 18:41:41Z klchu $
 */

/**
 * delete confirmation
 * @param filename
 * @param url
 */
function show_confirm(filename, url) {
    var r = confirm("Are you sure you want to delete " + filename + "?");
    if (r == true) {
        window.open( url, '_self' );
    }
}

function confirmDelete(setType) {
	var r = checkSets(setType)
    if (r == true) {
        r = confirm("Are you sure you want to delete all the selected file(s)?");
    }
	return r
}

var popup_box;
var waitPanel = new YAHOO.widget.Panel("modalwait",
	    { width: "250px",
	      fixedcenter: true,
	      close: false,
	      draggable: false,
	      zindex: 4,
	      modal: true,
	      visible: false
	    });

waitPanel.setBody("");
waitPanel.render(document.body);

function displayWait (bOn, sMsg) {
   if (bOn) {
	waitPanel.setHeader(sMsg + " ...");
	waitPanel.show();
   } else {
	waitPanel.hide();
   }
}

function checkSetsAndFileName(textFieldName, btnGrpName, setType) {
	var r = true;
    var elRadioBtns = document.getElementsByName(btnGrpName);
    if (elRadioBtns[0].checked ) {
    	r = isFilled(textFieldName, "Please enter a file name.");
    }
	if (r == true) {
    	r = checkSets(setType);
    }
	return r;
}

function checkSetsIncludingShareAndFileName(textFieldName, btnGrpName, setType) {
	var r = true;
    var elRadioBtns = document.getElementsByName(btnGrpName);
    if (elRadioBtns[0].checked ) {
    	r = isFilled(textFieldName, "Please enter a file name.");
    }
	if (r == true) {
    	r = checkSetsIncludingShare(setType);
    }
	return r;
}

function checkTwoSetsAndFileName(textFieldName, btnGrpName, setType) {
	var r = true;
    var elRadioBtns = document.getElementsByName(btnGrpName);
    if (elRadioBtns[0].checked ) {
    	r = isFilled(textFieldName, "Please enter a file name.");
    }
	if (r == true) {
    	r = checkTwoSets(setType);
    }
	return r;
}

function checkTwoSetsIncludingShareAndFileName(textFieldName, btnGrpName, setType) {
	var r = true;
    var elRadioBtns = document.getElementsByName(btnGrpName);
    if (elRadioBtns[0].checked ) {
    	r = isFilled(textFieldName, "Please enter a file name.");
    }
	if (r == true) {
    	r = checkTwoSetsIncludingShare(setType);
    }
	return r;
}

function checkSetsAndFilled(textFieldName, setType) {
	var r = isFilled(textFieldName, "Please enter a file name.");
    if (r == true) {
    	r = checkSets(setType);
    }
	return r;
}

function checkSetsIncludingShareAndFilled(textFieldName, setType) {
	var r = isFilled(textFieldName, "Please enter a file name.");
    if (r == true) {
    	r = checkSetsIncludingShare(setType);
    }
	return r;
}

function checkTwoSetsAndFilled(textFieldName, setType) {
	var r = isFilled(textFieldName, "Please enter a file name.");
    if (r == true) {
    	r = checkTwoSets(setType);
    }
	return r;
}

function checkTwoSetsIncludingShareAndFilled(textFieldName, setType) {
	var r = isFilled(textFieldName, "Please enter a file name.");
    if (r == true) {
    	r = checkTwoSetsIncludingShare(setType);
    }
	return r;
}

function checkSelectedAndFilled(textFieldName, selectFieldName) {
	var r = isFilled(textFieldName, "Please enter a file name.");
	if (r == true) {
		r = isChecked(selectFieldName, "Please make one or more selections.");
	}
    return r;
}

function checkSelectedAndFileName(textFieldName, btnGrpName, selectFieldName) {
	var r = true;
    var elRadioBtns = document.getElementsByName(btnGrpName);
    if (elRadioBtns[0].checked ) {
    	r = isFilled(textFieldName, "Please enter a file name.");
    }
	if (r == true) {
		r = isChecked(selectFieldName, "Please make one or more selections.");
	}
    return r;
}

function checkFileName(textFileName, btnGrpName) {
	//alert("into checkFileName");
    var errMsg = "Please enter a file name.";
    var elRadioBtns = document.getElementsByName(btnGrpName);
    if (elRadioBtns[0].checked )
    	return isFilled(textFileName, errMsg);
    return true;
}

function checkFilled(textFieldName) {
	return isFilled(textFieldName, "Please enter a file name.");
}

function isFilled(textFieldName, errMsg) {
    var filledText = document.getElementsByName(textFieldName)[0].value;
    if (filledText.length <= 0 && errMsg) {
		var elFilledText = document.getElementsByName(textFieldName)[0];
		alert(errMsg);
		elFilledText.focus();
		return false;
    }
    return true;
}

function checkSets(setType) {
    var errMsg = "Please select one or more " + setType + " sets.";
    return isChecked ("filename", errMsg);
}

function checkSetsIncludingShare(setType) {
    var errMsg = "Please select one or more " + setType + " sets.";
    return isChecked ("filename,share_filename", errMsg);
}

function checkOneSet(setType) {
    var errMsg = "Please select one " + setType + " set.";
    return isOneChecked ("filename", errMsg);
}

function checkOneSetIncludingShare(setType) {
    var errMsg = "Please select one " + setType + " set.";
    return isOneChecked ("filename,share_filename", errMsg);
}

function checkTwoSets(setType) {
    var errMsg = "Please select two or more " + setType + " sets.";
    return isTwoChecked ("filename", errMsg);
}

function checkTwoSetsIncludingShare(setType) {
    var errMsg = "Please select two or more " + setType + " sets.";
    return isTwoChecked ("filename,share_filename", errMsg);
}

var callbackUpload = function(o) {
    displayWait(false);
    var res = o.responseText;
    if (res.match(/^\<div/i)) {
		document.getElementById("popup_content").innerHTML = res;
		popup_box.show();
    } else {
		alert(res);
    }
}

var callbackImport = function(o) {
    displayWait(false);
    var res = o.responseText;
    var query = o.argument;
    if (YAHOO.env.ua.ie > 0) {
		var myCallId = new Date().getTime(); // override cache for IE
		query += "&callid=" + myCallId;
    } 
    var url = "main.cgi?" + query;
    window.open(url, '_self');
    alert (res);
}
 
var callbackFailure = function(o) {
    displayWait(false);
    if (o.status == -1) {
		alert("Connection Timeout: " + o.statusText);
    } else if (o.status == 0) {
		alert("Server Error: " + o.statusText);
    } else {
		alert("Failure: " + o.statusText);
    }
}

function importSet(textFieldID) {
    var ret = uploadFileName(textFieldID);
    if (!ret)
	return ret;
    displayWait(true, "Importing");
    var fObj = document.mainForm;
    YAHOO.util.Connect.setForm(fObj, true, true);
    var url = "xml.cgi";
    var callback = {
	upload  : callbackUpload,
	failure : callbackFailure,
	timeout : 60000
    }
    var request = YAHOO.util.Connect.asyncRequest('POST', url, callback);
}

YAHOO.util.Event.onDOMReady(function () {
    getToolTip();
    var handleSubmit = function() {
	var noChkMsg = "Please select one or more sets.";
	if (isChecked("selected_import", noChkMsg)) {
	    popup_box.hide();
	    var sDelay = function () {
		displayWait(true, "Saving to workspace");
	    };
	    setTimeout(sDelay, 100);
	    var fObj = document.mainForm;
	    var myArg = "section=" + fObj.section.value +
		   "&page=" + fObj.folder.value;
	    fObj.importStep.value = 2;
	    YAHOO.util.Connect.setForm(fObj);
	    var url = "xml.cgi";
	    var callback = {
		success : callbackImport,
		failure : callbackFailure,
		timeout : 60000,
		argument: myArg
	    }
	    var request = YAHOO.util.Connect.asyncRequest('POST', url, callback);
	}
    };

    var handleCancel = function() {
	this.cancel();
    };
    YAHOO.util.Dom.removeClass("popup_box", "yui-pe-content");

    popup_box = new YAHOO.widget.Dialog
                     ("popup_box", 
		      {
			  fixedcenter : true,
			  visible : false,
			  zIndex : 4,
			  constraintoviewport : true,
			  effect:{effect:YAHOO.widget.ContainerEffect.FADE,duration:0.25},
			  buttons : [ { text:"Import Selected", handler:handleSubmit, isDefault:true },
				      { text:"Cancel", handler:handleCancel } ]
		      });
	
    document.getElementById("popup_box").style["display"] = "block";
    popup_box.render();
});

function getToolTip() {
    var url = "xml.cgi?section=tooltip&filename=workspaceImportFormat.html";
    var callback = {
	success : callbackToolTip,
	timeout : 60000
    }
    var request = YAHOO.util.Connect.asyncRequest('GET', url, callback);
}

var callbackToolTip = function(o) {
    var sToolTip = o.responseText;
    var tipImage = "w_imp_fmt";
    var importTip = new YAHOO.widget.Panel("importTip", {
	context: [tipImage,"tl","bl", ["beforeShow", "windowResize"], [0,5]],
	width: "350px",
	visible: false,
	draggable: false,
	effect: { effect:YAHOO.widget.ContainerEffect.FADE,duration:0.20 }
    });
    importTip.setBody(sToolTip);
    importTip.render(document.body);

    var importAction = function(e) {
	if (importTip.cfg.getProperty("visible")) {
	    importTip.hide();
	} else {
	    importTip.show();
	}	
    };
    YAHOO.util.Event.addListener(tipImage, "click", importAction, importTip, true);
}

function isChecked(chkNameList, errMsg) {
    var chkNameArr = chkNameList.split(',');
    var cnt = 0;

    for (var idx in chkNameArr) {
		var chkName = chkNameArr[idx];
		var chkBox = document.getElementsByName(chkName).length;
		for (var i = 0; i < chkBox; i++) {
		    if (document.getElementsByName(chkName)[i].checked) {
				cnt++;
		    } else if ( document.getElementsByName(chkName)[i].type == 'hidden' ) {
				cnt++;
		    }
		}
    }

    if (cnt < 1 && errMsg) {
       alert(errMsg);
       return false;
    }
    return true;
}

function isFixedNumberChecked(chkNameList, num, errMsg) {
    var chkNameArr = chkNameList.split(',');
    var cnt = 0;

    for (var idx in chkNameArr) {
		var chkName = chkNameArr[idx];
		var chkBox = document.getElementsByName(chkName).length;
		for (var i = 0; i < chkBox; i++) {
		    if (document.getElementsByName(chkName)[i].checked) {
				cnt++;
		    } else if ( document.getElementsByName(chkName)[i].type == 'hidden' ) {
				cnt++;
		    }
		}
    }

    if (num < 2 && cnt != num && errMsg) {
    	alert(errMsg );
       return false;
    } else if (num > 1 && cnt < num && errMsg) {
    	// two or more - ken
        alert(errMsg );
        return false;    	
    }
    return true;
}

function isOneChecked(chkNameList, errMsg) {
	return isFixedNumberChecked(chkNameList, 1, errMsg);

	/*
    var chkBox = document.getElementsByName(chkName).length;

    var cnt = 0;
    for (var i = 0; i < chkBox; i++) {
		if (document.getElementsByName(chkName)[i].checked)
		    cnt++;
    }

    if (cnt != 1 && errMsg) {
       alert(errMsg);
       return false;
    }
    return true;
    */
}

// this is tow or more - ken 2015-08-24
function isTwoChecked(chkNameList, errMsg) {
	return isFixedNumberChecked(chkNameList, 2, errMsg);
}

function selAll(x) {
    var chkName = "selected_import";
    var chkLen = document.getElementsByName(chkName).length;
    
    for (var i = 0; i < chkLen; i++) {
	var e = document.getElementsByName(chkName)[i];
	e.checked = (x == 0 ? false : true);
    }
} 

function setParam(paramName, paramValue) {
    var hiddenField = document.createElement("input");
    hiddenField.setAttribute("type", "hidden");
    hiddenField.setAttribute("name", paramName);
    hiddenField.setAttribute("value", paramValue);
    document.mainForm.appendChild(hiddenField);
    //alert("done set " + hiddenField.name + " as " + hiddenField.value);
}

function setParamAndCheck(paramName, chkName, errMsg) {
	setParam(paramName, chkName);
    return isChecked(chkName, errMsg);
}

function setParamAndCheckSelectedAndFileName(textFieldName, btnGrpName, selectFieldName, selectFieldParamName) {
    //alert("to set " + selectFieldParamName + " as " + selectFieldName);
	if ( selectFieldParamName && selectFieldParamName.length > 0 ) {
		setParam(selectFieldParamName, selectFieldName);	
	}
	return checkSelectedAndFileName(textFieldName, btnGrpName, selectFieldName);
}

function myValidationBeforeSubmit1(textFileName, btnGrpName, id1, minSelect1, id2, minSelect2) {
	//alert("myValidationBeforeSubmit1");
	if ( myCheckBeforeSubmit(id1, minSelect1, id2, minSelect2) == false ) {
		return false;
	}
	return checkFileName(textFileName, btnGrpName);
}

function myValidationBeforeSubmit2(setType, id1, minSelect1, id2, minSelect2) {
	//alert("myValidationBeforeSubmit2");
	if ( myCheckBeforeSubmit(id1, minSelect1, id2, minSelect2) == false ) {
		return false;
	}
	return checkSetsIncludingShare(setType);
}

function myValidationBeforeSubmit3(textFieldName, setType, id1, minSelect1, id2, minSelect2) {
	//alert("myValidationBeforeSubmit3");
	if ( myCheckBeforeSubmit(id1, minSelect1, id2, minSelect2) == false ) {
		return false;
	}
	return checkSetsIncludingShareAndFilled(textFieldName, setType);
}

function myValidationBeforeSubmit4(textFieldName, btnGrpName, setType, id1, minSelect1, id2, minSelect2) {
	//alert("myValidationBeforeSubmit4");
	if ( myCheckBeforeSubmit(id1, minSelect1, id2, minSelect2) == false ) {
		return false;
	}
	return checkSetsIncludingShareAndFileName(textFieldName, btnGrpName, setType);
}
