/**
 * $Id: questions.js 29739 2014-01-07 19:11:08Z klchu $
 */

function validateForm(charNumLimit) {
    var f = document.mainForm;
    var subject = f.subject.value;
    var message = f.message.value;
    var name = f.name.value;
    var email = f.email.value;
    var error = "";
    
    if (name.replace(/\s/g, "") == "" || name == undefined) {
        error = "Name cannot be blank <br/>";
    }
    if (name.length > charNumLimit){
        error = error + "Name too long. Must be "+ charNumLimit + " characters or less <br/>";
    }
    
    if (email.replace(/\s/g, "") == "" || email == undefined) {
        error = error + "Email cannot be blank <br/>";
    }
    if (email.length > charNumLimit){
        error = error + "Email too long. Must be "+ charNumLimit + " characters or less <br/>";
    }
    
    if (subject.replace(/\s/g, "") == "" || subject == undefined) {
        error = error + "Subject cannot be blank <br/>";
    }
    if (subject.length > charNumLimit){
        error = error + "Subject too long. Must be "+ charNumLimit + " characters or less <br/>";
    }

    if (message.replace(/\s/g, "") == "" || message == undefined) {
        error = error + "Message cannot be blank <br/>";
    }
    if (message.length > charNumLimit){
        error = error + "Message too long. Must be "+ charNumLimit + " characters or less <br/>";
    }
    
    
    if (error != "") {
        document.getElementById("error").style.display = "block";
        var e = document.getElementById('error_id');
        e.innerHTML = "<p> <font color='red'>" + error + " </font></p>";
        return false;
    }
    return true;
}

/*
 * limit text size as user types
 */
function limitText(limitField, charNumLimit) {
    if (limitField.value.length > charNumLimit) {
        limitField.value = limitField.value.substring(0, charNumLimit);
    } 
}
