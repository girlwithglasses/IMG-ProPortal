function showFilter(x, url) {
    var me;
    var icon = document.getElementById('plus_minus_span' + x);
    
    if(x == 1) {
        me = document.getElementById('genomeField');
    } else if(x == 2) {
        me = document.getElementById('projectMetadata');
    } else if(x == 3) {
        me = document.getElementById('sampleMetadata');
    } else if(x == 4) {
        me = document.getElementById('statistics');    
	} else if(x == 5) {
	    me = document.getElementById('geneField');
	} else if(x == 6) {
	    me = document.getElementById('scaffoldField');
	} else if(x == 7) {
	    me = document.getElementById('functionField');
	}

    if (me.style.display == "none" || me.style.visibility == 'hidden'){
        me.style.display="block";
        //me.style.visibility = 'visible';
        icon.innerHTML = "<img id='plus_minus" + x + "' alt='close' src='" + url + "/images/elbow-minus-nl.gif' />";
    } else {
        me.style.display = "none";
        //me.style.visibility = 'hidden';
        icon.innerHTML = "<img id='plus_minus" + x + "' alt='open' src='" + url + "/images/elbow-plus-nl.gif' />";
    }        
    
}


function selectObject(x, name) {
    var f = document.mainForm;
    for ( var i = 0; i < f.length; i++) {
        var e = f.elements[i];
        if (e.type == "checkbox" && e.name == name && e.id != 'always_checked') {
            e.checked = (x == 0 ? false : true);
        }
    }    
}

function selectCount(x) {
    var f = document.mainForm;
    for ( var i = 0; i < f.length; i++) {
        var e = f.elements[i];
        if (e.type == "checkbox" && e.id == "count" && e.value != 'ts.total_bases' && e.value != 'ts.total_gene_count') {
            e.checked = (x == 0 ? false : true);
        }
    }    
}

function selectPercent(x) {
    var f = document.mainForm;
    for ( var i = 0; i < f.length; i++) {
        var e = f.elements[i];
        if (e.type == "checkbox" && e.id == "percent" && e.value != 'ts.total_bases' && e.value != 'ts.total_gene_count') {
            e.checked = (x == 0 ? false : true);;
        }
    }    
}

function selectCountPhylum(x) {
    var f = document.mainForm;
    for ( var i = 0; i < f.length; i++) {
        var e = f.elements[i];
        if (e.type == "checkbox" && e.id == "count" && e.value != 'sum(ts.total_bases)' && e.value != 'sum(ts.total_gene_count)') {
            e.checked = (x == 0 ? false : true);
        }
    }    
}
