// Hollywood Fringe namespace
var HWF = {};

 function adjustTextarea(textarea, collapsed) {
  var lines = textarea.value.split("\n");
  var count = lines.length;
  lines.each(function(line) { count += parseInt(line.length / 70); });

  var rows = parseInt(collapsed / 20);

  if (count > rows) {
    textarea.style.height = (collapsed * 2) + 'px';
  }

  if (count <= rows) {
    textarea.style.height = collapsed + 'px';
  }
}

HWF.hasConsole = window.console && window.console.log;
HWF.log = function(text) {
  if(!text)
    return false;
  if(HWF.hasConsole)
    window.console.log(text.toString());
}// end function HWF.log()
