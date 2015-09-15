var svgNS = "http://www.w3.org/2000/svg";
var xlinkNS = "http://www.w3.org/1999/xlink";
var text1 = "ATGCTATGC" ;
var text2 = "ATGCTATGC" ;
var eid1 = "r1" ;
var eid2 = "r2" ;
var xgroup = "firstGroup1";
var ViewRead = "g_AXNY12826.x1" ;
var TrueCoords = null ;
var GrabPoint = null ;
var DragTarget = null ;
var BackDrop = null ;
var SVGDocument = null ;
var SVGRoot = null ;
var curZoom = 0 ;
var popOpen = false;
var nevents = 0 ;
//
 // all variables for drag pop window
 // 
 var bMouseDragging = false ;
// if true dragging reads windows
 var nMouseOffsetX = 0;
// X pos where the mouseDown
 var nMouseOffsetY = 0;
// Y pos where the mouseDown
 var curViewSX = 0;
// start position on chromosome 
 var curViewEX = 12232;
// end position on chromosome
 var curShift = 0;
// curent shift on contig view canvas 
 var tran = 0;
// curent transform
 var popX = 0 ;
//
 var popY = 0;
//
 //
 // 
var contig;
// defined in perl script - ken
 var readsPos;
var reads;
function mouseDown(evt) {
	bMouseDragging = true ;
	var rWin = document.getElementById("rP");
	if(rWin) {
		var p = document.documentElement.createSVGPoint() ;
		p.x = evt.clientX ;
		p.y = evt.clientY ;
		nMouseOffsetX = p.x ;
		nMouseOffsetY = p.y ;
//alert("mouseDown" + "Xcl=" + p.x+"  Ycl="+p.y);
//	var m = rWin.getScreenCTM() ;
//	    p = p.matrixTransform(m.inverse());
//	    nMouseOffsetX = p.x - parseInt(rWin.getAttribute("x"));
//	    nMouseOffsetY = p.y - parseInt(rWin.getAttribute("y"));
//	    //alert("mouseDown" + "   X=" + nMouseOffsetX +"  Y="+nMouseOffsetY);
 	}
}
//
 //
 function mouseUP(evt) {
	bMouseDragging = false ;
	nevents = 0;
}
function mouseMove(evt) {
	var p = document.documentElement.createSVGPoint() ;
	p.x = evt.clientX ;
	p.y = evt.clientY ;
//if (nevents < 5 ) { nevents += 1; return ;}
 	if(bMouseDragging) {
		var rWin = document.getElementById("readsCanvas");
//	      var m = rWin.getScreenCTM();
//	          p = p.matrixTransform(m.inverse());
 		var dx= p.x - nMouseOffsetX;
		var dy= p.y - nMouseOffsetY;
		rWin.setAttribute("transform","translate("+(popX+dx) +","+(popY+dy) +")");
//alert("mouseMove" + "   X=" + mx +"  Y="+my);
 //rWin.setAttribute("x",nMouseOffsetX);
 //rWin.setAttribute("y",p.y - nMouseOffsetY);
 		nevents = 0 ;
	}
}
//
 //
 //------------------------
 function init() {
	var rWin = document.getElementById("rP") ;
	if (rWin) {
//alert("init2");
 		rWin.addEventListener("mousedown",mouseDown,false);
		rWin.addEventListener("mouseup",mouseUP,false);
		rWin.addEventListener("mousemove",mouseMove,false);
		document.addEventListener("mouseup",mouseUP,false);
	}
}
//
 //
 // 
 function createView() {
	if (contig[4]) {
		curViewSX = contig[4] ;
	}
	if (contig[2] < 6000) {
		curViewEX = contig[2];
	} else {
		curViewEX = 6000;
	}
	createButton(100,20,20,30,"+","red","p");
	createButton(140,20,20,30,"-","blue","m");
	createButton(180,20,20,30,"scroll left","blue","sl");
	createButton(220,20,20,30,"scroll right","yellow","sr");
	createReference(150,100,contig,reads);
	createContigView(150,220,contig,readsPos,reads);
	createReadsView(20,60,contig,readsPos,reads);
	init() ;
}
function closReads() {
	var btarget = document.getElementById("readsCanvas");
	var readtarget = document.getElementById(ViewRead);
	btarget.setAttribute('display','none');
	readtarget.setAttribute('display','none');
	popOpen = false ;
}
function openReads(rname) {
	var p = document.documentElement.createSVGPoint() ;
	var p1 = document.documentElement.createSVGPoint() ;
	if(popOpen) {
		return 0 ;
	} else {
		popOpen = true ;
	}
	ViewRead = rname;
	var VNRead = rname.split("_") ;
	var pRead = document.getElementById("s_"+ VNRead[1]) ;
	var m = pRead.getScreenCTM() ;
	p1 = p1.matrixTransform(m.inverse());
	p.x = document.getElementById("s_"+ VNRead[1]).getAttribute("x");
	p.y = document.getElementById("s_"+ VNRead[1]).getAttribute("y");
	p1 = p.matrixTransform(m);
// alert("mouseDown" + "X =" + p1.x +"Y="+ p1.y + "raw X =" + p.x + "," + p.y );
 	var btarget = document.getElementById("readsCanvas");
	var rtarget = document.getElementById(rname) ;
	popX = (p1.x + 30) ;
	popY = (p1.y + 40) ;
	btarget.setAttribute("transform","translate("+popX +","+popY +")");
	btarget.setAttribute('display','inline');
	rtarget.setAttribute('display','inline');
}
function controlC(com) {
	if (com == 'c_sr') {
		scroll_right() ;
	}
	if (com == 'c_sl') {
		scroll_left() ;
	}
	if (com == 'c_p') {
		curZoom += 0.2;
		curShift += 40 ;
	}
	if (com == 'c_m') {
		curZoom -= 0.2;
		curShift -= 40 ;
	}
	if (curZoom > 0.9) {
		curZoom = 0.9;
		curShift -= 40;
	}
	if (curZoom < -0.8) {
		curZoom = 0;
		curShift = 0 ;
	}
	tran = 1-curZoom ;
//alert(com + ' has been turg tran =' + tran);
 	document.getElementById("firstGroup1").setAttributeNS(null,"transform","scale(" + tran + ")") ;
//"zoomCom('c_" + com + "')"
 //document.getElementById("readsCanvas").setAttributeNS(null,"transform","translate(500,500)");
 	document.getElementById("sgroup").setAttributeNS(null,"transform","translate(0"+","+curShift+")");
//document.getElementById("rP").setAttribute("x", 500);	
 }
function scroll_right() {
	alert ("scroll");
	curViewSX += 6000 ;
	if (curViewSX >= contig[2]) {
		curViewSX = contig[2] - 6000 ;
	}
	curViewEX += 6000 ;
	if (curViewEX >= contig[2]) {
		curViewEX = contig[2] ;
	}
}
function scroll_left() {
	curViewSX -= 6000 ;
}
function createRead(bp,rxt,ry,l,t,ch,txt,xid,group,vp) {
	var color = "red" ;
	var rx = rxt + bp ;
	var ex = rxt + l + bp;
	var ext = rxt + l;
	var ey = ry ;
	var s1x = rx + 5;
	var s1y = ry + 6 ;
	var e1x = ex ;
	var s2y = ry - 6 ;
	var s2x = rx + 5 ;
	var e2y = s2y;
	var ts = ry+ 5 ;
	var coor = "M "+rx.toString()+","+ry.toString()+" L "+s1x+","+s1y+" " ;
	coor = coor+"H "+e1x+" V "+e2y+"H "+s2x+" L "+rx.toString()+","+ry.toString() ;
	if(ch == 0) {
		color = "green" ;
		s1x = ex -5 ;
		s1y = ry + 6 ;
		s2x = s1x ;
		s2y = ry -6 ;
		coor = "M "+ rx+","+s1y+" H "+s1x+" L "+ex+","+ey+" L "+s2x+","+s2y+" ";
		coor = coor+"H "+rx+" V "+s1y ;
	}
	var newRead = document.createElementNS(svgNS,"path");
	newRead.setAttributeNS(null,"id",xid);
	newRead.setAttributeNS(null,"d",coor);
	newRead.setAttributeNS(null,"fill",color);
	newRead.setAttributeNS(null,"stroke","black");
	newRead.setAttributeNS(null,"transform","translate(0,0)");
	newRead.setAttributeNS(null,"opacity",".35");
	newRead.setAttributeNS(null,"stroke-width","2");
	newRead.setAttributeNS(null,"onclick","openReads('g_" + xid + "')");
	document.getElementById(group).appendChild(newRead);
	if(t == 1) {
		var newText = document.createElementNS(svgNS,"text");
		newText.setAttributeNS(null,"id","t_"+xid);
		newText.setAttributeNS(null,"x",4);
		newText.setAttributeNS(null,"y",ts);
		newText.setAttributeNS(null,"font-size","10px");
		newText.setAttributeNS(null,"transform","translate(0,0)");
		newText.setAttributeNS(null,"text-anchor","left");
		var data = document.createTextNode(txt);
		newText.appendChild(data);
		document.getElementById(group).appendChild(newText);
// rx value
 		var newText1 = document.createElementNS(svgNS,"text");
		newText1.setAttributeNS(null,"id","s_"+xid);
		newText1.setAttributeNS(null,"x",rx+2);
		newText1.setAttributeNS(null,"y",ts-14);
		newText1.setAttributeNS(null,"font-size","10px");
		newText1.setAttributeNS(null,"transform","translate(0,0)");
		newText1.setAttributeNS(null,"text-anchor","left");
//			   var data1 = document.createTextNode(rxt.toString());
 		var data1 = document.createTextNode(vp.toString());
		newText1.appendChild(data1);
		document.getElementById(group).appendChild(newText1);
// ex value
 		var newText2 = document.createElementNS(svgNS,"text");
		newText2.setAttributeNS(null,"id","e_"+xid);
		newText2.setAttributeNS(null,"x",ex+2);
		newText2.setAttributeNS(null,"y",ts+12);
		newText2.setAttributeNS(null,"font-size","10px");
		newText2.setAttributeNS(null,"transform","translate(0,0)");
		newText2.setAttributeNS(null,"text-anchor","left");
//			   var data2 = document.createTextNode(ext.toString());
 		var data2 = document.createTextNode((vp+ext-rxt).toString());
		newText2.appendChild(data2);
		document.getElementById(group).appendChild(newText2);
	}
}
//
 // create a read axis
 // and read name
 //
 function createAxis(bx,rx,ry,l,xid) {
//read name
 //var com = openRead() ;
 	var newText = document.createElementNS(svgNS,"text");
	newText.setAttributeNS(null,"id","r_"+xid);
	newText.setAttributeNS(null,"x",rx);
	newText.setAttributeNS(null,"y",ry);
	newText.setAttributeNS(null,"font-size","12px");
	newText.setAttributeNS(null,"transform","translate(0,0)");
	newText.setAttributeNS(null,"text-anchor","left");
	newText.setAttributeNS(null,"stroke","blue");
//newText.addEventListener("click",openReads,false);
 	newText.setAttributeNS(null,"onclick","openReads('g_" + xid + "')");
	var data = document.createTextNode(xid);
	newText.appendChild(data);
	document.getElementById("firstGroup1").appendChild(newText);
	var newAxis = document.createElementNS(svgNS,"line");
	newAxis.setAttributeNS(null,"id","x_"+xid);
	newAxis.setAttributeNS(null,"x1",bx);
	newAxis.setAttributeNS(null,"y1",ry);
	newAxis.setAttributeNS(null,"x2",bx+l);
	newAxis.setAttributeNS(null,"y2",ry);
	newAxis.setAttributeNS(null,"stroke","green");
	newAxis.setAttributeNS(null,"stroke-width","1");
//newAxis.setAttributeNS(null,"stroke-dasharray","10,10;");
 	newAxis.setAttributeNS(null,"transform","translate(0,0)");
	document.getElementById("firstGroup1").appendChild(newAxis);
}
function createAxis2(rx,ry,l,xid) {
//read name
 //var com = openRead() ;
 	var newAxis = document.createElementNS(svgNS,"line");
	newAxis.setAttributeNS(null,"id","xr_"+xid);
	newAxis.setAttributeNS(null,"x1",rx);
	newAxis.setAttributeNS(null,"y1",ry);
	newAxis.setAttributeNS(null,"x2",rx+l);
	newAxis.setAttributeNS(null,"y2",ry);
	newAxis.setAttributeNS(null,"stroke","red");
	newAxis.setAttributeNS(null,"stroke-width","1");
//newAxis.setAttributeNS(null,"stroke-dasharray","10,10;");
 	newAxis.setAttributeNS(null,"transform","translate(0,0)");
	document.getElementById(xid).appendChild(newAxis);
//edit: "firstGroup1 to xid
 	var newL1 = document.createElementNS(svgNS,"line");
	newL1.setAttributeNS(null,"id","xr1_"+xid);
	newL1.setAttributeNS(null,"x1",rx);
	newL1.setAttributeNS(null,"y1",ry-7);
	newL1.setAttributeNS(null,"x2",rx);
	newL1.setAttributeNS(null,"y2",ry+7);
	newL1.setAttributeNS(null,"stroke","red");
	newL1.setAttributeNS(null,"stroke-width","1");
//newAxis.setAttributeNS(null,"stroke-dasharray","10,10;");
 	newL1.setAttributeNS(null,"transform","translate(0,0)");
	document.getElementById(xid).appendChild(newL1);
//edit: "firstGroup1 to xid
 	var newL2 = document.createElementNS(svgNS,"line");
	newL2.setAttributeNS(null,"id","xr1_"+xid);
	newL2.setAttributeNS(null,"x1",rx+l);
	newL2.setAttributeNS(null,"y1",ry-7);
	newL2.setAttributeNS(null,"x2",rx+l);
	newL2.setAttributeNS(null,"y2",ry+7);
	newL2.setAttributeNS(null,"stroke","red");
	newL2.setAttributeNS(null,"stroke-width","1");
//newAxis.setAttributeNS(null,"stroke-dasharray","10,10;");
 	newL1.setAttributeNS(null,"transform","translate(0,0)");
	document.getElementById(xid).appendChild(newL2);
//edit: "firstGroup1 to xid
 	var newText1 = document.createElementNS(svgNS,"text");
	newText1.setAttributeNS(null,"id","rt_"+xid);
	newText1.setAttributeNS(null,"x",rx+l+3);
	newText1.setAttributeNS(null,"y",ry-8);
	newText1.setAttributeNS(null,"font-size","12px");
	newText1.setAttributeNS(null,"fill","red");
	newText1.setAttributeNS(null,"transform","translate(0,0)");
	newText1.setAttributeNS(null,"text-anchor","left");
	var data1 = document.createTextNode(l.toString());
	newText1.appendChild(data1);
	document.getElementById(xid).appendChild(newText1);
//edit: "firstGroup1 to xid
}
function createReference(rx,ry,xcontig,xreads) {
	var x =rx;
	var y =ry;
//createText(tx,ty,otext,color,size,id,group)
 //createLine(tx1,ty1,tx2,ty2,dasharray,color,size,id,group)
 	createText(x+200,y,"Contig - "+xcontig[0]+" size : " + xcontig[1]+ "   parts: " + (xreads.length)/5,"blue","18px","lable","firstGroup1");
	y = y+60;
//createLine(x,y,xcontig[2]+x-curViewSX,y,-1,"green",5,"refaxis","firstGroup1")
 	createLine(x,y,xcontig[2]+x,y,-1,"green",5,"refaxis","firstGroup1");
	var i = 0;
	var j = 0;
	var newArray = new Array();
	for (i=0; i < (xreads.length)/5; i++) {
// newArray[j] = xreads[0 + i*5] ;
 // j++;
 // newArray[j] = xreads[1 + i*5] ;
 // j++;
 // alert("curViewSX = " + curViewSX + " curViewEX =" + curViewEX);
 // alert("xread[2] = " + xreads[2 + i*5] + " xreads[3] =" + xreads[3 + i*5]);	 
 //if (xreads[2 + i*5] >= curViewSX && xreads[2 + i*5] <= curViewEX) {
 		newArray[j] = xreads[2 + i*5] ;
//alert("xread[2] = " + xreads[2 + i*5] );
 		j++;
//}
 //if (xreads[3 + i*5] >= curViewSX && xreads[3 + i*5] <= curViewEX) {
 		newArray[j] = xreads[3 + i*5] ;
//alert(" xreads[3] = " + xreads[3 + i*5]);
 		j++;
//}
 	}
//	alert("Array length = " + newArray.length);
 //
 // Sort array
 //
 	var index = 0;
	var l = 0;
	for (i=1;i<j;i++) {
		l = i;
		index = newArray[i] ;
		while ((l > 0) && (newArray[l-1] > index)) {
			newArray[l] = newArray[l-1] ;
			l = l-1;
		}
		newArray[l] = index;
	}
	var mar = newArray;
	var vp = -10 ;
	var lastV = 0 ;
	for (i = 0; i < j; i++) {
//createText(x+ i*30,y-30,mar[i],"black","11px","lable","firstGroup1");
 		if ((mar[i] - lastV) > 30) {
//if (vp == 15) { vp = -10; } else { vp = 15; }
 //createText(mar[i]+x+3,y+vp,mar[i],"black","10px","lable","firstGroup1");
 			createText(mar[i]+x+3-curViewSX,y+vp,mar[i],"black","10px","lable","firstGroup1");
			createLine(mar[i]+x-curViewSX,y-10,mar[i]+x-curViewSX,y+10,-1,"black",1,"rf","firstGroup1");
//createLine(mar[i]+x,y-10,mar[i]+x,y+10,-1,"black",1,"rf","firstGroup1");
 			lastV = mar[i] ;
		}
	}
	createLine(xcontig[2]+x,y,xcontig[2]+x+100,y,-1,"white",5,"refaxis","firstGroup1");
	createLine(xcontig[2]+x,y-10,xcontig[2]+x,y+10,-1,"black",1,"rf","firstGroup1");
	createText(xcontig[2]+x,y-10,xcontig[1],"black","10px","lable","firstGroup1");
}
function createContig2(arrContig,arrReads,arrParts) {
//
 //create reads
 //
 	var curRead = 0;
// current read
 	var curPart = 0;
// current part on read
 	var xid;
	var ry;
	var rx;
	var l;
//
 // create contig view
 //
 	var newText = document.createElementNS(svgNS,"text");
	newText.setAttributeNS(null,"id","r_"+xid);
	newText.setAttributeNS(null,"x","4");
	newText.setAttributeNS(null,"y",ry);
	newText.setAttributeNS(null,"font-size","12px");
	newText.setAttributeNS(null,"transform","translate(0,0)");
	newText.setAttributeNS(null,"text-anchor","left");
	newText.setAttributeNS(null,"stroke","blue");
	var data = document.createTextNode(xid);
	newText.appendChild(data);
//document.getElementById("firstGroup1").appendChild(newText);
 	var newAxis = document.createElementNS(svgNS,"line");
	newAxis.setAttributeNS(null,"id","x_"+xid);
	newAxis.setAttributeNS(null,"x1","100");
	newAxis.setAttributeNS(null,"y1",ry);
	newAxis.setAttributeNS(null,"x2",rx+l);
	newAxis.setAttributeNS(null,"y2",ry);
	newAxis.setAttributeNS(null,"stroke","black");
	newAxis.setAttributeNS(null,"stroke-width","1");
	newAxis.setAttributeNS(null,"stroke-dasharray","10,10;");
	newAxis.setAttributeNS(null,"transform","translate(0,0)");
//document.getElementById("firstGroup1").appendChild(newAxis);
 }
function pause(nMS) {
	var now = new Date();
	var exitTime = now.getTime() + nMS;
	while (true) {
		now = new Date();
		if (now.getTime() > exitTime) {
			return ;
		}
	}
}
function moveRead(dx,dy,xid) {
	var target = document.getElementById(xid);
	var targets = document.getElementById("s_"+xid);
	var targete = document.getElementById("e_"+xid);
	var x = dx;
	var y = dy;
	var btarget = document.getElementById("g_" + xid);
// updating the matrix
 	target.setAttribute('transform', 'translate(' + x + ',' + y + ')');
	targets.setAttribute('transform', 'translate(' + x + ',' + y + ')');
	targete.setAttribute('transform', 'translate(' + x + ',' + y + ')');
//btarget.setAttribute('display','none');
 //createAxis(150,4,190,800,"Axis_xxxxxxx.1");
 //createReference(150,200,contig,reads);
 //createContigView(150,320,contig,readsPos,reads);
 }
function createRect(mid,mx,my,mwidth,mheight,mcolor) {
//rect id="rP" x="0" y="0" width="1000" height="400" fill="yellow" opacity = ".75" stroke="black"
 	var newRect = document.createElementNS(svgNS,"rect");
	newRect.setAttributeNS(null,"width",mwidth);
	newRect.setAttributeNS(null,"height",mheight);
	newRect.setAttributeNS(null,"x",mx);
	newRect.setAttributeNS(null,"y",my);
	newRect.setAttributeNS(null,"fill-opacity","0.75");
	newRect.setAttributeNS(null,"fill",mcolor);
	document.getElementById("firstGroup").appendChild(newRect);
}
function createButton(x,y,height,width,name,color,com) {
	var group = "firstGroup1" ;
	if(document.getElementById("bgroup")) {
		group = "bgroup" ;
	}
	var newButton = document.createElementNS(svgNS,"rect");
	newButton.setAttributeNS(null,"width",width);
	newButton.setAttributeNS(null,"height",height);
	newButton.setAttributeNS(null,"x",x);
	newButton.setAttributeNS(null,"y",y);
	newButton.setAttributeNS(null,"fill-opacity","0.75");
	newButton.setAttributeNS(null,"fill",color);
	newButton.setAttributeNS(null,"onclick","controlC('c_" + com + "')");
	document.getElementById(group).appendChild(newButton);
}
function createText(tx,ty,otext,color,size,id,group) {
	var newText = document.createElementNS(svgNS,"text");
	newText.setAttributeNS(null,"id",id);
	newText.setAttributeNS(null,"x",tx);
	newText.setAttributeNS(null,"y",ty);
	newText.setAttributeNS(null,"stroke-width",1);
	newText.setAttributeNS(null,"font-size",size);
//newText.setAttributeNS(null,"stroke",color);
 	newText.setAttributeNS(null,"transform","translate(0,0)");
	newText.setAttributeNS(null,"text-anchor","left");
	var data = document.createTextNode(otext);
	newText.appendChild(data);
	document.getElementById(group).appendChild(newText);
}
function createLine(tx1,ty1,tx2,ty2,dasharray,color,size,id,group) {
	var newLine = document.createElementNS(svgNS,"line");
	newLine.setAttributeNS(null,"id",id);
	newLine.setAttributeNS(null,"x1",tx1);
	newLine.setAttributeNS(null,"y1",ty1);
	newLine.setAttributeNS(null,"x2",tx2);
	newLine.setAttributeNS(null,"y2",ty2);
	newLine.setAttributeNS(null,"stroke",color);
	newLine.setAttributeNS(null,"stroke-width",size);
	newLine.setAttributeNS(null,"stroke-dasharray",dasharray);
	if (dasharray != "-1") {
		newLine.setAttributeNS(null,"transform","translate(0,0)");
	}
	document.getElementById(group).appendChild(newLine);
}
//
 // This function create and show distance between parts of read
 //
 function createDistance(posX,posY,readS,readE,conS,conE,lastRS,lastRE,lastCS,lastCE,group,view) {
	var otext = "" + (readS - lastRE);
	var otext1 = "" + (conS -lastCE);
	if((conS-lastCE) < 0) {
		otext1 = "" + (lastCS- conE);
	}
	var fcolor = 'red';
	var scolor = 'green' ;
	var ftext = otext1 ;
	var stext = otext ;
	if (view == 'c') {
		fcolor = 'red';
		scolor = 'green' ;
		ftext = otext1 ;
		stext = otext ;
	} else {
		fcolor = 'green' ;
		scolor = 'red';
		ftext = otext ;
		stext = otext1 ;
	}
	var shape = document.createElementNS(svgNS, "ellipse");
	shape.setAttributeNS(null, "cx", posX+18);
	shape.setAttributeNS(null, "cy", posY-25-5-19);
	shape.setAttributeNS(null, "rx", 20);
	shape.setAttributeNS(null, "ry", 8);
	shape.setAttributeNS(null, "fill", fcolor);
	shape.setAttributeNS(null, "transform", "translate(0,0)");
	shape.setAttributeNS(null, "stroke-width", "1");
	shape.setAttributeNS(null, "fill-opacity","0.55");
	document.getElementById(group).appendChild(shape);
	var shape1 = document.createElementNS(svgNS, "ellipse");
	shape1.setAttributeNS(null, "cx", posX+18);
	shape1.setAttributeNS(null, "cy", posY-25-5);
	shape1.setAttributeNS(null, "rx", 20);
	shape1.setAttributeNS(null, "ry", 8);
	shape1.setAttributeNS(null, "fill", scolor);
	shape1.setAttributeNS(null, "transform", "translate(0,0)");
	shape1.setAttributeNS(null, "stroke-width", "1");
	shape1.setAttributeNS(null, "fill-opacity","0.55");
	document.getElementById(group).appendChild(shape1);
	var newText = document.createElementNS(svgNS,"text");
	newText.setAttributeNS(null,"id","ds");
	newText.setAttributeNS(null,"x",posX+5);
	newText.setAttributeNS(null,"y",posY-20-6);
	newText.setAttributeNS(null,"stroke-width",1);
	newText.setAttributeNS(null,"font-size","11px");
	newText.setAttributeNS(null,"fill","white");
	newText.setAttributeNS(null,"transform","translate(0,0)");
	newText.setAttributeNS(null,"text-anchor","left");
	var data = document.createTextNode(ftext);
	newText.appendChild(data);
	document.getElementById(group).appendChild(newText);
	var newText1 = document.createElementNS(svgNS,"text");
	newText1.setAttributeNS(null,"id","ds");
	newText1.setAttributeNS(null,"x",posX+5);
	newText1.setAttributeNS(null,"y",posY-20-6-19);
	newText1.setAttributeNS(null,"stroke-width",1);
	newText1.setAttributeNS(null,"font-size","11px");
	newText1.setAttributeNS(null,"fill","white");
	newText1.setAttributeNS(null,"transform","translate(0,0)");
	newText1.setAttributeNS(null,"text-anchor","left");
	var data1 = document.createTextNode(stext);
	newText1.appendChild(data1);
	document.getElementById(group).appendChild(newText1);
}
function createGroup(name) {
	var newGroupEl = document.createElementNS(svgNS,"g");
	newGroupEl.setAttributeNS(null,"id",name);
	newGroupEl.setAttributeNS(null,"transform","translate(0,0)");
	newGroupEl.setAttributeNS(null,"display","none");
	document.getElementById("readsCanvas").appendChild(newGroupEl);
}
function createReadsView(rx,y,mcontig,mreadsPos,mreads) {
	var nreads = mcontig[3];
//var rY = y +28;
 	var rY = 120;
	var i = 0;
// tmp var
 	var p = 0;
	var px = 0;
	var py = 0;
	var j = 0;
// tmp var
 	var r_name = " ";
// read name
 	var r_length = " ";
// read length
 	var r_start = 0 ;
// start position (index)for read parts
 	var r_end = 0 ;
// last index for this read
 	var rS = 0;
// start part
 	var rE = 0;
// end part
 	var rS_l = -1;
// last part start point
 	var rE_l = -1;
// last part end point
 	var cS = 0 ;
// start part of read on contig 
 	var cE = 0 ;
// end part of read on contig
 	var cS_l = -1 ;
// start part of read on contig 
 	var cE_l = -1 ;
	var r_endIndex = 0;
	var r_dna = " ";
	var rCh = 0;
	var pname = " ";
	var maxY = 0;
	for (i = 0; i < nreads; i++) {
		j = i * 3 ;
		r_name = mreadsPos[j];
		r_start = mreadsPos[j + 2];
		r_length = mreadsPos[j + 1];
		createGroup("g_" + r_name);
		rS_l = -1 ;
		rE_l = -1 ;
		cS_l = -1 ;
		cE_l = -1 ;
		p = 0 ;
		if (i == nreads - 1) {
			r_endIndex = mreads.length ;
		}else {
			r_endIndex = mreadsPos[(i+1)*3 + 2] ;
		}
		createAxis2(10,rY,r_length,"g_"+r_name);
		while (r_start < r_endIndex ) {
			rS = mreads[r_start] ;
// start part
 			rE = mreads[r_start + 1];
// end part
 			cS = mreads[r_start + 2];
// start on contig
 			cE = mreads[r_start + 3];
// end on contig	
 //rCh = mreads[r_start + 4];          // part dir 0 or 1 for oposite
 // 0 - do not show DNA
 			rCh = 0 ;
			pname = r_name+"_"+p.toString();
			createRead(10,rS,rY,rE-rS,1,rCh,r_dna,pname,"g_"+r_name,rS);
			if (rE_l > 0) {
				createDistance(10+rE_l,rY,rS,rE,cS,cE,rS_l,rE_l,cS_l,cE_l,"g_"+r_name,'r');
// (posX,posY,readS,readE,contigS,contigE,groupName)
 			}
			rS_l = rS ;
			rE_l = rE ;
			cS_l = cS ;
			cE_l = cE ;
//moveRead(0-rS,rY,pname);
 //rY += 40;
 			p += 1 ;
			r_start = r_start + 5 ;
		}
		if (maxY <= rY) {
			maxY = rY ;
		}
// rY = y;                             // set Y to next position
 	}
	var rtarget = document.getElementById("rP");
	maxY = maxY + 220 ;
	rtarget.setAttribute('height',maxY);
}
function createUseElement() {
	var newUseEl = document.createElementNS(svgNS,"use");
	newUseEl.setAttributeNS(null,"x",Math.random() * 200 + 50);
	newUseEl.setAttributeNS(null,"y",Math.random() * 180 + 80);
	newUseEl.setAttributeNS(xlinkNS,"href","#mySymbol");
	newUseEl.setAttributeNS(null,"fill-opacity",Math.random());
	document.getElementById("firstGroup").appendChild(newUseEl);
}
function createContigView(x,y,xcontig,xreadsPos,xreads) {
	var rY = y+20 ;
	var nreads = xcontig[3];
// numbers of reads on canvas
 	var rLength = xcontig[2];
// Axis length for reads
 	var i = 0;
// tmp var
 	var j = 0;
// tmp var
 	var r_name = " ";
// read name
 	var r_dna = " ";
// read DNA do not
 	var r_length = " ";
// read length
 	var r_start = 0 ;
// start position (index)for read parts
 	var r_end = 0 ;
// last index for this read
 	var rS = 0;
// start part
 	var rE = 0;
// end part
 	var r_endIndex = 0;
// end parts index for current read
 	var tx = 0;
	var roS = 0;
	var roE = 0 ;
	var tsx = 0 ;
	j = 0;
	var min = 9999999;
	while (j < xreads.length) {
		if(min > xreads[j+2]) {
			min = xreads[j+2] ;
		}
		j += 5 ;
	}
	j = 0;
//alert(' min point is =' + min );
 	for (i = 0; i < nreads; i++) {
		j = i * 3 ;
		r_name = xreadsPos[j];
		r_start = xreadsPos[j + 2];
		r_length = xreadsPos[j + 1];
		createAxis(x,4,rY,rLength,r_name);
		tx = xreads[r_start+2] - xreads[r_start] ;
		tsx = xreads[r_start+2] ;
//document.getElementById("firstGroup1").setAttributeNS(null,"transform","scale(0.4)");
 		var rS_l = -1 ;
		var rE_l = -1 ;
		var cS_l = -1 ;
		var cE_l = -1 ;
//createAxis2(x+tx,rY+60,r_length,r_name);
 		if (i == nreads - 1) {
			r_endIndex = xreads.length ;
		}else {
			r_endIndex = xreadsPos[(i+1)*3 + 2] ;
		}
		while (r_start < r_endIndex ) {
//roS = xreads[r_start] ;             // part start on read
 //roE = xreads[r_start+1]; 	      // part end on read	
 //rS =  xreads[r_start + 2] ;         // start part
 //rE =  xreads[r_start + 3];          // end part
 			var rCh = xreads[r_start + 4];
// part dir 0 or 1 for oposite
 // 0 - do not show DNA
 			rS = xreads[r_start] ;
			rE = xreads[r_start + 1] ;
			var cS = xreads[r_start + 2] ;
			var cE = xreads[r_start + 3] ;
			createRead(x-min,cS,rY,cE-cS,1,rCh,r_dna,r_name,"firstGroup1",cS);
			var stp = 0;
//createRead(x,rS,rY,rE-rS,1,rCh,r_dna,r_name,"firstGroup1",rS);
 //createRead(x,roS+tx,rY+60,roE-roS,1,0,r_dna,"o_"+r_name,"firstGroup1",roS);
 			if (rE_l > 0) {
				if ((cS-cE_l) > 0) {
					stp = x + cE_l;
				} else {
					stp = x+ cE;
				}
				createDistance(stp-min,rY,rS,rE,cS,cE,rS_l,rE_l,cS_l,cE_l,"firstGroup1",'c');
// (posX,posY,readS,readE,contigS,contigE,groupName)
 			}
			rS_l = rS ;
			rE_l = rE ;
			cS_l = cS ;
			cE_l = cE ;
			r_start = r_start + 5 ;
		}
		rY = rY + 60 + 60;
// set Y to next position
 	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////
