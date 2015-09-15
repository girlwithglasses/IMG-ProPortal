function validateGeneSelection(num, myid) {
    var startElement = document.getElementById(myid);
    var els = startElement.getElementsByTagName('input');

    var count = 0;
    for (var i = 0; i < els.length; i++) {
	var e = els[i];

	if (e.type == "checkbox" &&
	    e.name == "gene_oid" &&
	    e.checked == true) {
	    count++;
	}
    }

    if (count < num) {
	if (num == 1) {
	    alert("Please select some genes");
	} else {
	    alert("Please select at least "+num+" genes");
	}
	return false;
    }

    return true;
}

function validateBCSelection(num, myid) {
    var startElement = document.getElementById(myid);
    var els = startElement.getElementsByTagName('input');

    var count = 0;
    for (var i = 0; i < els.length; i++) {
	var e = els[i];

	if (e.type == "checkbox" &&
	    (e.name == "cluster_id" || e.name == "bc_id") &&
	    e.checked == true) {
	    count++;
	}
    }

    if (count < num) {
	if (num == 1) {
	    alert("Please select some bcs");
	} else {
	    alert("Please select at least "+num+" bcs");
	}
	return false;
    }

    return true;
}

function validateScaffoldSelection(num, myid) {
    var startElement = document.getElementById(myid);
    var els = startElement.getElementsByTagName('input');

    var count = 0;
    for (var i = 0; i < els.length; i++) {
	var e = els[i];

	if (e.type == "checkbox" &&
	    e.name == "scaffold_oid" &&
	    e.checked == true) {
	    count++;
	}
    }

    if (count < num) {
	if (num == 1) {
	    alert("Please select some scaffolds");
	} else {
	    alert("Please select at least "+num+" scaffolds");
	}
	return false;
    }

    return true;
}

function validateItemSelection(min, max, myid, myname) {
    var startElement = document.getElementById(myid);
    var els = startElement.getElementsByTagName('input');

    var count = 0;
    for (var i = 0; i < els.length; i++) {
        var e = els[i];

        if (e.type == "checkbox" &&
            e.name == myname &&
            e.checked == true) {
            count++;
        }
    }

    if (min != undefined && min != null && min != '' && count < min) {
        if (min == 1) {
            alert("Please select some items");
        } else {
            alert("Please select at least "+min+" items");
        }
        return false;

    } else {
	if (max != undefined && max != null && max != '' && count > max) {
            alert("Please select no more than "+max+" items");
	    return false;
	}
    }

    return true;
}

function validateTextItemSelection(num, myid, myname) {
    var startElement = document.getElementById(myid);
    var els = startElement.getElementsByTagName('input');

    var count = 0;
    for (var i = 0; i < els.length; i++) {
        var e = els[i];

        if (e.type == "text" &&
            e.name == myname && 
	    e.value != '') {
            count++;
        }
    }

    if (count < num) {
        if (num == 1) {
            alert("Please select some items");
        } else {
            alert("Please select at least "+num+" items");
        }
        return false;
    }

    return true;
}

