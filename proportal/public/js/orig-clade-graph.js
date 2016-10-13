/* global d3, getJson */
/*jshint laxcomma: true */

function fn(){

	"use strict";

	function makeTree(root) {

		// Compute the new tree layout.
		var nodes = tree.nodes(root).reverse(),
			links = tree.links(nodes);

		// Normalize for fixed-depth.
		nodes.forEach(function(d) {
			d.y = d.depth * 12;
			if(d.x0) {
				d.x = d.x0;
			}
		});

		var i = 0;

		// Declare the nodes
		var node = svg.selectAll("g.node")
			.data(nodes, function(d) {
				return d.id || (d.id = ++i);
			});

		// Enter the nodes.
		var nodeEnter = node.enter().append("g")
			.attr("class", "node")
			.attr("transform", function(d) {
				return "translate(" + d.y + "," + d.x + ")";
			});

		//	nodeEnter.append("circle")
		//	 .attr("r", 10)
		//	 .style("fill", "#fff");

		nodeEnter.append("text")
			.attr("x", function(d) {
				return d.children || d._children ? -13 : 13;
			})
			.attr("dy", ".35em")
			.attr("text-anchor", function(d) {
				return d.children || d._children ? "end" : "start";
			})
			.text(function(d) {
				return '';
			})
			.style("fill-opacity", 1);

		// the horizonal lines
	//	var link1 =
		svg.selectAll(".link")
			.data(links)
			.enter().append("line")
			.attr("class", "link")
			.attr("x1", function(d) {
				return d.source.y;
			})
			.attr("y1", function(d) {
				return d.target.x;
			})
			.attr("x2", function(d) {
				if(d.target.children) {
					return d.target.y;
				} else {
					return 80;
				}
			})
			.attr("y2", function(d) {
				return d.target.x;
			});

		// the vertical lines
	//	var link2 =
		svg.selectAll(".link2")
			.data(links)
			.enter().append("line")
			.attr("class", "link")
			.style("fill", "#99ccff")
			.attr("x1", function(d) {
				return d.source.y;
			})
			.attr("y1", function(d) {
				return d.source.x;
			})
			.attr("x2", function(d) {
				return d.source.y;
			})
			.attr("y2", function(d) {
				return d.target.x;
			});

	}

	function makeGenusBoxes( vis ){
		// genus gray boxes and text
		var genusData = [{
			name: "Prochlorococcus",
			y0  : 32,
			h0  : 170,
			x1  : 185
		}, {
			name: "Synechococcus",
			y0  : 215,
			h0  : 140,
			x1  : 20
		}];

		vis.selectAll("rect2")
			.data(genusData)
			.enter()
			.append("rect")
			.attr("x", "90")
			.attr("y", function(d) {
				return d.y0;
			})
			.attr("width", "30")
			.attr("height", function(d) {
				return d.h0;
			})
			.attr("fill", "lightgray");

		vis.selectAll("text2")
			.data(genusData)
			.enter()
			.append("text")
			.text(function(d) {
				return d.name;
			})
			.attr("x", function(d) {
				return d.x1;
			})
			.attr("y", "60")
			.attr("text-anchor", "middle")
			.attr("font-family", "sans-serif")
			.attr("font-size", "12px")
			.attr("fill", "black")
			.attr("transform", "translate(50,300)rotate(270)");
	}

	// create a bar chart
	function makeBarChart( cd, vis ) {

		// bar chart
		var color = d3.scale.category20b(),
		width  = 300,
		height = 360,
		barHeight = 24,
		offset = 190,
		chart,
		clades = ['', 'HLI', 'HLII', 'LLI', 'LLII/III', 'LLIV', '5.1A', '5.1B', '5.2', '5.3'],
		objForMap = { data: cd },
		sortedCladeData = clades.map(function(c){
			if( this[c] ) {
				this[c].count = +this[c].count;
				return this[c];
			}
			return { id: "", count: 0 };
		}, cd),

		x = d3.scale.linear()
			.domain([0, d3.max(sortedCladeData,function(d){ return d.count; } )])
			.range([0, width]),

		y = d3.scale.linear()
			.domain([0, clades.length])
			.range([0, height]),
	//	y = d3.scale.ordinal()
	//		.domain( cladeData.map(function(d){ return d.id }) )
	//		.rangeBands([0, height]),

		tip = d3.tip()
			.attr('class', 'd3-tip')
			.direction('e')
			.offset([0, 10])
			.html(function(d) {
				return "Genome count: " + d.count;
			}),
	/*
		grid = d3.range(25).map(function(i) {
			return {
				'x1': 0,
				'y1': 0,
				'x2': 0,
				'y2': height
			};
		}),

		// tick values: 10, 20, 30, ...
		tickVals = grid.map(function(d, i) {
			return i * 10;
		}),

		grids = vis.append('g')
			.attr('id', 'grid')
			.attr('transform', 'translate(' + offset + ',10)')
			.selectAll('line')
			.data(grid)
		  .enter()
			.append('line')
			.attr({
				'x1': function(d, i) {
					return i * 30;
				},
				'y1': function(d) {
					return d.y1;
				},
				'x2': function(d, i) {
					return i * 30;
				},
				'y2': function(d) {
					return d.y2;
				},
			})
			.style({
				'stroke': '#adadad',
				'stroke-width': '1px'
			}),

		xAxis = d3.svg.axis(),
		yAxis = d3.svg.axis(),
		chart;

		xAxis
			.orient('bottom')
			.scale(x)
			.tickValues(tickVals);
	*/
		yAxis = d3.svg.axis();
		yAxis
			.orient('left')
			.scale(y)
			.tickSize(2)
			.tickFormat(function(d,i) {
				if(clades[i]) {
					return clades[i];
				} else {
					return '';
				}
			})
			.tickValues(d3.range(17));


		// show clades
		vis.append('g')
			.attr("transform", "translate(" + offset + ",10)")
			.attr('id', 'yaxis')
			.call(yAxis);

		chart = vis.append('g')
			.attr("transform", "translate(" + offset + ",0)")
			.attr('id', 'bars')
			.selectAll('rect')
			.data(sortedCladeData)
		  .enter()
			.append('rect')
			.attr('height', barHeight)
			.attr('x', 0)
			.attr('y', function(d, i) {
				return y(i) + 2;
			})
			.attr('width', function(d) {
				return x(d.count);
			})
			.style('fill', function(d, i) {
				return color(i % 20);
			})
			.on('mouseover', tip.show)
			.on('mouseout', tip.hide)
			.on('click', function(d) {
				d3.selectAll('.clade_details')
					.classed('js_hide', true);
				d3.select( '#' + d.id )
					.classed('js_hide', false);
			});

		vis.call(tip);

	}


	d3.selectAll('.clade_details')
		.classed('js_hide',true);

	// tree
	var treeData = [{
		name: "Level 1",
		parent: "null",
		x0: 320,
		children: [{
			name: "Level 1.1",
			parent: "Top Level",
			x0: 250,
			children: [{
					name: "Level 1.1.1",
					parent: "Level 1.1",
					x0: 206,
					children: [{
						name: "P",
						parent: "Level 1.1.1",
						x0: 160,
						children: [{
							name: "P1",
							parent: "P",
							x0: 126,
							children: [{
								name: "P2",
								parent: "P1",
								x0: 100,
								children: [{
									name: "P3",
									parent: "P2",
									x0: 64,
									children: [{
										name: "HLI",
										parent: "P3",
										x0: 46
									}, {
										name: "HLII",
										parent: "P3",
										x0: 82
									}]
								}, {
									name: "LLI",
									parent: "P2",
									x0: 120
								}]
							}, {
								name: "LLII/III",
								parent: "P1",
								x0: 158
							}]
						}, {
							name: "LLIV",
							parent: "P",
							x0: 190
						}]
					}, {
						name: "S1",
						parent: "Level 1.1.1",
						x0: 248,
						children: [{
							name: "5.1A",
							parent: "Level 1.1.1",
							x0: 226
						}, {
							name: "5.1B",
							parent: "Level 1.1.1",
							x0: 265
						}]
					}]
				},

				{
					name: "5.2",
					parent: "Level 1.1",
					x0: 300
				}
			]
		}, {
			name: "5.3",
			parent: "Top Level",
			x0: 336
		}]
	}]

	, root = treeData[0]

	, margin = {
		top: 10,
		right: 20,
		bottom: 10,
		left: 20
	}

	, width = 500 - margin.right - margin.left
	, height = 500 - margin.top - margin.bottom

	, svg = d3.select("#clade")
		.classed('populated', true)
		.append('svg')
		.attr("id","cladogram")
		.attr("width", width + margin.right + margin.left)
		.attr("height", height + margin.top + margin.bottom)
		.append("g")
		.attr("transform", "translate(" + margin.left + "," + margin.top + ")")

	, tree = d3.layout.tree()
		.size([height, width])

	, diagonal = d3.svg.diagonal()
		.projection(function(d) {
			return [d.y, d.x];
		});

	d3.selectAll('.js_vis_loading')
		.remove();

	makeTree(root);

	makeGenusBoxes( svg );

	makeBarChart( res, svg );

}
