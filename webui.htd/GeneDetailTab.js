// $Id: GeneDetailTab.js 29739 2014-01-07 19:11:08Z klchu $

// mutex object id
var NEXT_CMD_ID = 0;

// count number of tabs returned
var count = 0;

var numOfTabToLoad = 1; // default should be 1

var loadedMessage = "Loaded.";


var handleFailure = function(o) {
    //alert("Failure: " + o.statusText);
}

/*
 load tab pages
*/
function load(url, tabIndex, numOfTab, message) {
    numOfTabToLoad = numOfTab;
    loadedMessage = message;


    var handleSuccess = function(o) {
        var e = document.getElementById( o.argument.tab );
        try {
            e.innerHTML = o.responseText;
        } catch(error) {
         /*
         * IE does not like pages with forms with the same name
          */
            e.innerHTML = "Error in loading tabs inner html pages.";
            writeFile(o.responseText);
        }

        // param is func and inner function to call
        new Mutex(new AddCmd() ,"go");
    } 

    var callback = {
        success: handleSuccess,
        failure: handleFailure,
        timeout: 60000,
        argument: { tab: tabIndex } 
    }

    var request = YAHOO.util.Connect.asyncRequest('GET', unescape(url), callback); 
}

/* this is only for IE
write file to error
*/
function writeFile(text) {
    var browser = navigator.appName;
    if (browser == "Microsoft Internet Explorer") {
        try {
            var fso, s;
            fso = new ActiveXObject("Scripting.FileSystemObject");
            // 8=append, true=create if not exist, 0 = ASCII
            s = fso.OpenTextFile("C:\\errorLogFile.txt", 8, true,0);
            //fso.CreateFolder("C:\\test.txt", true);
            s.write(text);
            s.close();
            alert("Log file written C:\\errorLogFile.txt");
        }  catch(err){
            // ignore error
            var strErr = 'Error:';
            strErr += '\nNumber:' + err.number;
            strErr += '\nDescription:' + err.description;
            alert(strErr);            
        }
    }
}

function AddCmd() {
    // required for mutex object id
    this.id = ++NEXT_CMD_ID;
    this.go = function(){ 
        count++;
    
        //alert(count + "  id " + this.id);
        if(count >= numOfTabToLoad) {
            //alert(count + "  id " + this.id);
            var e = document.getElementById( 'status_line_z1' );
            if (e != null && e != "") {
                e.innerHTML = loadedMessage;
            }
        }
    }
}


/*
    for gene detail homolog page
*/
function selectHomolog(inner_cgi, gene_oid,  tabIndex ) {
//alert("here");
     ct = ctime( );
         var e = document.mainForm.homologSelection;
    var url = inner_cgi + "?section=GeneDetail&page=homologs&gene_oid="+ gene_oid +
     "&homologs=" + e.value;
    //window.open( url, 'Gene Details' );
    window.open( url, '_self' );

/*
    ct = ctime( );
    var e = document.mainForm.homologSelection;
    var url = inner_cgi + "?section=GeneDetail&page=homologs&gene_oid="+ gene_oid +
     "&homologs=" + e.value;
   
   //alert(tabIndex);
   
    var e = document.getElementById( tabIndex );
    e.innerHTML = "<font color='red'><blink>Loading ...</blink></font>";
     
    var handleSuccess1 = function(o) {
        var e = document.getElementById( tabIndex );
        e.innerHTML = o.responseText;
    } 
    
    var callback = {
        success: handleSuccess1,
        failure: handleFailure,
        timeout: 60000
    }
   
    var request = YAHOO.util.Connect.asyncRequest('GET', unescape(url), callback);
    */
}


// mutex.js 

function Map() {
	this.map = new Object();
	// Map API
	this.add = function(k, o) {
		this.map[k] = o;
	}
	this.remove = function(k) {
		delete this.map[k];
	}
	this.get = function(k) {
		return k == null ? null : this.map[k];
	}
	this.first = function() {
		return this.get(this.nextKey());
	}
	this.next = function(k) {
		return this.get(this.nextKey(k));
	}
	this.nextKey = function(k) {
		for (i in this.map) {
			if (!k)
				return i;
			if (k == i)
				k = null; /* tricky */
		}
		return null;
	}
}

function Mutex(cmdObject, methodName) {
	// define static variable and method
	if (!Mutex.Wait)
		Mutex.Wait = new Map();
	Mutex.SLICE = function(cmdID, startID) {
		Mutex.Wait.get(cmdID).attempt(Mutex.Wait.get(startID));
	}
	// define instance method
	this.attempt = function(start) {
		for ( var j = start; j; j = Mutex.Wait.next(j.c.id)) {
			if (j.enter
					|| (j.number 
                            && (j.number < this.number 
                                || (j.number == this.number 
                                    && j.c.id < this.c.id))))
				return setTimeout("Mutex.SLICE(" + this.c.id + "," + j.c.id
						+ ")", 10);
		}
		this.c[this.methodID](); // run with exclusive access
		this.number = 0; // release exclusive access
		Mutex.Wait.remove(this.c.id);
	}
	// constructor logic
	this.c = cmdObject;
	this.methodID = methodName;
	Mutex.Wait.add(this.c.id, this); // enter and number are "false"
	this.enter = true;
	this.number = (new Date()).getTime();
	this.enter = false;
	this.attempt(Mutex.Wait.first());
}
