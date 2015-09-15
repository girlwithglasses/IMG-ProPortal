/*
 $Id: selection.js 32237 2014-11-04 17:01:54Z aratner $
 */

var updInt;
var intID;
var iTimer = 0;
var origStat;
var iPBdelay = 1000;  // progress bar vanish delay (ms)
var iAnimThresh = 50; // total rows less than this will create animated bars
var iAnimDur = 1.3;   // bar animation duration in seconds
var filtObj;
var bMoreGoClicked = false; //track if a "Display ... again" button was clicked

waitPanel = new YAHOO.widget.Panel("modalwait",
	    { width: "250px",
	      fixedcenter: true,
	      close: false,
	      draggable: false,
	      zindex:4,
	      modal: true,
	      visible: false
	    });

waitPanel.setBody("");
waitPanel.render(document.body);

function IMGTable (sTableID, sFormID, sTmpFile, iTotalRec, oMyDT, iUniqueTableId, myAllSelectData) {
    this.animate;
    this.checkBoxArray = [];
    this.dirtyChkBoxes = {};
    this.coldefs = null;
    this.form = document.getElementById(sFormID);
    this.formId = sFormID;
    this.pBarA = null;
    this.pBarB = null;
    this.pbText = "";
    this.uniqueId = iUniqueTableId;
    this.rows = 0;
    this.sort = null;
    this.table = document.getElementById(sTableID)
    this.tableId = sTableID;
    this.tmpfile = sTmpFile;
    this.total = iTotalRec;
    this.myDataTable = oMyDT;
    this.nopage = (this.myDataTable.configs.paginator) ? false : true;

    if (typeof IMGTable._init == "undefined") {
        IMGTable.prototype.createBars = function (bAnim) {
            if (this.nopage) return;
            this.animate = bAnim;
	        if (!this.isPBarsActive()) {
	            this.pBarA = initBar (this.tableId + "_pbA", this.tableId, this.total);
	            this.pBarB = initBar (this.tableId + "_pbB", this.tableId, this.total);
	            this.pbText = YAHOO.util.Dom.getElementsByClassName("yui-pb-tr","div", this.tableId + "_section");
	            for (var i = 0; i < this.pbText.length; i++) {
	                this.pbText[i].className = "yui-pb-tr bd pb";
	            }
	        }
	        this.animateBars();
	    };

        IMGTable.prototype.isPBarsActive = function () {
            var bRet;
            bRet = (document.getElementById(this.tableId + "_pbA").children.length == 0) ? false : true;
            return bRet;
        };

        IMGTable.prototype.updateBars = function () {
            if (this.nopage) return;
            if (!this.isPBarsActive()) return;
		    if (this.rows > this.total)
		        this.rows = this.total;
	        var sText = this.rows +" of "+ this.total + " rows selected &nbsp;"
	        this.pBarA.set('maxValue',this.total);
	        this.pBarB.set('maxValue',this.total);
	        this.pBarA.set('value',this.rows);
	        this.pBarB.set('value',this.rows);
	        sText = (this.total < 1) ? "No records &nbsp;" : sText;
	        this.pbText[0].innerHTML = sText;
	        this.pbText[1].innerHTML = sText;
        };

        IMGTable.prototype.animateBars = function (iDuration) {
            if (this.nopage) return;
            if (this.animate == undefined) {
                this.animate = (this.total < iAnimThresh) ? true : false;
                this.animate = (this.rows < 1) ? true : this.animate
            }
            if (this.pBarA)
	            animBar (this.pBarA, iDuration, this.animate);
            if (this.pBarB)
	            animBar (this.pBarB, iDuration, this.animate);
        };

        IMGTable.prototype.resizeBars = function () {
			if (this.nopage) return;
			var tWidth = document.getElementById(this.tableId).getElementsByTagName("table")[0].offsetWidth;
			var tmpAnim = this.animate;
			this.animate = false;
			this.animateBars();
			if (this.pBarA)
			  this.pBarA.set('width', tWidth);
			if (this.pBarB)
			  this.pBarB.set('width', tWidth);
		
			this.animate = tmpAnim;
			this.animateBars();
        };

        IMGTable.prototype.destroyBars = function () {
			if (this.nopage)
			    return;
			this.rows=0;
			if (this.pBarA) {
			    this.pBarA.destroy(); this.pBarA = null;
			}
			if (this.pBarB) {
			    this.pBarB.destroy(); this.pBarB = null;
			}
        };

        IMGTable.prototype.onBarsDone = function(fn, wait) {
		    if (this.isPBarsActive()) {
		        this.pBarA.on('complete', function () {
			        setTimeout(fn, wait || iPBdelay);
	            });
		    } else {
		        setTimeout(fn, 0);
		    }
        };

        IMGTable._init = true;
    }
    checkAll(1, this, 1, 1, myAllSelectData);
}

function animBar (pBar, iDur, bAnim) {
    iDur = iDur || iAnimDur;

    pBar.set('anim', bAnim);
    if (!bAnim)
	return;

    var anim = pBar.get('anim');
    anim.duration = iDur;
    anim.method = YAHOO.util.Easing.bounceOut;
}

function initBar (sCntnr, tableID, totRec) {
    document.getElementById(sCntnr).innerHTML = ""; //reset p-bar text
    var tWidth = document.getElementById(tableID).getElementsByTagName("table")[0].offsetWidth;
    var pBar = new YAHOO.widget.ProgressBar({
	    value: 0,
	    maxValue: totRec,
	    width: tWidth
	}).render(sCntnr);
    return pBar;
}


function displayWait (bOn, sMsg) {
    if (bOn) {
	waitPanel.setHeader(sMsg + " ...");
	waitPanel.show();
    } else {
	waitPanel.hide();
    }
}

function showFilterError (oIMG, sErr) {
    if (sErr) {
		sErr = sErr.replace(/^###/, "");
		var arSplit = sErr.split("/ at (");
		sErr = arSplit[0];
		sMSG_ERROR = "<span style='color:red;font-style:italic;" +
		       "text-decoration:blink'>Regular expression error in filter</span>";
		oIMG.myDataTable.set("MSG_ERROR", sMSG_ERROR);	
    } else {
		oIMG.myDataTable.resetValue("MSG_ERROR");	
    }
    var elMsg = document.getElementById(oIMG.tableId + '_filter-error');
    if (elMsg) {
		elMsg.innerHTML = sErr;
    }
}

function checkBoxDataSuccess(oIMGTable, bChkState, bInit) {
    //alert("checkBoxDataSuccess bChkState=" + bChkState + ', bInit=' + bInit);
	
    if ((oIMGTable.checkBoxArray == undefined )
	|| (oIMGTable.checkBoxArray.length < 1)){
	displayWait(false);
	disableFormEl(0, oIMGTable);
	return;
    }

    if (oIMGTable.rows >= oIMGTable.total) {
        if (document.getElementById(oIMGTable.tableId + '_search-inputA').value == "") {
	    displayWait(false);
	    return;
        }
    }

    var tempDivId = oIMGTable.tableId + "_hid_chk";
    var tempDiv = document.getElementById(tempDivId);
    if (tempDiv != undefined) {
	tempDiv.parentNode.removeChild(tempDiv);
	oIMGTable.rows = 0;
    }
    tempDiv = document.createElement('div');
    tempDiv.id = tempDivId;

    if (bChkState == 1) {
        oIMGTable.animate = undefined;
        if (!bInit) {
	    intID = setInterval("timeThis()", 1);
	    var dt = new Date();
	    iTimer = dt.getTime();
	    var elStatus = document.getElementById("loading");
	    if (elStatus) {
		origStat = elStatus.innerHTML;
	    }
        } else {
	    disableCheckBox(1, oIMGTable);
        }
    }

    displayWait(false);
    if (oIMGTable.rows > 0) {
        oIMGTable.createBars();
    }

    var ctr=1;
    updInt = setInterval(function (){
       var refRate = Math.round(oIMGTable.total * 0.01);

       while (oIMGTable.rows < oIMGTable.total) {
		   var sArrVal = oIMGTable.checkBoxArray[ctr];
		   ctr++;

		   if ((ctr - 1) > oIMGTable.total)
			break;

		   if (!sArrVal)
		       continue;

		   if (!sArrVal.match(/checked/gi))
		       continue;

		   oIMGTable.rows++;
		   if (oIMGTable.rows == 1) {
		       oIMGTable.createBars();
		   }

		    if (oIMGTable.checkBoxArray.length == 0) {
		        clearInterval (updInt);
		        return;
		    }
		    var d = document.createElement('div')
		    var sChk = oIMGTable.checkBoxArray[ctr-1].replace("checkbox","hidden");

		    d.innerHTML = sChk;

		    var elOld = d.getElementsByTagName("input")[0];
	 	    tempDiv.appendChild(hidEl(elOld.name, elOld.value));

		    if (oIMGTable.rows%refRate == 0) {
		        break;
		    }
       }
	   //alert("selection.js checkBoxDataSuccess() oIMGTable.isPBarsActive()=" + oIMGTable.isPBarsActive());
       if (oIMGTable.isPBarsActive()) {
    	   //alert("selection.js checkBoxDataSuccess() updateBars() called 1");
		   oIMGTable.updateBars();
	
		   if (oIMGTable.rows == 0) {
	    	   //alert("selection.js checkBoxDataSuccess() updateBars() called 2");
		       disableFormEl(1, oIMGTable);
		       var sDelay = function () { clearPB(oIMGTable); };
		       oIMGTable.onBarsDone(sDelay, 500);
		       if (!oIMGTable.animate)
			       oIMGTable.updateBars();
		   }
       }

       if (ctr > oIMGTable.total) {
		   clearInterval(updInt);
		   clearInterval(intID);
		   if (bChkState == 1) {
		       if (tempDiv.children.length > 0 && oIMGTable.form != null)
			   oIMGTable.form.appendChild(tempDiv);
		       disableFormEl(0, oIMGTable);
		   }
		   var restoreStLn = function () {
		       if (origStat != undefined)
			   document.getElementById("loading").innerHTML = origStat;
		   };
		   setTimeout(restoreStLn, 2000);
       }
    },1);
    
}

function allSelectDataSuccess(oIMGTable, bChkState, bInit, allSelectData) {
	//alert("allSelectDataSuccess bChkState=" + bChkState + ', bInit=' + bInit);

	showFilterError(oIMGTable,"");
	oIMGTable.checkBoxArray = allSelectData;
	oIMGTable.dirtyChkBoxes = {};

	checkBoxDataSuccess(oIMGTable, bChkState, bInit);
}

var callbackSuccess = function(o) {
    //alert("callbackSuccess");

    var oIMGTable = o.argument.oIMGTable;
    var bChkState = o.argument.bChkState;
    var bInit = o.argument.bInit;
    var responseText = o.responseText;

    if (responseText.match(/^###/)) {
	showFilterError(oIMGTable, responseText);
    } else {
	showFilterError(oIMGTable,"");
	oIMGTable.checkBoxArray = eval(o.responseText);
	oIMGTable.dirtyChkBoxes = {};
    }
    
    checkBoxDataSuccess(oIMGTable, bChkState, bInit);
	
}

var callbackFailure = function(o) {
    displayWait(false);
    disableFormEl(0, oIMGTable);

    if (o.status == -1) {
	alert("Connection Timeout: " + o.statusText);
    } else if (o.status == 0) {
	alert("Server Error: " + o.statusText);
    } else {
	alert("Failure: " + o.statusText);
    }
}

function checkAll(x, oIMGTable, myDataTable, init, allSelectData) {
    //alert("checkAll x=" + x + ', init=' + init);
    if (!oIMGTable) {
	selectAllCheckBoxes(x); // no progressbar
	//alert("oIMGTable is null!"); 
	return;
    }

    if (x == 0 && oIMGTable.rows < 1) {
        if (oIMGTable.isPBarsActive()) {
	    clearPB(oIMGTable);
	}
	//alert("oIMGTable no rows! "); 
        //return;
    }

    if (x == 1 && oIMGTable.rows == oIMGTable.total) {
        if (oIMGTable.isPBarsActive()) {
            return;
	}
    }

    var bAllChk = (myDataTable) ? false : true;

    if ( allSelectData != null && allSelectData != undefined ) {
    	allSelectDataSuccess(oIMGTable, x, init, allSelectData);
    }
    else {
        if (x == 1) {
            displayWait(true, "Collating data");
            disableFormEl(1, oIMGTable);
        }

        var myArg = {};
        myArg.oIMGTable = oIMGTable;
        myArg.bChkState = x;
        myArg.bInit = init;
        
        var strCol = document.getElementById(oIMGTable.tableId +'_search-listA').value;
        var strFilt = document.getElementById(oIMGTable.tableId +'_search-inputA').value;
        var strType = document.getElementById(oIMGTable.tableId +'_search-typeA').value;
        var myCallId = new Date().getTime(); //randomize URL to prevent caching
        var url = "xml.cgi?section=Selection&page=getCheckboxes" +
    	"&tmpfile=" + oIMGTable.tmpfile + "&chk=" + x +
    	"&init=" + (init ? 1:0) + "&c=" + strCol + "&f=" + escape(strFilt) +
    	"&t=" + escape(strType) + "&call=" + myCallId;
        //alert("checkall x=" + x + ', bAllChk=' + bAllChk + ', url=' + url);

        var callback = {
        	    success : callbackSuccess,
        	    failure : callbackFailure,
        	    timeout : 180000,
        	    argument: myArg
        }

        var request = YAHOO.util.Connect.asyncRequest('GET', unescape(url), callback);
    }

    if (x == 1) {
        if ((oIMGTable.rows >= oIMGTable.total) && (oIMGTable.total > 0))
            return;

        if (bAllChk)
            checkBoxSelect(1, oIMGTable.table);

    } else {
        if (oIMGTable.nopage)
            selectAllCheckBoxes(x);

        if (oIMGTable.rows == 0)
            return;

        displayWait(true, "Deselecting rows");
        var tempDivId = oIMGTable.tableId + "_hid_chk";
        var tempDiv = document.getElementById(tempDivId);

        if (tempDiv != undefined)
            tempDiv.parentNode.removeChild(tempDiv);

        oIMGTable.rows = 0;
        if (!oIMGTable.nopage)
            disableFormEl(1, oIMGTable);

        oIMGTable.animate = true;
        oIMGTable.animateBars();

        clearInterval(updInt);
        clearInterval(intID);
    }
}

function clearPB(oIMGTable) {
    checkBoxSelect(0, oIMGTable.table);
    oIMGTable.destroyBars();
    disableFormEl(0, oIMGTable);
    var tempDiv = document.getElementById(oIMGTable.tableId + "_hid_chk");

    if (tempDiv) {
	if (tempDiv.parentNode)
	    tempDiv.parentNode.removeChild(tempDiv);
    }
    if (origStat != undefined)
	document.getElementById("loading").innerHTML = origStat;
}

function checkBoxInvert(oEl) {
   var els = oEl.getElementsByTagName('input');
   for ( var i = 0; i < els.length; i++) {
       var e = els[i];
       if (e.name == "mviewFilter")
	   continue;
       if (e.type == "checkbox") {
	   e.checked = (e.checked ? false : true);
       }
   }
}

function checkBoxSelect(x, oEl) {
   var chk = oEl.getElementsByTagName('input');
   var n;
   for ( var i = 0; i < chk.length; i++) {
      var e = chk[i];
      if (e.name == "mviewFilter")
	  continue;
      if (e.type == "checkbox") {
	  n = (n == undefined) ?  e.name : n;
	  if (e.name == n)
	      e.checked = (x == 0 ? false : true);
      }
   }
}

function selectPage (p_oEvent, oMyObj) {
    //alert('selectPage() started');
    var selFlag;
    if (p_oEvent) {
	selFlag = p_oEvent.currentTarget.id.match(/deselect/i) ? 0 : 1;
    	if (selFlag == 1 )  {
	    displayWait(true, "Selecting rows on this page");
	} else {
	    if (oMyObj.rows > 0)
		displayWait(true, "Deselecting rows on this page");
	    else
		return;
	}
    }
    var chk = oMyObj.table.getElementsByTagName('input');
    if (chk.length < 1) {
	displayWait(false);
	return;
    }
    var n;
    var dirtyFlag = 0;
    var tempDivId = oMyObj.tableId + "_hid_chk";
    var tempDiv = document.getElementById(tempDivId);

    //alert('selectPage() oMyObj.checkBoxArray.length = ' + oMyObj.checkBoxArray.length );
    //alert('selectPage() 0 oMyObj.rows = ' + oMyObj.rows + ' chk.length = ' + chk.length);
    
    var checkBoxDict = {};
    var checkBoxDictPopulated = 0;
    
    for (var i = 0; i < chk.length; i++) {
	var e = chk[i];
	if (e.name == "mviewFilter")
	    continue;
	if (e.type == "checkbox") {
	    n = (n == undefined) ?  e.name : n;
	    if (e.name == n) {
		var oRecord = oMyObj.myDataTable.getRecord(e);
		var iRowId = oRecord.getData('_img_yuirow_id');
		var box;
		if ( oMyObj.checkBoxArray[i+1] && oMyObj.checkBoxArray[i+1].indexOf(e.value) > 0 ) {
		    box = oMyObj.checkBoxArray[i+1];
		    //if ( i < 3 ) {
		    //	alert('e.value = ' + e.value + ', iRowId = ' + iRowId + ', i+1 = ' + (i + 1) + ', box = ' + box);
		    //}
		}
		else {
		    if ( checkBoxDictPopulated == 0 ) {
			//alert('into checkBoxDictPopulated == 0');
			for (var j = 1; j < oMyObj.checkBoxArray.length; j++) {
			    if ( oMyObj.checkBoxArray[j] ) {
				var keyValue = getHTMLAttrValue("value", oMyObj.checkBoxArray[j]);
				checkBoxDict[keyValue] = oMyObj.checkBoxArray[j];
				checkBoxDictPopulated = 1;
				//if ( j < 3 ) {
				//	alert('oMyObj.checkBoxArray[' + j + '] = ' + oMyObj.checkBoxArray[j] + ', keyValue = ' + keyValue);
				//}
			    }
			}
		    }
		    if ( checkBoxDictPopulated == 1 ) {
			//alert('into checkBoxDictPopulated == 1');
			var boxj = checkBoxDict[e.value];
			if (boxj) {
			    box = boxj;
			}
		    }
		    //if ( i < 3 ) {
		    //	alert('e.value = ' + e.value + ', iRowId = ' + iRowId + ', box = ' + box);
		    //}
		}
		if (!p_oEvent) {// called by form reset button
		    selFlag = e.checked * 1;
		    var oldState = oMyObj.checkBoxArray[iRowId].match(/checked/) ?
			true : false;
		    if (e.checked == oldState)
			continue; // checkbox wasn't affected by Reset
		    dirtyFlag = 1;
		} else {
		    var newState = (selFlag == 0 ? false : true);
		    if (e.checked == newState)
			continue; //already in the required state
		    e.checked = newState;
		    dirtyFlag = selFlag;
		}
		oMyObj.dirtyChkBoxes[iRowId] = dirtyFlag;
		var elHid = document.getElementById(e.name + "-" + e.value);
		
		if (selFlag == 0) {
		    oMyObj.rows--;
		    box = box.replace(/\s*checked\s*=\s*('|")\s*checked\s*('|")/i, "");
		    box = box.replace(/\s*checked/i, "");
		    if (elHid != undefined) {
		        elHid.parentNode.removeChild(elHid);
		    }
		} else {
		    oMyObj.rows++;
		    if (!box.match(/checked/)) {
			box = box.replace(/input/, "input checked='checked'");
		    }
		
		    if (tempDiv == undefined) {
			tempDiv = document.createElement('div');
			tempDiv.id = tempDivId;
			oMyObj.form.appendChild(tempDiv);
		    }
		    tempDiv.appendChild(hidEl(e.name, e.value));
		}
				oMyObj.checkBoxArray[iRowId] = box;
		    }
		}
    }
    //alert('selectPage() 1 oMyObj.rows = ' + oMyObj.rows);    
    if (n == undefined) {
	displayWait(false);
	return;
    }
    var dummy = {};
    saveChk(oMyObj, dummy);
    oMyObj.dirtyChkBoxes = {};

    var tmpAnimThresh = iAnimThresh;
    oMyObj.animate = true;
    iAnimThresh = oMyObj.total + 1; // temporarily force animation regardless of rows
    oMyObj.createBars(true);
    oMyObj.animateBars(0.8);
    oMyObj.updateBars();
    iAnimThresh = tmpAnimThresh;

    if (oMyObj.rows <= 0) {
	disableFormEl(1, oMyObj);
	var sDelay;
	sDelay = function () { clearPB(oMyObj); };
	oMyObj.onBarsDone(sDelay, 500);
    }
    displayWait(false);
}

function getHTMLAttrValue(name, tagStr) {
    if ( name && name.length && tagStr && tagStr.length ) {
	var tagStr_lower = tagStr.toLowerCase();
	var name_signature = ' ' + name.toLowerCase() + '=';
	var name_index = tagStr_lower.indexOf(name_signature);
	if ( name_index >= 0 ) {
	    var val_index = name_index + name_signature.length;
	    if ( tagStr.length > val_index ) {
		var rest_str = tagStr.substring(val_index);
		var rest_start_char = rest_str.charAt(0);
		if ( rest_start_char == "\'" || rest_start_char == "\"" ) {  
		    var intactTokens = rest_str.split(/['"]/);
		    //alert('tagStr = ' + tagStr + ', intactTokens = ' + intactTokens + ', intactTokens[1] = ' + intactTokens[1]);
		    if ( intactTokens[1] ) {
			return intactTokens[1];
		    }					
		}
		else {
		    var htmlTokens = rest_str.split(/[ ]+/);
		    //alert('tagStr = ' + tagStr + ', htmlTokens = ' + htmlTokens + ', htmlTokens[0] = ' + htmlTokens[0]);
		    if ( htmlTokens[0] ) {
			return htmlTokens[0];
			//var str = htmlTokens[0].replace(/"/g, "");
			//str = htmlTokens[0].replace(/'/g, "");
			//return str;
		    }					
		}
	    }
	}
    }
    return null;
}

function disableButton(sClass, sName, bState) {
  var but;
  if (sName == "")
     but = YAHOO.util.Dom.getElementsByClassName(sClass,"input");
  else
     but = document.getElementsByName(sName);

  for (var i=0; i < but.length; i++)
      but[i].disabled = (bState == 0 ? false : true);
}

function disableCheckBox(x, oIMGTable) {
    if (!oIMGTable)
    	return;
    
    var sClass = oIMGTable.tableId + "-chk";
    var chks = YAHOO.util.Dom.getElementsByClassName(sClass, "input", oIMGTable.form);

    if ( chks != null ) {
        for ( var i = 0; i < chks.length; i++) {
    		if (x==0) { // don't enable if checkbox was disabled in code
    		    if (!chks[i].parentNode.innerHTML.match(/disabled/))
    				chks[i].disabled = (x == 0 ? false : true);
    		}
        }    	
    }
}

function disableFormEl(x, f) {
  disableButton("", "selectAll", x);
  disableButton("meddefbutton", "", x);
  disableButton("smdefbutton", "", x);
  disableButton("medbutton", "", x);
  disableButton("", "inverseSel", x);
  disableCheckBox (x, f);
}

function timeThis() {
    var dt = new Date();
    var elStatus = document.getElementById("loading");
    if (elStatus) {
	elStatus.innerHTML = "Elapsed: "
		+ Number((dt.getTime() - iTimer)/1000).toFixed(2) + " seconds";
    }
}

function createButton(sCntnr, sLabel, oIMGTable, func, tipText) {
    var sButtonId = sCntnr + "-" + sLabel.replace(" ", "");
    var noChkBoxes = true;
    if (!oIMGTable.coldefs)
	return;
    for (var i=0; i < oIMGTable.coldefs.length; i++) {
	if (oIMGTable.coldefs[i].key.search(/(^Select$|^Selection$)/i) >= 0) {
	   noChkBoxes = false;
	   break;
	}
    }
    if (noChkBoxes)
	oIMGTable.rows = oIMGTable.total;

    var oNav = document.getElementById(sCntnr);
    var oFirstChild = oNav.firstChild;
    if (oNav.children[sButtonId + "-span"] != undefined)
	return;  //if button exists don't create again
    var oSpan = document.createElement("span");
    oSpan.id = sButtonId + "-span";
    oNav.insertBefore(oSpan, oFirstChild);

    var oButton = new YAHOO.widget.Button({
	label: sLabel,
	id: sButtonId,
	container: oSpan.id,
	onclick: {
	    fn: func,
	    obj:oIMGTable
	}
    });

    var exportTip = new YAHOO.widget.Tooltip(sButtonId, {
	context: oSpan.id,
	container: oIMGTable.tableId + "_section",
	showdelay: 0,
	autodismissdelay: 9000,
	text: tipText,
	effect: { effect:YAHOO.widget.ContainerEffect.FADE,duration:0.40 }
    });
    return oButton;
}

function onButton(p_oEvent, oMyObj) {
    if (oMyObj.rows < 1) {
	alert("Please select one or more rows and try again.");
    } else if ((oMyObj.rows > 5000) && (oMyObj.rows < oMyObj.total))  {
	alert("Individual selections too large. Please SELECT ALL and try again.");
    } else {
    	try {
    	    //alert('here: ' + contact_oid);
    	    //_gaq.push(['_trackEvent', 'Export', contact_oid, 'yui table ' + oMyObj.tableId]);
    	    // i had to force contact_oid to be a string
            //ga('send', 'event', 'Export', contact_oid.toString(), 'yui table ' + oMyObj.tableId);
    	    var tmp = 'yui table ' + oMyObj.tableId + ' rows' + oMyObj.rows + ' total' + oMyObj.total;
    	    ga('send', 'event', 'Export', 'yui' + contact_oid, tmp);
	        var callbacks = {
	            success : function(o) {
	                // do nothing
	            },
	            failure : function(o) {
	                // do nothing
	            },
	            timeout : 10000
	        }
	        var url = xmlplurl + '?section=yuitracker&text=' + encodeURIComponent(tmp);
	        YAHOO.util.Connect.asyncRequest('GET', url, callbacks);
    	} catch(err) {
    	    // do nothing
    	    alert(err);
    	}    	
    	
	var sColDefs = YAHOO.lang.JSON.stringify(oMyObj.coldefs, ["key", "label"]);
	var sChkRows = (oMyObj.rows == oMyObj.total) ? "all" : YAHOO.lang.JSON.stringify(oMyObj.checkBoxArray);
	sChkRows = (sChkRows == "[]") ? "all" : sChkRows; // no checkboxes
	var sCol = document.getElementById(oMyObj.tableId +'_search-listA').value;
	var sFilt = document.getElementById(oMyObj.tableId +'_search-inputA').value;
	var sType = document.getElementById(oMyObj.tableId +'_search-typeA').value;
	var oForm = document.createElement("form");
	oForm.method = "post";
	oForm.enctype="multipart/form-data";
	oForm.action = "xml.cgi";
	oForm.appendChild(hidEl("section", "Selection"));
	oForm.appendChild(hidEl("page", "export"));
	oForm.appendChild(hidEl("tmpfile", oMyObj.tmpfile));
	oForm.appendChild(hidEl("table", oMyObj.tableId));
	oForm.appendChild(hidEl("sort", oMyObj.sort));
	oForm.appendChild(hidEl("rows", sChkRows));
	oForm.appendChild(hidEl("columns", sColDefs));
	oForm.appendChild(hidEl("c", sCol));
	oForm.appendChild(hidEl("f", sFilt));
	oForm.appendChild(hidEl("t", sType));
	document.body.appendChild(oForm);
	oForm.submit();
	document.body.removeChild(oForm);
   }
}

function hidEl(name, value) {
    var inp = document.createElement("input");
    inp.type = "hidden";
    inp.name = name;
    inp.value = value;
    inp.id = name + "-" + value;
    return inp;
}

function removeDups(sForm, sTable) {
    var doc = window.document;
    var oForm = doc.getElementById (sForm);

    if (oForm == undefined)
	return;
    
    // Persist filter for carts. See below.
    if (sTable.match(/cart/gi)) {
	bMoreGoClicked = true;
    }

    // A button with id=moreGo was clicked. These are buttons
    // that reload the same page with possibly different columns.
    // So persist filter term across sessions.
    // bMoreGoClicked defined globally.
    if (bMoreGoClicked) {
	persistFilterTerm(oForm, sTable);
	bMoreGoClicked = false;
    }

    var oHidNode = doc.getElementById(sTable + "_hid_chk");
    if (oHidNode == undefined)
	return;

    for (var i=0; i < oForm.elements.length; i++) {
	elChk = oForm.elements[i];
	if ((elChk.type == "checkbox") && (elChk.checked))  {
	    var chkId = oForm.elements[i].name + "-" + oForm.elements[i].value;
	    var oHidChk = doc.getElementById(chkId);
	    if ((oHidChk != undefined) && (oHidChk.parentNode === oHidNode))
		oHidNode.removeChild(oHidChk);
	}
    }
}

YAHOO.util.Event.on("moreGo", "click", function(e) {
    bMoreGoClicked = true;
});


function persistFilterTerm(oForm, sTable) {
    var sCol;
    var sFilt;
    var sType;

    var tempEl  = document.createElement('input');
    tempEl.type = "hidden";

    var filtCol  = tempEl.cloneNode(true);
    var filtTerm = tempEl.cloneNode(true);
    var filtType = tempEl.cloneNode(true);

    if (filtObj) {
	sCol  = filtObj.col;
	sFilt = filtObj.term;
	sType = filtObj.type;
    } else {
	sCol  = document.getElementById(sTable +'_search-listA').value;
	sFilt = document.getElementById(sTable +'_search-inputA').value;
	sType = document.getElementById(sTable +'_search-typeA').value;
    }

    filtCol.name   = "filtCol";
    filtCol.value  = sCol;
    filtTerm.name  = "filtTerm";
    filtTerm.value = sFilt;
    filtType.name  = "filtType";
    filtType.value = sType;

    oForm.appendChild(filtCol);
    oForm.appendChild(filtTerm);
    oForm.appendChild(filtType);
}

function handleReset(sForm, sTable) {
    var doc = window.document;
    var oForm = doc.getElementById (sForm);
    if (oForm == undefined)
	return;

    var updateForm = function () {
		selectPage(null, eval("oIMGTable_" + sTable));
    };
    setTimeout(updateForm, 100);
}

function setupRemoveDups(sFormId, sTableId) {
    if (!document.getElementById(sFormId))
	return;
    var submitClasses = ["meddefbutton","smdefbutton"];
    var submitButton = [];
    for (var i in submitClasses) {
	var e = YAHOO.util.Dom.getElementsByClassName(submitClasses[i], "input", sFormId);
	if (e.length > 0) {
	    submitButton = submitButton.concat(e);
	}
    }

    for (var i=0; i < submitButton.length; i++) {
	var sOnClickValue = submitButton[i].getAttribute("onClick");
       	if ( sOnClickValue != undefined) {
	    submitButton[i].setAttribute("onClick", "removeDups ('"
		 + sFormId + "', '" + sTableId + "'); " +  sOnClickValue);
	}
    }

    var onSubmitVal = document.getElementById (sFormId).getAttribute("onSubmit");
    var sOnSubmitStr = onSubmitVal || "";
    document.getElementById (sFormId).setAttribute("onSubmit", "removeDups ('"
         + sFormId + "', '" + sTableId + "'); " + sOnSubmitStr);
    document.getElementById (sFormId).setAttribute("onReset", "handleReset ('"
         + sFormId + "', '" + sTableId + "'); ");
}

function setOnClick (sName, sValue, sTable, iState) {
    var doc = window.document;
    if (!sName) return;
    var oBut = doc.getElementsByName(sName);
    if ((oBut.length < 1) && sValue) {
        oBut = getElementsByValue(sValue,
            "input", doc.getElementById("content"));
    }
    if (oBut.length < 1) {
	return;
    } else {
	for (var i=0; i < oBut.length; i++) {
	    if (oBut[i].id == '')
		oBut[i].id = sTable + iState;
	    if (oBut[i].id == (sTable + iState)) {
		oBut[i].getAttributeNode("onclick").value =
		    "checkAll(" + iState + ",  oIMGTable_" + sTable + ")";
	    }
	}
    }
}

function setInverseOnClick (sTable) {
    var doc = window.document;
    var oBut = doc.getElementsByName('inverseSel');
    if (oBut.length < 1) {
	return;
    } else {
	for (var i=0; i < oBut.length; i++) {
	    if (oBut[i].id == '')
		oBut[i].id = sTable + "3";
	    if (oBut[i].id == (sTable + "3")) {
		oBut[i].getAttributeNode("onclick").value =
		    "inverseAll(oIMGTable_" + sTable + ")";
	    }
	}
    }
}

function getElementsByValue(value, tag, node) {
    var values = [];
    if (tag == null)
	tag = "*";
    if (node == null)
	node = window.document;
    var search = node.getElementsByTagName(tag);
    var pat = new RegExp(value, "i");
    for (var i=0; i<search.length; i++) {
	if (pat.test(search[i].value))
	    values.push(search[i]);
    }
    return values;
}

function saveChk(oIMGTable, getBack, sync) {
    var sChkList = YAHOO.lang.JSON.stringify(oIMGTable.dirtyChkBoxes);

    var url = "xml.cgi";
    var data = "section=Selection" + "&page=getCheckboxes&tmpfile="
	       + oIMGTable.tmpfile + "&cl=" + sChkList;

    if (!sync) {
	    var request = YAHOO.util.Connect.asyncRequest('POST', url, getBack, data);
    } else {
	    var xhReq = new XMLHttpRequest();
	    xhReq.open('POST', url, false);
	    xhReq.onreadystatechange = function() {
	        if (xhReq.readyState!=4)
		        return false;
	    }
	    xhReq.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	    xhReq.setRequestHeader("Content-length", data.length);
	    xhReq.setRequestHeader("Connection", "close");

	    xhReq.send(data);
    }
}

function winUnload() {
    var oIMG;
    if(this.RuntimeObject)
        oIMG = RuntimeObject("oIMGTable*"); // IE only
    else
	oIMG = window;

    for (var o in oIMG) {
    	if (o.match(/oIMGTable/))
	    var oIMGTable = oIMG[o];
	else
	    continue;

    	if (oIMGTable) {
	    if (myObjSize(oIMGTable.dirtyChkBoxes) > 0) {
		displayWait(true, "Saving changes");
    		saveChk(oIMGTable, null, true);
		displayWait(false);
	    }
	}
    }
}

function myObjSize (o) {
    var i=0;
    for (var e in o) {
	i++;
    }
    return i;
}

function setupSearchList(searchList, colDefs, defCol) {
    if (!colDefs)
	return;
    var selObj = document.getElementById(searchList);
    var tmpEl = document.createElement("div");
    var idx = 0;

    for (var i=0; i < colDefs.length; i++) {
	if (colDefs[i].key.search(/(^Select$|^Selection$)/i) < 0) {
	    var optText = colDefs[i].label.replace(/<br\s*\/{0,1}>/gi, " "); // remove <br>
	    optText = optText.replace(/<sup>.*<\/sup>/gi, ""); // remove superscripts
	    optText = decodeEntities (optText);

	    if (optText.match(/^<img\s+alt/i)) { //image with alt text
		tmpEl.innerHTML = optText;
		optText = tmpEl.firstChild.alt;
	    }

	    if (colDefs[i].filter) {
		selObj.options[idx] = new Option(optText, colDefs[i].key);
		selObj.options[idx].title = "Search by " + optText;
		idx++;
	    }
	}
    }
    selObj.options[idx] = new Option ("All Columns", "all");
    selObj.options[idx].title="Search through all columns";
    selObj.value = defCol;
}

function setupSearchToolTip(sTableId) {
    
    var sToolTip = "<b><u>Filter text:</u></b> Plain text search<br/>" +
	   "<b><u>Filter regex:</u></b> Regular expression search<br/>" +
	   "Regex syntax reference: <a target='_new' href='http://perldoc.perl.org" +
	   "/perlreref.html#SYNTAX'>http://perldoc.perl.org/perlreref.html</a><br/><br/>" +
	   "<b><u>For numeric columns only:</u></b> " + 
	   "&lt;, &gt;, &lt;=, &gt;=, .. <i>(range)</i><br/>" +
	   "Examples: <br/>&lt;100 (values less than 100)<br/>" +
	   "&gt;=250 (values greater than or equal to 250)<br/>" +
	   "400..700 (values between 400 and 700 both inclusive)<br/>";

    var tipImage = sTableId + "_search-tipA";
    var filterTip = new YAHOO.widget.Panel("filterTip_" + sTableId, {
	context: [tipImage,"tl","bl", ["beforeShow", "windowResize"], [0,5]],
	width: "350px",
	visible: false,
	draggable: false,
	effect: { effect:YAHOO.widget.ContainerEffect.FADE,duration:0.20 }
    });
    filterTip.setBody(sToolTip);
    filterTip.render(document.body);

    var filterAction = function(e) {
	if (filterTip.cfg.getProperty("visible")) {
	    filterTip.hide();
	} else {
	    filterTip.show();
	}	
    };

    YAHOO.util.Event.addListener(tipImage, "click", filterAction, filterTip, true);
}

function setupSearchApplyBtn (sTableId, fnSearch) {
    var sContainer = sTableId + "_filter-apply";
    var sLabel = "Apply";
    var oButton = new YAHOO.widget.Button({
	id: sTableId + "-apply-button",
	label: sLabel,
	container: sContainer,
	onclick: {
	    fn: fnSearch
	}
    });
}

function stopEnterKey(e) {
    var e = (e) ? e : ((event) ? event : null);
    var node = (e.target) ? e.target : ((e.srcElement) ? e.srcElement : null);
    if ((e.keyCode == 13) && (node.type=="text"))  {
	return (node.name=="taxonTerm" ? true : false);
    }
}

function getQueryStr(variable, req) {
    var query = req ||  window.location.hash.substring(1);
    var vars = query.split("&");
    for (var i=0;i<vars.length;i++) {
	var pair = vars[i].split("=");
	if (pair[0] == variable) {
	    return unescape(pair[1]);
	}
    }
    return "";
}

function inverseAll(oIMGTable) {
    if (!oIMGTable) {
	inverseSelection(); // no progressbar
	return;
    }

    if (myObjSize(oIMGTable.dirtyChkBoxes) > 0) {
	displayWait(true, "Saving changes");
	saveChk(oIMGTable, null, true);
	displayWait(false);
	oIMGTable.dirtyChkBoxes = {};
    }

    var myArg = {};

    displayWait(true, "Inverting row selection");
    myArg.oIMGTable = oIMGTable;
    var myCallId = new Date().getTime(); //randomize URL to prevent caching
    var url = "xml.cgi?section=Selection&page=toggleCheckboxes" +
	"&tmpfile=" + oIMGTable.tmpfile + "&call=" + myCallId;

    var callback = {
	success : inverseSuccess,
	failure : callbackFailure,
	timeout : 180000,
	argument: myArg
    }

    var request = YAHOO.util.Connect.asyncRequest('GET', url, callback);
    if (!oIMGTable) {
	inverseSelection();
    } else {
	checkBoxInvert(oIMGTable.table);
    }
}

var inverseSuccess = function(o) {
    var oIMGTable = o.argument.oIMGTable;

    oIMGTable.checkBoxArray = eval(o.responseText);
    if ((oIMGTable.checkBoxArray == undefined )
	|| (oIMGTable.checkBoxArray.length < 1)){
		displayWait(false);
		disableFormEl(0, oIMGTable);
		return;
    }

    var tempDivId = oIMGTable.tableId + "_hid_chk";
    var tempDiv = document.getElementById(tempDivId);

    if (tempDiv != undefined) {
	tempDiv.parentNode.removeChild(tempDiv);
    }

    tempDiv = document.createElement('div');
    tempDiv.id = tempDivId;

    displayWait(false);
    oIMGTable.rows = 0;

    for (var i=1; i <= oIMGTable.total; i++) {
		var sArrVal = oIMGTable.checkBoxArray[i];
		if (!sArrVal)
		   continue;
	
		if (sArrVal.match(/\s+checked/gi)) {
		    oIMGTable.rows++;
		    var d = document.createElement('div')
		    var sChk = oIMGTable.checkBoxArray[i].replace("checkbox","hidden");
	
		    d.innerHTML = sChk;
		    var elOld = d.getElementsByTagName("input")[0];
		    tempDiv.appendChild(hidEl(elOld.name, elOld.value));
		}
	
		if (oIMGTable.rows == 1) {
		    oIMGTable.createBars();
		}
    }

    if (oIMGTable.isPBarsActive()) {
		oIMGTable.animate = true;
		oIMGTable.animateBars();
		oIMGTable.updateBars();
	
		if (oIMGTable.rows <= 0) {
		    disableFormEl(1, oIMGTable);
		    var sDelay = function () { clearPB(oIMGTable);};
		    oIMGTable.onBarsDone(sDelay, 500);
		} else {
		    oIMGTable.animate = false;
		    oIMGTable.animateBars();
		    if ( oIMGTable.form != null ) {
			oIMGTable.form.appendChild(tempDiv);		    	
		    }
		}
    }
}

function hasSelectCol(o) {
    var selCol = false;
    var cols =  o.myDataTable.getColumnSet().getDefinitions();
    for (var i=0; i < cols.length; i++) {
	// Check whether table has select column (checkboxes)?
	var selField = cols[i].label.match(/(^Select$|^Selection$)/gi);
	if (selField) {
	    o.selEl = o.myDataTable.getThLinerEl(selField[0]);
	    selCol = true;
	    break;
	}
    }
    return selCol;
}

function decodeEntities(encoded) {
    var div = document.createElement('div');
    div.innerHTML = encoded;
    var decoded = div.firstChild.nodeValue;
    return decoded;
}

function setFilt(oTable) {
    var curTable = oTable.tableId;
    var tableName = oTable.uniqueId;
    var col = document.getElementById(curTable + "_search-listA").value 
	   || oTable.col;
    var term = document.getElementById(curTable + "_search-inputA").value
	   || oTable.term || "";
    // The filter type dropdown box is hardcoded to "text|regex"; so check passed value first
    var type = oTable.type || document.getElementById(curTable + "_search-typeA").value
	   || "";
    if (oTable.pageLoad) {
	var obj = {};
	obj.table = tableName;
	getFilt(obj);
	if (obj.col) return;
    }
    document.cookie = tableName + "_filtcol=" + escape(col);
    document.cookie = tableName + "_filtterm=" + escape(term);
    document.cookie = tableName + "_filttype=" + escape(type);
}

function getFilt(o) {
    var arCk = document.cookie.split(";");
    for (var i=0;i < arCk.length;i++) {
	var x = arCk[i].substr(0,arCk[i].indexOf("="));
	var y = arCk[i].substr(arCk[i].indexOf("=")+1);
	x = x.replace(/^\s+|\s+$/g,"");
	if (x == o.table + "_filtcol") {
	    o.col = unescape(y);
	}
	if (x == o.table + "_filtterm") {
	    o.term = unescape(y);
	}
	if (x == o.table + "_filttype") {
	    o.type = unescape(y);
	}
    }
}

function setMissingFiltCol(o) {
    filtObj = o;
}
