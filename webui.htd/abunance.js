/*
 $Id: abunance.js 31889 2014-09-11 02:20:09Z jinghuahuang $
 */

// document element start location of in radio button
var inbutton = 11;
// document element start location of over radio button
var overbutton = 12;
// document element start location of under radio button
var underbutton = 13;

// max number of in selections
var maxin = 1;
// max number of over selections
var maxover = 10;
// max number of under selections
var maxunder = 10;

/*
 * When user selects a radio button highlight in blue, 'a parent taxon' not a
 * child / leaf taxon param begin item number offest by inbutton param end last
 * radio button param offset which column param type which column type
 */
function selectAbunaceGroupProfile(begin, end, offset, type) {
	var f = document.mainForm;
	var count = 0;
	var idx1 = begin * 4;
	var idx2 = end * 4;
	for ( var i = idx1; i < f.length && i < idx2; i++) {
		var e = f.elements[i + inbutton];
		if (e.type == "radio" && i % 4 == offset) {
			e.checked = true;
		}
	}

	/*
	 * now count the number of leafs selected max is 10
	 */
	if (type == 'in' && !checkIncount(null)) {
		/*
		 * for( var i = idx1; i < f.length && i < idx2; i++ ) { var e =
		 * f.elements[ i + 7]; if( e.type == "radio" && i % 4 == offset ) {
		 * e.checked = false; } }
		 */
		selectAbunaceGroupProfile(begin, end, 3, 'ignore');
	} else if (type == 'over' && !checkOvercount(null)) {
		/*
		 * for( var i = idx1; i < f.length && i < idx2; i++ ) { var e =
		 * f.elements[ i + 7]; if( e.type == "radio" && i % 4 == offset ) {
		 * e.checked = false; } }
		 */
		selectAbunaceGroupProfile(begin, end, 3, 'ignore');
	} else if (type == 'under' && !checkUndercount(null)) {
		/*
		 * for( var i = idx1; i < f.length && i < idx2; i++ ) { var e =
		 * f.elements[ i + 7]; if( e.type == "radio" && i % 4 == offset ) {
		 * e.checked = false; } }
		 */
		selectAbunaceGroupProfile(begin, end, 3, 'ignore');
	}
}

/*
 * obj - is the radio button element object - it can be null, when call from a
 * group taxon, see selectAbunaceGroupProfile(...);
 * 
 * 
 * See AbundanceProfileSearch.pm for the hard code '10' check method
 * printAbundanceProfileRun(...)
 */
function checkIncount(obj) {
	var f = document.mainForm;
	var count = 0;

	// I KNOW where the objects are located in the form
	for ( var i = inbutton; i < f.length; i = i + 4) {
		var e = f.elements[i];
		var name = e.name;
		if (e.type == "radio" && e.checked == true
				&& name.indexOf("profile") > -1) {
			// alert("radio button is checked " + name);
			count++;
			if (count > maxin) {
				alert("Please select only " + maxin + " genome");
				if (obj != null) {
					// i know which taxon leaf to un-check
					obj[0].checked = false;
					obj[3].checked = true;
				}
				return false;
				// break;
			}
		}
	}
	return true;
}

/*
 * See AbundanceProfileSearch.pm for the hard code '10' check method
 * printAbundanceProfileRun(...)
 */
function checkOvercount(obj) {
	var f = document.mainForm;
	var count = 0;

	// I KNOW where the objects are located in the form
	for ( var i = overbutton; i < f.length; i = i + 4) {
		var e = f.elements[i];
		var name = e.name;
		if (e.type == "radio" && e.checked == true
				&& name.indexOf("profile") > -1) {
			// alert("radio button is checked " + name);
			count++;
			if (count > maxover) {
				alert("Please select " + maxover + " or less genomes");
				if (obj != null) {
					obj[1].checked = false;
					obj[3].checked = true;
				}
				return false;
				// break;
			}
		}
	}
	return true;
}

/*
 * See AbundanceProfileSearch.pm for the hard code '10' check method
 * printAbundanceProfileRun(...)
 */
function checkUndercount(obj) {
	var f = document.mainForm;
	var count = 0;

	// I KNOW where the objects are located in the form
	for ( var i = underbutton; i < f.length; i = i + 4) {
		var e = f.elements[i];
		var name = e.name;
		if (e.type == "radio" && e.checked == true
				&& name.indexOf("profile") > -1) {
			// alert("radio button is checked " + name);
			count++;
			if (count > maxunder) {
				alert("Please select " + maxunder + " or less genomes");
				if (obj != null) {
					obj[2].checked = false;
					obj[3].checked = true;
				}
				return false;
				// break;
			}
		}
	}
	return true;
}

/*
 * disable or enable the show results buttons based on the normalization
 * selected
 */
function setDisableShowResult(enable) {
	if (enable) {
		document.mainForm.showresult[0].checked = true;
	} else {
		document.mainForm.showresult[2].checked = true;
	}
	document.mainForm.showresult[0].disabled = enable;
	document.mainForm.showresult[1].disabled = enable;
	document.mainForm.showresult[2].disabled = enable;
}

/*
 * when the users select a norm type the onclick will call this method to enable
 * or disable some field in the form.
 * 
 * Note in perl cgi disabled components return undefined values
 */
function normTypeAction(enable) {
	// sets show results value
	setDisableShowResult(enable);

	// sets cut off boxes
	if (document.mainForm.doNormalization[0].checked
			|| document.mainForm.doNormalization[1].checked) {
		document.mainForm.overabundant.disabled = false;
		document.mainForm.underabundant.disabled = false;
	} else {
		document.mainForm.overabundant.value = 1;
		document.mainForm.underabundant.value = 1;
		document.mainForm.overabundant.disabled = true;
		document.mainForm.underabundant.disabled = true;
	}
}
