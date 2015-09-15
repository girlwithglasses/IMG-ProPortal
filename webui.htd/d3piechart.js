/* To draw a pie chart, add the following:
    <link rel="stylesheet" type="text/css" href="$base_url/d3piechart.css" />
    <span id="ruler"></span>
    <div id="$div_id"></div>
    <script src="$base_url/d3.min.js"></script>
    <script src="$base_url/d3piechart.js"></script>
    <script>
        window.onload = drawPieChart("$svg_id", "$url", $data, $dolegend);
    </script>

    example json data expected format:
    var jsondata = [{
    "percent": "2.02%",
    "id": "A",
    "urlfragm": "fragm",
    "title": "Archae",
    "name": "Archae",
    "count": 766
    }, {
    "percent": "0.66%",
    "id": "E",
    "urlfragm": "fragm",
    "title": "Eukariota",
    "name": "Eukariota",
    "count": 252
    }];
*/

function visualLength(mystr) {
    var ruler = document.getElementById("ruler");
    ruler.innerHTML = mystr;
    return ruler.offsetWidth + 5;
}

var colors1 = d3.scale.category20();
var colors2 = d3.scale.category20b();
var colors3 = d3.scale.category20c();

function getPieColor(i) {
    var c_temp = i % 60;
    if ( c_temp >= 40 ) {
        return colors3(i % 20);
    }
    if ( c_temp >= 20 ) {
        return colors2(i % 20);
    }
    return colors1(i % 20);
}

/*
@param divid - where to place this in html
@param url1 - link for color square in table
@param url2 - link for count and pie sections
@param jsondata - data in json format
@param dolegend - whether to display legend
@param dotable - whether to display table of values
@param columns - array of column names that correspond to keys in jsondata
@param width0
@param height0
*/
function drawPieChart(divid, url1, url2, jsondata, dolegend, dotable, columns, 
		      pie_width0, table_width0, height0) {

    var piedata = JSON.parse(JSON.stringify(jsondata));
    var index;
    jsondata.forEach(function(d, i) {
        if (d.urlfragm == "" || d.draw == "no") {
            index = i;
        }
    });
    if (index !== undefined) {
	// remove item that has no url link from piechart
	// it is just an extra row for the table e.g. "Not in COG"
	piedata.splice(index,1);
    }
    
    var max = 2;
    jsondata.forEach(function(d) {
        if (max < d.count) {
            max = d.count;
        }
    });
    var len = visualLength(max);

    var lbmax = "";
    jsondata.forEach(function(d) {
        var mylbl0 = d.name;
        if (mylbl0.length > lbmax.length) {
            lbmax = mylbl0;
        }
    });
    var lblen = visualLength(lbmax);

    var width = 450;
    var height = 450;
    if (pie_width0 && pie_width0 !== undefined && !isNaN(pie_width0)) {
	width = pie_width0;
    }
    if (height0 && height0 !== undefined && !isNaN(height0)) {
	height = height0;
    }
    var margin = {top: 20, right: 80, bottom: 20, left: 20};
    var chartWidth = width + 50 + margin.left + margin.right;
    if (dolegend !== undefined && dolegend == 1) {
	chartWidth = width + 50 + lblen + len + margin.left + margin.right;
    }
    var radius = Math.min(width - 50, height - 50) / 2;

    var mainTable = d3.select("#" + divid).append("table");
    mainTable.append("th").append("tr");
    var left = mainTable.append("td");
    var mid = mainTable.append("td").html("&nbsp;&nbsp;&nbsp;"); // blank space
    var right = mainTable.append("td");

    if (dotable !== undefined && dotable == 1) {
	tabulate(left, url1, url2, jsondata, columns, table_width0);
    }

    var arc = d3.svg.arc()
	.outerRadius(radius - 50);
    var arc2 = d3.svg.arc() // for moving a section out a little on mouseover
        .outerRadius(radius - 40);
    
    var chart = right.append("svg")
	.attr("width", chartWidth)
	.attr("height", height)
	.append("g")
	.attr("transform", "translate(" + (radius-50) + "," + (radius-50) + ")");

    var tooltip = d3.select("body")
	.append("div")
	.attr("class", "tooltip");
    
    // create arc data and bind each value to a pie section:
    var pie = d3.layout.pie()
	.sort(null)
	.value(function(d) {
            return d.count;
	});

    var g = chart.selectAll(".arc")
	.data(pie(piedata))
	.enter()
	.append("g")
	.attr("class", "arc")
	.attr("xlink:href", function(d) {
            var myurl = url2;
            myurl += d.data.urlfragm;
            return myurl;
        })
	.on("click", function(d) {
            var myurl = url2;
	    myurl += d.data.urlfragm;
            window.open(myurl);
        });
    
    // color in the pie slices:
    g.append("path")
	.attr("d", arc)
        .style("fill", function(d, i) {
	    return getPieColor(i);
        });

    d3.selectAll('path')
        .on("mousemove", function(d) {
            /*d3.select(this)
              .attr("stroke","white")
              .attr("d", arc2)
              .attr("stroke-alignment", "inner")
              // "inside" ? - stroke doesn't draw inside, though!
              .attr("stroke-width",10); */
	    
            //var mouseVal = d3.mouse(this);
            tooltip.style("display", "none");
            tooltip.html(d.data.name + ": " + 
			 d.data.count + " (" + d.data.percent + "%) ")
                .style("left", (d3.event.pageX + 12) + "px")
                .style("top", (d3.event.pageY - 12) + "px")
                .style("opacity", 1)
                .style("display", "block");
            this.style.cursor="pointer";
	    this.style.opacity=0.7;
        })
	.on("mouseout", function(d, i) {
            /*d3.select(this)
              .attr("d", arc)
              .attr("stroke","none"); */

	    this.style.fill= getPieColor(i);
	    this.style.opacity=1;
            tooltip.html(" ").style("display", "none");
	});
    
    if (dolegend !== undefined && dolegend == 1) {
	// add legend:
	var legend = chart.selectAll(".legend")
	    .data(pie(piedata))
	    .enter()
	    .append("g")
	    .attr("class", "legend")
	    .append("g")
	    .attr("transform", function(d, i) {
		return "translate(200, " + (-(radius-50-20)+i*23) + ")";
	    });
	
	legend.append("rect")
	    .attr("width", 20)
	    .attr("height", 20)
            .on("mousemove", function(d) {
		this.style.cursor="pointer";
            })
	    .attr("xlink:href", function(d) {
		var myurl = url2;
		myurl += d.data.urlfragm;
		return myurl;
            })
	    .on("click", function(d) {
		var myurl = url2;
		myurl += d.data.urlfragm;
		window.open(myurl);
            })
            .style("fill", function(d, i) {
		return getPieColor(i);
            });

	legend.append("text")
	    .attr('class', 'label')
	    .attr('x', 23)
	    .attr('y', 9)
	    .attr('dy', '.35em')
            .on("mousemove", function(d) {
		this.style.cursor="pointer";
            })
	    .attr("xlink:href", function(d) {
		var myurl = url2;
		myurl += d.data.urlfragm;
		return myurl;
            })
	    .on("click", function(d) {
		var myurl = url2;
		myurl += d.data.urlfragm;
		window.open(myurl);
            })
	    .text(function(d) {
		return "[" + d.data.id + "] " + d.data.name + ": " + d.data.count;
	    });
    }
}

function tabulate(el, url1, url2, data, columns, width) {
    var table = el.append("table")
	.attr("class", "table"),
        thead = table.append("thead"),
        tbody = table.append("tbody");

    if (width !== undefined && !isNaN(width)) {
	table.attr("width", width);
    }

    thead.append("tr")
        .selectAll("th")
        .data(columns)
        .enter()
        .append("th")
        .text(function(column) {
            if (column == 'color' || column == 'id') {
                return "";
            }
	    // capitalize first letter:
            return column.charAt(0).toUpperCase() + column.slice(1);
        });

    var rows = tbody.selectAll("tr")
        .data(data)
        .enter()
        .append("tr");

    var cells = rows.selectAll("td")
        .data(function(row, i) {
            return columns.map(function(column) {
                var val1 = row[column];
                if (column == 'color') {
		    var bgcolor = 'white';
                    if (typeof (row['percent']) == 'undefined') {
                        bgcolor = 'white';
                    } else {
			bgcolor = getPieColor(i);
                    }
                    val1 = "<div id='square' style='background-color:" + bgcolor + "'></div>";
		    if (row['urlfragm'] != "") {
			var myurl = "<a href='" + url1;
			myurl += row['urlfragm'] + "' target='_blank'>" + val1 + "</a>";
		    }
                    val1 = myurl;
		    
                } else if (column == 'percent') {
                    if (typeof (val1) == 'undefined') {
                        val1 = '';
                    } else {
                        val1 += '%';
                    }
                } else if (column == 'count') {
		    if (row['urlfragm'] != "") {
			var myurl = "<a href='" + url2;
			myurl += row['urlfragm'] + "' target='_blank'>" + val1 + "</a>";
			val1 = myurl;
		    }
                }
                return {
                    column: column,
                    value: val1
                };
            });
        })
        .enter()
        .append("td")
        .html(function(d) {
            return d.value;
        });

    return table;
}