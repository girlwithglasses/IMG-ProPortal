
/*
 * validate email address
 */
function testEmail(emailStr) {
	//var emailRegEx = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i;
	//var emailRegEx = /^[a-zA-Z]([a-zA-Z0-9-_])*(\.[a-zA-Z0-9-_])*@[a-zA-Z0-9](([a-zA-Z0-9\-\_\.])*)+\.[a-zA-Z]{2,4}$/;
    //var emailRegEx = /^[\\w-_\.+]*[\\w-_\.]\@([\\w]+\\.)+[\\w]+[\\w]$/i;
	//var emailRegEx = /^((\w+\+*\-*)+\.?)+@((\w+\+*\-*)+\.?)*[\w-]+\.[a-z]{2,6}$/i;
	var emailRegEx = /^\s*[\w\-\+_]+(\.[\w\-\+_]+)*\@[\w\-\+_]+\.[\w\-\+_]+(\.[\w\-\+_]+)*\s*$/;
    return emailRegEx.test(emailStr);
}

/*
 * as the user types only allow [0-9] values use it on event onKeyPress="return
 * numbersonly(event, numType)"
 * numType: 0=integer, 1=none-negative number 2=any number
 */
function numbersonly(e, numType) {
	var key;
	if (window.event) {
		key = window.event.keyCode;
	} else if (e) {
		key = e.which;
	} else {
		return true;
	}

	var keychar = String.fromCharCode(key);
	// control keys
	if ((key == null) || (key == 0) || (key == 8) || (key == 9) || (key == 13)
			|| (key == 27)) {
		return true;
	} else {
		// numbers
		if ( numType == 0 ) {
			if ((("0123456789").indexOf(keychar) > -1)) {
				return true;
			}			
		}
		else if ( numType == 1 ) {
			if (((".0123456789").indexOf(keychar) > -1)) {
				return true;
			}			
		}
		else if ( numType == 2 ) {
			if ((("-.0123456789").indexOf(keychar) > -1)) {
				return true;
			}
		}
	}
	return false;
}
