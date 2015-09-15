function chomp(raw_text) {
  var patt = /(\n|\r)+$/;
  return raw_text.replace(patt, '');
}

function isBlank(str) {
    return (!str || /^\s*$/.test(str));
}