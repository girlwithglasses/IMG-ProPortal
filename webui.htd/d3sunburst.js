/* To draw a sunburst, add the following:           
    <link rel="stylesheet" type="text/css" href="$base_url/d3sunburst.css" />
    <div id="$svg_id"."_trail"></div>
    <span id="ruler"></span>
    <div id="$svg_id"></div>
    <script src="$base_url/d3.min.js"></script>
    <script src="$base_url/d3sunburst.js"></script>
    <script>
        window.onload = doSunburst("$svg_id", "$url", $data, $levels);
    </script>
*/

function visualLength(mystr) {
    var ruler = document.getElementById("ruler");
    ruler.innerHTML = "xx" + mystr;
    return ruler.offsetWidth + 5;
}

var colors1 = d3.scale.category20();
var colors2 = d3.scale.category20b();
var colors3 = d3.scale.category20c();

// color by parent phylum:
function getColor2(d) {
    if (!d.parent) {
	return "#fff";
    } 
    if (d.depth == 1) {
	return colors1(d.name);
    }
    return getColor2(d.parent);
}

// Dimensions of sunburst:
var margin = {top: 20, right: 20, bottom: 20, left: 20};
var width = 550;
var height = 550;
var radius = Math.min(width-50, height-50) / 2;    

// Total size of all segments; this is set after loading the data:
var totalSize = 0;
// Breadcrumb dimensions: width, height, spacing, width of tip/tail;
var b = {
    w: 75,
    h: 26,
    s: 3,
    t: 10
};

// the angular scale (from 0 to 360 or 2 PI):
var x = d3.scale.linear().range([0, 2 * Math.PI]);
// the radial scale (area of an arc varies as the sqrt of its radius):
var y = d3.scale.sqrt().range([0, radius]);

var tooltip = d3.select("body")
    .append("div")
    .attr("class", "tooltip");


/*                                        
@param svgid - where to place this in html
@param url - link
@param jsondata - data in json format 
@param levels - array of category names for each level
*/
function doSunburst(jsondata, svgid, url, levels) {
    var svg = d3.select("#" + svgid).append("svg")
	.attr("width", width)
	.attr("height", height)
	.append("g")
	.attr("id", "container")
	.attr("transform", "translate(" + width/2 + "," + height/2 + ")");

    var partition = d3.layout.partition()
	.value(function(d) { return d.size; });
    
    var arc = d3.svg.arc()
	.startAngle(function(d) { 
	    return Math.max(0, Math.min(2 * Math.PI, x(d.x))); })
	.endAngle(function(d) { 
	    return Math.max(0, Math.min(2 * Math.PI, x(d.x + d.dx))); })
	.innerRadius(function(d) { return Math.max(0, y(d.y)); })
	.outerRadius(function(d) { return Math.max(0, y(d.y + d.dy)); });

    // area for displaying selected node lineage:
    initializeBreadcrumbTrail(svgid, width);

    // bounding circle under the sunburst ?
    svg.append("circle")
	.attr("r", radius)
	.style("opacity", 0);

    var nodes = partition.nodes(jsondata);
    var uniqueNames = (function(a) {
        var output = [];
        a.forEach(function(d) {
            if (output.indexOf(d.name) === -1) {
                output.push(d.name);
            }
        });
        return output;
    })(nodes);

    var lbmax = "";
    var level1_nodes = [];
    nodes.forEach(function(d) {
	if (d.depth == 1) {
	    level1_nodes.push(d);
            var mylbl0 = d.name;
            if (mylbl0.length > lbmax.length) {
		lbmax = mylbl0;
            }
	}
    });
    var lblen = visualLength(lbmax);

    // set domain of colors scale based on data
    //colors3.domain(uniqueNames);
    colors1.domain(level1_nodes);

    // generate the shape for each element
    // the d attribute carries the instructions for drawing the shapes
    //var jsondata = getData();
    var path = svg.data([jsondata]).selectAll("path")
	.data(nodes)
	.enter().append("path")
	.attr("d", arc)
	.attr("fill-rule", "evenodd") // whether a given point is included
	.style("fill", function(d) { return getColor2(d); })
	.style("opacity", 1)
	.on("mouseover", mouseover)
        .on("mousemove", mousemove)
	.on("click", click)
        .on("mouseout", function() {
	    tooltip.html(" ").style("display", "none");
	});

    function click(d) {
	path.transition()
            .duration(750)
            .attrTween("d", arcTween(d));
    }

    totalSize = path.node().__data__.value;
    //d3.select("#container").on("mouseleave", mouseleave);

    drawLegend(level1_nodes, lblen);
    
    function drawLegend(nodes1, maxlen) {
	var legend = d3.select("#legend").append("svg")
	    .attr("width", 50 + maxlen)
	    .attr("height", (nodes1.length * 28 + 28)); 

	var g = legend.selectAll("g")
            .data(nodes1)
            .enter().append("g")
            .attr("transform", function(d, i) {
		return "translate(0," + (i * 24 + 24) + ")";
            });
	
	legend.append("g").append("text")
	    .attr("class", "label")
	    .attr('y', 9)
            .attr('dy', '.35em')
	    .text(levels[0].toUpperCase());
	
	g.append("rect")
            .attr("width", 20)
            .attr("height", 20)
            .on("mousemove", function(d) {
		this.style.cursor="pointer";
            })
            .on("click", click)
            .style("fill", function(d, i) { return getColor2(d); });
	
	g.append("text")
            .attr('x', 22)
            .attr('y', 9)
            .attr('dy', '.35em')
            .on("mousemove", function(d) {
		this.style.cursor="pointer";
            })
            .on("click", click)
            .text(function(d) { return d.name + " - " + getPercentage(d); }); 
    }
    
    // Interpolate the scales!
    function arcTween(d) {
	var xd = d3.interpolate(x.domain(), [d.x, d.x + d.dx]),
	yd = d3.interpolate(y.domain(), [d.y, 1]),
	yr = d3.interpolate(y.range(), [d.y ? 20 : 0, radius]);
	return function(d, i) {
            return i ? function(t) {
		return arc(d);
            } : function(t) {
		x.domain(xd(t));
		y.domain(yd(t)).range(yr(t));
		return arc(d);
            };
	};
    }

    // breadcrumbs of the ancestry
    function initializeBreadcrumbTrail(svgid, width) {
	var trail = d3.select("#" + svgid + "_trail").append("svg")
            .attr("width", width * 2)
            .attr("height", 50)
            .attr("id", "trail");
	
	// Add the label at the end, for the percentage.
	trail.append("text")
            .attr("id", "endlabel")
            .style("fill", "#000");
    }
    
    function getPercentage(d) {
	var percentage = (100 * d.value / totalSize).toPrecision(3);
	var percentageString = percentage + "%";
	if (percentage < 0.1) {
            percentageString = "< 0.1%";
	}
	return percentageString;
    }

    function mousemove(d) {
        var mouseCoords = d3.mouse(this);
	if (d.depth == 0) {
	    return; // no tooltip for root of tree
	}
        tooltip.style("display", "none");
        tooltip.html(levels[d.depth - 1].toUpperCase() + ": " + d.name)
            .style("left", (d3.event.pageX + 12) + "px")
            .style("top", (d3.event.pageY - 12) + "px")
            .style("opacity", 1)
            .style("display", "block");
        this.style.cursor="pointer";
    }

    // Fade all but the current sequence, and show it in the breadcrumb trail:
    function mouseover(d) {
	var percentageString = getPercentage(d);	
	var sequenceArray = getAncestors(d);
	updateBreadcrumbs(sequenceArray, percentageString, url, levels);

	// Fade all the segments:
	d3.selectAll("path")
            .style("opacity", 0.7);
	
	// Highlight only those that are an ancestor of the current segment:
	svg.selectAll("path")
            .filter(function(node) {
		return (sequenceArray.indexOf(node) >= 0);
            })
            .style("opacity", 1);
    }
    
    // Restore everything to full opacity when moving off the visualization:
    function mouseleave(d) {
	// Hide the breadcrumb trail
	//d3.select("#trail")
        //    .style("visibility", "hidden");
	
	// Deactivate all segments during transition.
	d3.selectAll("path").on("mouseover", null);
	
	// Transition each segment to full opacity and then reactivate it.
	/*d3.selectAll("path")
            .transition()
            .duration(1000)
            .style("opacity", 1)
            .each("end", function() {
		d3.select(this).on("mouseover", mouseover);
	    });*/
    }
}

// Given a node in a partition layout, return an array of all of its ancestor
// nodes, highest first, but excluding the root.
function getAncestors(node) {
    var path = [];
    var current = node;
    while (current.parent) {
        path.unshift(current);
        current = current.parent;
    }
    return path;
}

// Generate a string that describes the points of a breadcrumb polygon.
function breadcrumbPoints(d, i) {
    var dlen = visualLength(d.name);
    dlen = +dlen;

    var points = [];
    points.push("0,0");
    points.push(dlen + ",0");
    points.push(dlen + b.t + "," + (b.h / 2));
    points.push(dlen + "," + b.h);
    points.push("0," + b.h);

    // Leftmost breadcrumb; don't include 6th vertex
    if (d.depth > 1) {
        points.push(b.t + "," + (b.h / 2));
    }
    return points.join(" ");
}

// Update the breadcrumb trail to show the current sequence and percentage
function updateBreadcrumbs(nodeArray, percentageString, url, levels) {
    var g = d3.select("#trail")
        .selectAll("g")
        .data(nodeArray, function(d) {
            return d.name + d.depth + d.parent;
        });
    
    var c;
    nodeArray.forEach(function(d, i) {
	if (d.depth == 1) {
	    c = getColor2(d);
	}
    });
	
    var sum = 0;
    var n = nodeArray.length;
    while (n > 0) {
	var node = nodeArray[n - 1];
	var dlen = visualLength(node.name);
        dlen = +dlen;
        sum += dlen;
        sum += b.s;
        n--;
    }

    // Add breadcrumb and label for entering nodes:
    var entering = g.enter().append("g");
    entering.append("svg:polygon")
        .attr("points", breadcrumbPoints)
	.style("fill", c);

    entering.append("svg:text")
        .attr("x", (function(d) {
            var dlen = visualLength(d.name);
            dlen = +dlen;
            return (dlen + b.t) / 2;
	}))
	.attr("y", b.h / 2)
        .attr("dy", "0.35em")
        .attr("text-anchor", "middle")
        .text(function(d) { return d.name; })
        .on("mouseout", function() {
            tooltip.html(" ").style("display", "none");
        })
        .on("mousemove", function (d) {
            tooltip.style("display", "none");
            tooltip.html("Click to display the list of genomes for this lineage up to: "+levels[d.depth - 1].toUpperCase() + ": " + d.name)
		.style("left", (d3.event.pageX + 12) + "px")
		.style("top", (d3.event.pageY - 12) + "px")
		.style("opacity", 1)
		.style("display", "block");
            this.style.cursor="pointer";
        })
        .on("click", function(d) {
            var myurl = url;
	    nodeArray.forEach(function(n) {
		if (n.depth <= d.depth) {
		    myurl += "&" + levels[n.depth-1] + "=" + n.name;
		}
	    });
            window.open(myurl);
        });


    // Set position for entering and updating nodes
    g.attr("transform", function(d, i) {
        var total = 0;
	var j = i;
        while (j > 0) {
	    var node = nodeArray[j - 1];
	    var dlen = visualLength(node.name);
            dlen = +dlen;
            total += dlen;
            total += b.s;
            j--;
        }
        return "translate(" + total + ", 0)";
    });

    // Remove exiting nodes:
    g.exit().remove();

    // Now move and update the percentage at the end
    d3.select("#trail").select("#endlabel")
        .attr("x", sum + b.t + b.s)
	.attr("y", b.h / 2)
        .attr("dy", "0.35em")
        .attr("text-anchor", "center")
        .text(percentageString);

    // Make the breadcrumb trail visible;
    d3.select("#trail")
        .style("visibility", "");
}

function getData() {
    return {
        "name": "Root",
        "children": [{
            "name": "Archae",
            "children": [{
                "name": "Methanococci",
                "size": "21"
            }, {
                "name": "Proteobacteria",
                "size": "2"
            }, {
                "name": "Thaumarchaeota",
                "size": "72"
            }]
        }, {
            "name": "Bacteria",
            "children": [{
                "name": "Acidobacteria",
                "size": "48"
            }, {
                "name": "Actinobacteria",
                "size": "339" //3339
            }, {
                "name": "Bacteroidetes",
                "size": "156" //1156
            }, {
                "name": "Cyanobacteria",
                "size": "442"
            }]
        }, {
            "name": "Eukariota",
            "children": [{
                "name": "Arthropoda",
                "size": "21"
            }, {
                "name": "Chlorophyta",
                "children": [{
                    "name": "Chlorophyceae",
                    "size": "3"
                }, {
                    "name": "Mamiellophyceae-Testing Long Name",
                    "size": "7"
                }, {
                    "name": "Trebouxiophyceae",
                    "size": "2"
                }]
            }]

        }]
    };
}
