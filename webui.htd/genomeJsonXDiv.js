var mySelects=["selectedGenome1",
               "selectedGenome2",
               "selectedGenome3"];
var errorMsg1=["Please select at least one Find In genome", 
               "Please select at least one With Query Genomes genome",
               "Please select at least one Without Query Genomes genome"];

var showOrHideArray = new Array(1);
var termLengthArray = new Array(1);


/**
 * Add button action
 * @param id
 * @param maxSelect - max number of genomes that can be added value of -1 it will ignore the max check
 *                    to be used for selection selectedGenome2 and selectedGenome3, selectedGenome1 is always max of 1
 * @param domainType - restrict add to domainType: '' (means all domains default), isolate, metagenome
 * @returns {Boolean}
 */
function addOption(id, maxSelect, domainType, form_id, autocomplete) {
    var x = document.getElementById(id);
    var select1 = document.getElementById('tax');
    var f = document.getElementById('displayType2').checked;
    //anna:var autoselect1 = document.getElementById('myGenomeSearchInput');
    if (form_id === undefined) { form_id = ''; }
    var asid = "myGenomeSearchInput"+form_id;
    var autoselect1 = document.getElementById(asid);

    if (form_id !== undefined && form_id != '' && form_id != null) {
        var startElement = document.getElementById(form_id);
        var els = startElement.getElementsByTagName("select");
        for (var i = 0; i < els.length; i++) {
            var e = els[i];
            if (e.id == "tax") {
                select1 = e;
            }
	    else if (e.id == id) {
		x = e;
	    }
        }
        var els = startElement.getElementsByTagName("input");
        for (var i = 0; i < els.length; i++) {
            var e = els[i];
            if (e.id == "displayType2") {
                f = e.checked;
            }
	    else if (e.id == asid) {
		autoselect1 = e;
	    }
        }
    }

    var count = 0;
    if (maxSelect != undefined && maxSelect != null && 
	maxSelect != '' && maxSelect > 0) {

        if (x != undefined && x != null) {
            var cnt = x.options.length;
            count = cnt;
            if (cnt >= maxSelect) {
                alert('You cannot select more than '+maxSelect+' genome(s).');
                return;
            }
        }
    }
    
    var errorMsg = '';    
    if (f) {
        // tree
        if (tree1 === undefined || tree1 == null) {
            alert("No genome(s) found.");
            return true;
        }        

        var hiLit = tree1.getNodesByProperty('highlightState', 1);
        if (YAHOO.lang.isNull(hiLit)) {
	    alert("Please select genome(s) to be added.");
            return true;
        } else {
            var cnt = 0;
            for ( var i = 0; i < hiLit.length; i++) {
                if (hiLit[i].children == '') {
                    // leaf node
                    var taxonOid = hiLit[i].labelElId
                    var taxonName = hiLit[i].label;
                    var boo = false;
                    for (var j=0; j<mySelects.length; j++ ) {
                        boo = boo || optionExists(mySelects[j], taxonOid);
                        if (boo == true) {
                            errorMsg = errorMsg + taxonName + '\n';
                            break;
                        }                        
                    }    
                    if (boo == false) {
                        if (maxSelect != undefined && maxSelect != null && 
			    maxSelect != '' && maxSelect > 0 && 
			    count >= maxSelect) {
                            alert('You can only select ' + maxSelect + ' genomes.');
                            break;                        
                        }
                        
                        // create new obejct
                        var option = document.createElement("option");
                        option.text = taxonName; // add to
                        option.value = taxonOid;
                        option.title = option.text;
                        if (isDomainType(domainType, taxonName)) {
                            try {
                                // for IE earlier than version 8
                                x.add(option,x.options[null]);
                            } catch (e) {
                                x.add(option,null);
                            }
                            cnt++;
                            count++;
                        } else {
                            alert('You can only add ' + domainType);
                        }
                    }                        
                }
            }
	    
	    if (cnt == 0 && errorMsg != '') {
		alert("Please select genome(s) to be added.");
	    }
        }

    } else if (autoselect1 != null && autoselect1 !== undefined && 
	       autoselect1 != '' && 
	       autoselect1.value !== undefined && 
	       autoselect1.value != '') {

	// create new object
	var option = document.createElement("option");
	option.text = autoselect1.value;
	option.value = ':'+autoselect1.value; // taxon_oid not known
	option.title = autoselect1.value;
	try {
	    x.add(option, x.options[null]);
	} catch (e) {
	    x.add(option,null);
	}
	autoselect1.value = "";

    } else {
        if ( select1.length > 0 ) {
            var cnt = 0;
	    for (var i = 0; i < select1.length; i++) {
		if (select1.options[i].selected) {
		    var v = select1.options[i].value;
		    var boo = false;
		    for (var j=0; j<mySelects.length; j++ ) {
	                // check if genome already selected
	                // any trues we'll reject the add
	                // it will still add those genomes not added already if
	                // multi-select included previously added genomes
			boo = boo || optionExists(mySelects[j], v);
			if (boo == true) {
			    errorMsg = errorMsg + select1.options[i].text + '\n';
			    break;
			}
		    }
	            
		    if (boo == false) {
			if (maxSelect != undefined && maxSelect != null && 
			    maxSelect != '' && maxSelect > 0 && 
			    count >= maxSelect) {
			    alert('You can only select ' + maxSelect + ' genomes.');
			    break;                        
			}
	                    
			// create new object
			var option = document.createElement("option");
			option.text = select1.options[i].text;
			option.value = select1.options[i].value;
			option.title = option.text;
	                    
			if (isDomainType(domainType, select1.options[i].text)) {
			    try {
				// for IE earlier than version 8
				x.add(option,x.options[null]);
			    } catch (e) {
				x.add(option,null);
			    }
			    cnt++;
			    count++;
			} else {
			    alert('You can only add ' + domainType);
			}
		    }
		}
	    }
	        
	    if (cnt == 0) {
		alert("Please select genome(s) to be added.");
	    }
        }
        else {
            alert("No genome(s) selected. To Add genomes use Quick Search or \nselect from the genomes on the left.");
        }
    }
    
    if (errorMsg != '') {
        alert("Genome(s) already added:\n" + errorMsg);
    }
    
    // update the count
    updateSelectedGenomeXCount(id, form_id);
}

function addAllOption(id, maxSelect, domainType, form_id) {
    var select1 = document.getElementById('tax');
    var f = document.getElementById('displayType2').checked;

    if (form_id !== undefined && form_id != '' && form_id != null) {
        var startElement = document.getElementById(form_id);
        var els = startElement.getElementsByTagName("select");
        for (var i = 0; i < els.length; i++) {
            var e = els[i];
            if (e.id == "tax") {
                select1 = e;
            }
            else if (e.id == id) {
                x = e;
            }
        }
        var els = startElement.getElementsByTagName("input");
        for (var i = 0; i < els.length; i++) {
            var e = els[i];
            if (e.id == "displayType2") {
                f = e.checked;
            }
        }
    }

    if (f) {
        // tree
        if (tree1 === undefined || tree1 == null) {
            alert("No genome(s) found.");
            return true;
        }

        var treeRoot = tree1.getRoot();
        if ( treeRoot === undefined || treeRoot == null ) {
            alert("No genome(s) found.");
            return true;
        }
        
        var topNodes = treeRoot.children;
        if ( topNodes.length > 0 ) {
            for ( var i = 0; i < topNodes.length; i++ ) {
            	topNodes[i].highlight();
            }
            genomeCountSelected(form_id);
            addOption(id, maxSelect, domainType, form_id);        	
        }
        else {
            alert("No genome(s) found.");
            return true;        	
        }
    }
    else {
    	//list
    	//var select1 = document.getElementById('tax');
	if (select1.length > 0) {
	    for (var i = 0; i < select1.length; i++) {
		if (select1.options[i] != undefined &&
		    select1.options[i] != null) {
		    select1.options[i].selected = true;
		}
	    }
	    genomeCountSelected(form_id);
	    addOption(id, maxSelect, domainType, form_id);         
	}
	else {
	    alert("No genome(s) found.");
	}
    }
}

function cartSelection(id, maxSelect, domainType) {
    var errorMsg = '';
    var cart = document.getElementById('use_all_cart').checked;
    var domains = document.getElementById('domainfilter');
    var selected_domain;
    for (var i = 0; i < domains.length; i++) {
	if (domains.options[i].selected) {
	    selected_domain = domains.options[i].value;
	}
    }

    if (!cart && selected_domain == "cart") {
	selectAllOption(id);
	return;
    }

    var count = 0;
    if (maxSelect != undefined && maxSelect != null &&
        maxSelect != '' && maxSelect > 0) {

        var x = document.getElementById(id);
        if (x != undefined && x != null) {
            var cnt = x.options.length;
            count = cnt;
            if (cnt >= maxSelect) {
                alert('You cannot select more than ' + maxSelect + ' genome(s).');
                return;
            }
        }
    }

    if (cart && selected_domain == "cart") { // add all items in cart
        var select1 = document.getElementById('tax');
        var cnt = 0;
        for (var i = 0; i < select1.length; i++) {
	    var v = select1.options[i].value;
	    var found = false;
	    for (var j=0; j<mySelects.length; j++ ) {
		found = found || optionExists(mySelects[j], v);
		if (found == true) {
		    errorMsg = errorMsg + select1.options[i].text + '\n';
		    break;
		}
	    }

	    if (found == false) {
		if (maxSelect != undefined && maxSelect != null &&
                        maxSelect != '' && maxSelect > 0 &&
		    count >= maxSelect) {
		    alert('You can only select ' + maxSelect + ' genomes.');
		    break;
		}

		var x = document.getElementById(id);
		var option = document.createElement("option");
		option.text = select1.options[i].text;
		option.value = select1.options[i].value;
		option.title = option.text;

		if (isDomainType(domainType, select1.options[i].text)) {
		    try {
			x.add(option,x.options[null]);
		    } catch (e) {
			x.add(option,null);
		    }
		    cnt++;
		    count++;
		} else {
		    alert('You can only add ' + domainType);
		}
	    }
        }
    }
}



/**
 * check the domain type
 * @param domainType
 * @param text
 */
function isDomainType(domainType, text) {
    if (domainType == null || domainType == '') {
        return true;
    }
    
    var n;
    if (domainType == 'isolate') {
        // (A), (B), (E), (G), (P), (V)
        var types = ['(A)', '(B)', '(E)', '(G)', '(P)', '(V)'];
        for (var i=0;i<types.length;i++) {
            n = text.indexOf(types[i]);
            if (n > -1) {
                break;
            }
        }
    } else {
        // domainType == 'metagenome'
        n = text.indexOf('(*)');
    }
    
    if (n > -1) {
        return true;
    } else {
        return false;
    }
}


/**
 * update selected genome section 2 or 3 count
 * @param id
 */
function updateSelectedGenomeXCount(id, form_id) {
    if (id == 'selectedGenome1' || id == 'selectedGenome2' ||
	id == 'selectedGenome3') {
        var obj = document.getElementById(id + 'Counter');
        if (obj != undefined && obj != null) {
            var selectX = document.getElementById(id);
            var cnt = selectX.length;
            var cntText;
            if ( id == 'selectedGenome1' ) {
            	cntText = cnt + " selected";
            }
            else {
            	cntText = cnt;         	
            }
	    if ( cnt > 0 ) {
            	obj.innerHTML = cntText; 
	    }
	    else {
            	obj.innerHTML = '';            		
	    }
        }
    }    
}

function optionExists(id, opt) {
    var x = document.getElementById(id);
    if (x == null) {
        return false;
    }
    for (var i = 0; i < x.options.length; i++) { 
        var v = x.options[i].value;
        if (opt == v ) {
            return true;
        }
    } 
    return false;
}

function uploadOption(xmlCgiUrl, id, form_id) {
    var url = xmlCgiUrl + "?section=ANI&page=selectFiles";
    showDialog(url, id);
}

function uploadFileOption(files, id, form_id) {
    var select = document.getElementById(id);
    if (select == null || select === undefined) {
        alert("ERROR: cannot find html element - select box!");
        return;
    }

    for (var i = 0; i < files.length; i++) {
	var f = files[i];
	var val = escape(f.name);
        var opt = document.createElement("option");
        opt.value = "local:" + f.name;
        opt.innerHTML = f.name;
        select.appendChild(opt);
    }
}

/*
 * to remove options object start with the last one and work our way up to
 * remove objects
 */
function removeOption(id, form_id) {
    var x = document.getElementById(id);
    if ( x.length > 0 ) {
	var removeCnt = 0;
	for (var i = x.length - 1; i>=0; i--) {
	    if (x.options[i].selected) {
		x.remove(i);
		removeCnt++;
	    }
	}
	    
	// update the count
	updateSelectedGenomeXCount(id, form_id);
	    
	if (removeCnt == 0) {
	    alert("Please select genome(s) to be removed.");
	}
    }
    else {
        alert("No genome(s) to remove. To remove a genome, \nfirst select it and then press the Remove button.");    	
    }
}

function removeAllOption(id, form_id) {
    var r = confirm("Are you sure you want to remove all the already selected genomes?");
    if (r == false) {
    	return;
    }

    var x = document.getElementById(id);
    if ( x.length > 0 ) {
	for (var i = x.length - 1; i>=0; i--) {
	    if ( x.options[i] != undefined && x.options[i] != null ) {
		x.remove(i);
	    }
	}
	
	// update the count
	updateSelectedGenomeXCount(id, form_id);
    }
    else {
        alert("No genome(s) selected.");    	
    }
}

/*
 * select all the genomes before the form is submitted
 */
function selectAllOption() {
    //alert("into selectAllOption()");
    for (var j=0; j<mySelects.length; j++ ) {
        var selectBox = document.getElementById(mySelects[j]);
        if (selectBox == null) {
            continue;
        }
        if (selectBox.options.length < 1) {
            // alert(errorMsg1[j]);
            // return false;
            continue;
        } else if (selectBox.options.length == 1) {
            selectBox.options[0].selected = true;
            continue;
        } else if (selectBox.type == "select-multiple") { 
            for (var i = 0; i < selectBox.options.length; i++) { 
                 selectBox.options[i].selected = true; 
            } 
        }    
    }    
    return true;
}

function resetForm() {
    for (var j=0; j<mySelects.length; j++ ) {
        var selectBox = document.getElementById(mySelects[j]);
        if (selectBox == null) {
            continue;
        }        
        if (selectBox.options != null) {
            selectBox.options.length = 0;  // That's it!
        }   
    }
}

function myCheckBeforeSubmit(id1, minSelect1, id2, minSelect2) {

	if (minSelect1 == undefined || minSelect1 == null || minSelect1 == '') {
		minSelect1 = 0;
	}
	if (minSelect2 == undefined || minSelect2 == null || minSelect2 == '') {
		minSelect2 = 0;
	}
	
	if (minSelect1 > 0) {
	    var x = document.getElementById(id1);
		var y = document.getElementById("one"); // see if visible
		var z = document.getElementById("genomeFilterArea"); 
	
		if (x != undefined && x != null &&
		    y != null && y.style.display != 'none') {
		    var cnt = x.options.length;
		
		    if (cnt < minSelect1) {
			    //if (z != undefined && z != null &&
				//z.style.display == 'none') {
				var toHide = checkForYesOrNo('toHide', showOrHideArray);
				if (toHide) {
				}
				else {
			        alert('Please select at least ' + 
					 minSelect1 + ' query genome(s).');
			        return false;
				}
		     }
		 }
	}
	
	if (minSelect2 > 0) {
	    var x = document.getElementById(id2);
		if (x != undefined && x != null) {
		    var cnt = x.options.length;
		    if (cnt < minSelect2) {
		        alert('Please select at least ' + 
			      minSelect2 + ' reference genome(s).');
		        return false;
		    }
		}
	}
	
	if ( validateBeforeSubmit() == false ) {
		return false;
	}

	selectAllOption();
	
	return true;
}

function mySubmitWithCheck(section, page, id1, minSelect1, 
			   id2, minSelect2, form_id) {
    if (minSelect1 == undefined || minSelect1 == null || minSelect1 == '') {
    	minSelect1 = 0;
    }
    if (minSelect2 == undefined || minSelect2 == null || minSelect2 == '') {
    	minSelect2 = 0;
    }

    if (minSelect1 > 0) {
        var x = document.getElementById(id1);
		var y = document.getElementById("one"); // see if visible
		var z = document.getElementById("genomeFilterArea"); 

        if (x != undefined && x != null &&
	    y != null && y.style.display != 'none') {
            var cnt = x.options.length;

            if (cnt < minSelect1) {
				//if (z != undefined && z != null &&
				//z.style.display == 'none') {
				var toHide = checkForYesOrNo('toHide', showOrHideArray);
				if (toHide) {
				}
				else {
			           alert('Please select at least ' + 
					 minSelect1 + ' query genome(s).');
			           return;
				}
            }
        }
    }

    if (minSelect2 > 0) {
        var x = document.getElementById(id2);
        if (x != undefined && x != null) {
            var cnt = x.options.length;
            if (cnt < minSelect2) {
                alert('Please select at least ' + 
		      minSelect2 + ' reference genome(s).');
                return;
            }
        }
    }

    if ( validateBeforeSubmit() == false ) {
    	return;
    }
    
    mySubmitJsonXDiv(section, page, form_id);
}

function mySubmitJsonXDiv(section, page, form_id) {
    selectAllOption();

    var myForm = document.mainForm;
    if (form_id !== undefined && form_id != '' && form_id != null) {
        myForm = document.getElementById(form_id);
    }

    if (section != '') {
        myForm.section.value = section;
    }
    if (page != '') {
        myForm.page.value = page;
    }
    myForm.submit();    
}

function checkForYesOrNo(id, yesArray) {
    var obj = document.getElementById(id);
    if ( obj != undefined && obj != null ) {
        var selectedVal = obj.options[obj.selectedIndex].value;
        if ( yesArray != undefined && yesArray != null && yesArray != '' ) {
            for (var i=0; i<yesArray.length; i++) {
                if ( yesArray[i] != undefined && yesArray[i] != null 
		     && yesArray[i] != '' ) {
		    for (var j=0; j<yesArray[i].length; j++) {
			if (selectedVal == yesArray[i][j]) {
			    return true;
			}
		    }
                }
            }        	
        }
    }
    return false;
}

function determineHideDisplayType(triggerHideId, hideAreaId) {
    if (document.getElementById(hideAreaId) != null) {
        var toHide = checkForYesOrNo(triggerHideId, showOrHideArray);
        if (toHide) {
            document.getElementById(hideAreaId).style.display = 'none';
        }
        else {
	    if ( endsWith(hideAreaId, 'TableRow') ) {
                document.getElementById(hideAreaId).style.display = 'table-row';
	    }
	    else {
                document.getElementById(hideAreaId).style.display = 'block';        		
	    }
        }
    }
}

function determineHideDisplayTypeAtMultiTriggers(triggerHideIdArray, hideAreaId) {
    if (document.getElementById(hideAreaId) != null) {
        var toHide;
        for (var i = 0; i < triggerHideIdArray.length; i++) {
            toHide = checkForYesOrNo(triggerHideIdArray[i], showOrHideArray);
            if ( toHide ) {
            	break;
            }
        }
        if (toHide) {
            document.getElementById(hideAreaId).style.display = 'none';
        }
        else {
	    if ( endsWith(hideAreaId, 'TableRow') ) {
                document.getElementById(hideAreaId).style.display = 'table-row';
	    }
	    else {
                document.getElementById(hideAreaId).style.display = 'block';        		
	    }
        }
    }   
}

function determineShowDisplayType(triggerShowId, showAreaId) {
    if (document.getElementById(showAreaId) != null) {
        var toShow = checkForYesOrNo(triggerShowId, showOrHideArray);
        if (toShow) {
	    if ( endsWith(showAreaId, 'TableRow') ) {
	        document.getElementById(showAreaId).style.display = 'table-row';
	    }
	    else {
	        document.getElementById(showAreaId).style.display = 'block'; 
	    }
        }
        else {
            document.getElementById(showAreaId).style.display = 'none';
        }
    }
}

function determineShowDisplayTypeAtMultiTriggers(triggerShowIdArray, showAreaId) {
    if (document.getElementById(showAreaId) != null) {
        var toShow;
        for (var i = 0; i < triggerShowIdArray.length; i++) {
            toShow = checkForYesOrNo(triggerShowIdArray[i], showOrHideArray);
            if ( toShow ) {
            	break;
            }
        }
        if (toShow) {
	    if ( endsWith(showAreaId, 'TableRow') ) {
	        document.getElementById(showAreaId).style.display = 'table-row'; 
	    }
	    else {
	        document.getElementById(showAreaId).style.display = 'block'; 
	    }
        }
        else {
            document.getElementById(showAreaId).style.display = 'none';
        }
    }
}


function determineHideShowDisplayType(triggerHideId, hideAreaId, showAreaId) {
    if (document.getElementById(hideAreaId) != null) {
        var toHide = checkForYesOrNo(triggerHideId, showOrHideArray);
        if (toHide) {
            document.getElementById(hideAreaId).style.display = 'none';
	    if ( endsWith(showAreaId, 'TableRow') ) {
	        document.getElementById(showAreaId).style.display = 'table-row';
	    }
	    else {
	        document.getElementById(showAreaId).style.display = 'block';
	    }
        }
        else {
	    if ( endsWith(hideAreaId, 'TableRow') ) {
	        document.getElementById(hideAreaId).style.display = 'table-row';
	    }
	    else {
	        document.getElementById(hideAreaId).style.display = 'block'; 
	    }
            document.getElementById(showAreaId).style.display = 'none';
        }
    }
}

function validateBeforeSubmit() {
    var id = 'searchTerm';
    if (document.getElementById(id) != null) {
        var toValidateLength = checkForYesOrNo('toHide', termLengthArray);
        if (toValidateLength) {
		    var value = document.getElementById(id).value;
		    if ( value != null && value.length < 4 ) {
	                alert("Please enter a search term at least 4 characters long.");
	                return false;
		    }
        }
    }

    return true;
}

function endsWith(str, suffix) {
    return str.indexOf(suffix, str.length - suffix.length) !== -1;
}

