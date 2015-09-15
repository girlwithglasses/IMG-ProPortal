/* To draw a horizontal bar chart, add the following:
    <link rel="stylesheet" type="text/css" href="$base_url/d3barchart.css" />
    <span id="ruler"></span>
    <svg id="$svg_id"></svg>
    <script src="$base_url/d3.min.js"></script>
    <script src="$base_url/d3barchart.js"></script>
    <script>
        window.onload = drawHorizontalBars("$svg_id", "$url", $data);
    </script>

    example json data expected format:
    var jsondata = [{
    "subtitle": "Final and Draft",
    "title": "Archae",
    "label": 4,
    "count": 4
    }, {
    "subtitle": "Final",
    "title": "Bacteria",
    "label": 5,
    "count": 5
    }, {
    "subtitle": "Final",
    "title": "Eukariota",
    "label": 10,
    "count": 10
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

function drawHorizontalBars(svgid, url, jsondata, doxaxis, doyaxis, rotate) {
    var max = 2;
    jsondata.forEach(function (d) {
	if (max < d.count) {
            max = d.count;
	}
    });
    var len = visualLength(max);

    var lbmax = "";
    jsondata.forEach(function (d) {
	var mylbl0 = d.title;
	if (mylbl0.length > lbmax.length) {
            lbmax = mylbl0;
	}
    });
    var lblen = visualLength(lbmax);
    
    var margin = {top: 20, right: 20, bottom: 40, left: 20};
    var chartWidth = 500;
    var width = chartWidth + lblen + len + margin.left + margin.right;
    var barHeight = 25;

    var x = d3.scale.linear()
	.domain([0, max])
	.range([0, chartWidth]);
    
    var xAxis = d3.svg.axis()
	.scale(x)
	.orient("bottom");

    var chart = d3.select('#' + svgid)
	.attr('width', width)
	.attr('height', barHeight * jsondata.length + margin.top + margin.bottom)
	.append("g")
	.attr("transform",
              "translate(" + margin.left + "," + margin.top + ")");
    
    var bar = chart.selectAll('g')
	.data(jsondata)
	.enter()
	.append('g')
	.attr('transform', function (d, i) {
	    return 'translate(' + lblen + ',' + barHeight * i + ')';
	});
    
    bar.append('text')
	.attr('class', 'title')
	.attr('x', -3)
	.attr('y', barHeight / 2)
	.attr('dy', '.35em')
	.text(function (d) {
	    return d.title;
	});

    /*
      bar.append('text')
      .attr('class', 'subtitle')
      .attr('dy', '1em')
      .text(function (d) {
      return d.subtitle;
      });
    */
    
    // the bar itself
    bar.append('rect')
	.attr("fill", function (d, i) {
            var c_temp = i % 60;
            if ( c_temp >= 40 ) {
		return colors3(i % 20);
            }
            if ( c_temp >= 20 ) {
		return colors2(i % 20);
            } 
	    return colors1(i % 20);
	})
	.attr('width', function (d) {
	    return x(d.count);
	})
	.attr('height', barHeight - 3)
        .attr("xlink:href", function(d) {
	    var myurl = url;
	    myurl += d.title;
	    return myurl;
	})
        .on("click", function(d) {
	    var myurl = url;
	    myurl += d.title;
	    window.open(myurl);
	});
    
    // label for each bar (on the right)
    bar.append('text')
	.attr('class', 'hlabel')
	.attr('x', function (d) {
	    return x(d.count) + 3;
	})
	.attr('y', barHeight / 2)
	.attr('dy', '.35em')
	.text(function (d) {
	    return d.label;
	})
        .on("mousemove", function (d) {
            return this.style.cursor="pointer";
        })
        .attr("xlink:href", function(d) {
            var myurl = url;
            myurl += d.title;
            return myurl;
        })
        .on("click", function(d) {
            var myurl = url;
            myurl += d.title;
            window.open(myurl);
        });

    if (doxaxis !== undefined && doxaxis == 1) {
	if (rotate !== undefined && rotate == 1) {
	    chart.append("g")
		.attr("class", "x axis")
		.attr("transform", "translate(" + lblen + ", " + barHeight * jsondata.length + ")")
		.call(xAxis)
		.selectAll("text")  
		.style("text-anchor", "end")
		.attr("dx", "-.8em")
		.attr("dy", ".15em")
		.attr("transform", function(d) {
		    return "rotate(-45)" 
		});

	} else {
	    chart.append("g")
		.attr("class", "x axis")
		.attr("transform", "translate(" + lblen + ", " + barHeight * jsondata.length + ")")
		.call(xAxis);
	}
    }

    // tooltip for each bar
    var tooltip = d3.select("body")
	.append("div")
	.attr("class", "tooltip");
    
    d3.selectAll('rect')
	.on("mousemove", function(d) {
	    var mouseVal = d3.mouse(this);
	    tooltip.style("display", "none");
	    tooltip.html(d.title + " [" + d.subtitle + "] " + d.count)
		.style("left", (d3.event.pageX + 12) + "px")
		.style("top", (d3.event.pageY - 12) + "px")
		.style("opacity", 1)
		.style("display", "block");
	    return this.style.cursor="pointer";
	})
	.on("mouseout", function() {
	    tooltip.html(" ").style("display", "none");
	});
} // end drawHorizontalBars

function drawVerticalBars(svgid, url, jsondata, doxaxis, doyaxis, rotate) {
    var max = 2;
    jsondata.forEach(function (d) {
        if (max < d.count) {
            max = d.count;
	}
    });
    //max = d3.max(jsondata, function(d) { return d.range; })
    var len = visualLength(max);

    var lbmax = "";
    jsondata.forEach(function (d) {
	var mylbl0 = d.title;
	if (mylbl0.length > lbmax.length) {
            lbmax = mylbl0;
	}
    });
    var lblen = visualLength(lbmax);

    var margin = {top: 20, right: 20, bottom: 40, left: 40};
    var barWidth = 30;
    var chartHeight = 400;
    //var width = 500;
    var height = chartHeight + lblen + len + margin.top + margin.bottom;

    var x = d3.scale.ordinal()
	.domain(jsondata.map(function (d) {
            return d.title;
	}))
	//.domain(d3.range(jsondata.length))
	.range(jsondata.map(function (d, i) {
            return barWidth/2 + barWidth * i;
	}));
	//.rangeRoundBands([0, width], .05);
    var y = d3.scale.linear()
	.domain([0, max])
	.range([chartHeight, 0]);

    var xAxis = d3.svg.axis()
	.scale(x)
	.orient("bottom");
    var yAxis = d3.svg.axis()
	.scale(y)
	.orient("left");
	//.ticks(jsondata.length);

    var chart = d3.select('#chart')
	.attr('height', height)
	.attr('width', barWidth * jsondata.length + margin.left + margin.right)
	.append("g")
        .attr("transform", 
              "translate(" + margin.left + "," + margin.top + ")");

    var bar = chart.selectAll('g')
	.data(jsondata)
	.enter()
	.append('g')
	.attr('transform', function (d, i) {
	    return 'translate(' + barWidth * i + ',' + len + ')';
	});

    if (doxaxis === undefined || !doxaxis) {
	bar.append('text')
	    .attr('class', 'title')
	    .attr('x', -chartHeight - 8)
	    .attr('y', barWidth / 2)
	    .attr('dx', '.3em')
	    .attr('dy', '.3em')
	    .attr("transform", "rotate(-90)")
	    .text(function (d) {
		return d.title;
	    });
    }

    // the bar itself
    bar.append('rect')
        .attr("fill", function (d, i) {
            var c_temp = i % 60;
            if ( c_temp >= 40 ) {
                return colors3(i % 20);
            }
            if ( c_temp >= 20 ) {
                return colors2(i % 20);
            }
            return colors1(i % 20);
        })
	.attr("y", function (d) {
	    return y(d.count);
	})
	.attr('height', function (d) {
	    return chartHeight - y(d.count);
	})
	.attr('width', barWidth - 5)

        .attr("xlink:href", function(d) {
            var myurl = url;
            myurl += d.title;
            return myurl;
        })
        .on("click", function(d) {
            var myurl = url;
            myurl += d.title;
            window.open(myurl);
        });

    // label for each bar (on the right)
    bar.append('text')
	.attr('class', 'vlabel')
	.attr('x', function (d) {
            return  - y(d.count) + 3;
	})
	.attr('y', barWidth/2)
	.attr('dx', '.3em')
	.attr('dy', '.3em')
	.attr("transform", "rotate(-90)")
	.text(function (d) {
	    return d.label;
	})
        .on("mousemove", function (d) {
            return this.style.cursor="pointer";
        })
        .attr("xlink:href", function(d) {
            var myurl = url;
            myurl += d.title;
            return myurl;
        })
        .on("click", function(d) {
            var myurl = url;
            myurl += d.title;
            window.open(myurl);
        });

    if (doyaxis !== undefined && doyaxis == 1) {
	// add the y axis
	chart.append("g")
            .attr("class", "y axis")
            .attr("transform", "translate(-3, " + len + ")")
            .call(yAxis);
    }

    if (doxaxis !== undefined && doxaxis == 1) {
	// add the y axis
	chart.append("g")
	    .attr("class", "x axis")
	    .attr("transform", "translate(" + 0 + ", " + (chartHeight + 3 + len) + ")")
	    .call(xAxis)
	    .selectAll("text")  
            .style("text-anchor", "end")
            .attr("dx", "-.8em")
            .attr("dy", ".15em")
            .attr("transform", "rotate(-45)");
    }

    // tooltip for each bar
    var tooltip = d3.select("body")
	.append("div")
	.attr("class", "tooltip");

    d3.selectAll('rect')
	.on("mousemove", function (d) {
	    var mouseVal = d3.mouse(this);
	    tooltip.style("display", "none");
	    tooltip.html(d.title + " [" + d.subtitle + "] " + d.count)
		.style("left", (d3.event.pageX + 12) + "px")
		.style("top", (d3.event.pageY - 12) + "px")
		.style("opacity", 1)
		.style("display", "block");
	    return this.style.cursor="pointer";
	})
	.on("mouseout", function () {
	    tooltip.html(" ").style("display", "none");
	});
} // end drawVerticalBars
