function switchMenu(obj, header) {
var el = document.getElementById(obj);
var hd = document.getElementById(header);

if ( el.style.display != 'none' ) {
   el.style.display = 'none';
   hd.style.backgroundImage = "url('/images/expand.png')";
}

else {
   el.style.display = '';
   hd.style.backgroundImage = "url('/images/collapse.png')";
}

}

