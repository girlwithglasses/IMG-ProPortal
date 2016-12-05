/*
  d3.phylogram.js
  Wrapper around a d3-based phylogram (tree where branch lengths are scaled)
  Also includes a radial dendrogram visualization (branch lengths not scaled)
  along with some helper methods for building angled-branch trees.

  Copyright (c) 2013, Ken-ichi Ueda

  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

  Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer. Redistributions in binary
  form must reproduce the above copyright notice, this list of conditions and
  the following disclaimer in the documentation and/or other materials
  provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE.

  DOCUEMENTATION

  d3.phylogram.build(selector, nodes, options)
    Creates a phylogram.
    Arguments:
      selector: selector of an element that will contain the SVG
      nodes: JS object of nodes
    Options:
      width
        Width of the vis, will attempt to set a default based on the width of
        the container.
      height
        Height of the vis, will attempt to set a default based on the height
        of the container.
      vis
        Pre-constructed d3 vis.
      tree
        Pre-constructed d3 tree layout.
      children
        Function for retrieving an array of children given a node. Default is
        to assume each node has an attribute called "branchset"
      diagonal
        Function that creates the d attribute for an path. Defaults to a
        right-angle diagonal.
      skipTicks
        Skip the tick rule.
      skipBranchLengthScaling
        Make a dendrogram instead of a phylogram.

  d3.phylogram.buildRadial(selector, nodes, options)
    Creates a radial dendrogram.
    Options: same as build, but without diagonal, skipTicks, and
      skipBranchLengthScaling

  d3.phylogram.rightAngleDiagonal()
    Similar to d3.diagonal except it create an orthogonal crook instead of a
    smooth Bezier curve.

  d3.phylogram.radialRightAngleDiagonal()
    d3.phylogram.rightAngleDiagonal for radial layouts.

*/
/*jshint laxcomma: true */
/*jshint plusplus: false */
/* globals d3 */
(function() {

	'use strict';
	if (!d3) { throw "d3 wasn't included!"; }
  d3.phylogram = {};

  d3.phylogram.rightAngleDiagonal = function() {

    var projection = function(d) { return [d.y, d.x]; };

    var path = function(pathData) {
      return "M" + pathData[0] + ' ' + pathData[1] + " " + pathData[2];
    };

    function diagonal(diagonalPath, i) {
      var source = diagonalPath.source,
          target = diagonalPath.target,
          midpointX = (source.x + target.x) / 2,
          midpointY = (source.y + target.y) / 2,
          pathData = [source, {x: target.x, y: source.y}, target];
      pathData = pathData.map(projection);
      return path(pathData);
    }

    diagonal.projection = function(x) {
      if (!arguments.length){
      	return projection;
      }
      projection = x;
      return diagonal;
    };

    diagonal.path = function(x) {
      if (!arguments.length){
      	return path;
      }
      path = x;
      return diagonal;
    };

    return diagonal;

  };


  // SCALEBRANCHLENGTHS
  // This function goes through the tree and scales the /horizontal/ coordinates
  // for each leaf and branch node.  The distance between leaf nodes is
  // not changed.

  function scaleBranchLengths(nodes, w) {
    // Visit all nodes and adjust y pos width distance metric
    var visitPreOrder = function(root, callback) {
      callback(root);
      if (root.children) {
        for (var i = root.children.length - 1; i >= 0; i--){
          visitPreOrder(root.children[i], callback);
        }
      }
    };
    visitPreOrder(nodes[0], function(node) {
      node.rootDist = (node.parent ? node.parent.rootDist : 0) + (node.length || 0);
    });
    var rootDists = nodes.map(function(n) { return n.rootDist; });
    var yscale = d3.scale.linear()
		.domain([0, d3.max(rootDists)])
		.range([0, w]);
    visitPreOrder(nodes[0], function(node) {
      node.y = yscale(node.rootDist);
    });
    return yscale;
  }

  /* ----------------------Scale branch lengths_equal----------------------
  function scaleBranchLengths_equal(nodes, w) {
	var maxDepth = d3.max(nodes.map(function(n) { return n.depth; }));
	var step = w/maxDepth;

    // Visit all nodes and adjust y pos width distance metric
    var visitPreOrder = function(root, callback) {
      callback(root);
      if (root.children) {
        for (var i = root.children.length - 1; i >= 0; i--){
          visitPreOrder(root.children[i], callback);
        }
      }
    };

	visitPreOrder(nodes[0], function(node) {
      node.rootDist = (node.parent ? node.parent.rootDist : 0) + (node.depth*maxDepth || 0);
    });

    var rootDists = nodes.map(function(n) { return n.rootDist; });

	var yscale = d3.scale.linear()
		.domain([0, d3.max(rootDists)])
	    .range([0, w]);

    visitPreOrder(nodes[0], function(node) {
      node.y = yscale(node.rootDist);
      node.y = w - (step* (maxDepth-node.depth));
    });
    return yscale;
  }
*/
function updateTree(vis, w, lh, treeType, tree, nodes, diagonal) {

	var yscale;

	// Update node x and y values
	if ("phylogram" === treeType) {
		yscale = scaleBranchLengths(nodes, w);
	}

/**
		else if ("cladogram" === treeType) {

			var yscale = d3.scale.linear()
			  .domain([0, w])
			  .range([0, w]);

			//yscale = scaleBranchLengths_equal(nodes,w)
			//diagonal = d3.svg.diagonal()
    	}
*/
		diagonal = d3.phylogram.rightAngleDiagonal();

		// Draw tree branches
		var link = vis.selectAll("path.link")
			.data(tree.links(nodes))
		.enter().append("path")
			.attr("class", "link")
			.attr("d", diagonal);		// diagonal holds the horizontal distances?

		var node = vis.selectAll("g.node")
			.data(nodes)
		  .enter().append("g")
			.attr("class", function(d) {
				if (d.children) {
					if (d.depth === 0) {
						return "rootnode";
					}
					return "innernode";
				}
				return "leafnode";
			})
			.attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; });

        return yscale;
	}

  // d3.phylogram.BUILD
  // From index.html,
  //	selector = #phylogram.  <div id='phylogram'></div> is explicitly added to <body>
  //	nodes = newick
  // 	options = collection of options
  //-----------------------------------------------------
  d3.phylogram.build = function(selector, nodes, options) {
    options = options || {};

    // ADD PHYLOGRAM

    //var w = options.width / 3,    // Make the tree take up the leftmost 1/4 of the vis.
    var w = options.treeWidth,                    // Make tree an absolute width
        h = options.height,
        rowHeight = options.rowHeight,
        rightPaneEdge = options.rightPaneEdge,
        topMargin = options.topMargin,
		svgW = options.width;

    // d3.layout.cluster() creates a dendrogram.
    var tree = options.tree || d3.layout.cluster()
      .size([h, w])
      .separation( function(a,b) { return 1; } )
      .sort(function(node) { return node.children ? node.children.length : -1; })
//       .children(options.children || function(node) {
//         return node.branchset
//       });
	;
    // Append a svg element if not already present?
    var vis = options.vis || d3.select(selector).append("svg")
        .attr("width", svgW) //this adds room for labels after the right-most leaf.
        .attr("height", h+100)  // the 100 covers the bottom portion of the tree, making room for top margin
      .append("g").attr("transform", "translate(100,50)");	// moves g right 70px to make room for distance labels, 50 down to make room for headers.

    //tree.size([h,200]);
    nodes = tree(nodes);


    //var diagonal = options.diagonal || d3.phylogram.rightAngleDiagonal();
    //var diagonal = d3.svg.diagonal();
    var diagonal = d3.phylogram.rightAngleDiagonal();


	var yscale = updateTree(vis, w, h, options.treeType, tree, nodes, diagonal);


    // Draw leaf labels and nodes
    vis.selectAll('.leafnode')
    	.append("text")
    	.classed('leafnode_label', true )
//          .attr("class", "id_leafnode_label")
		.attr("dx", 10)
		.attr("dy", 3)
		.attr("text-anchor", "start")		// move to css
		.attr('font-size', '12px')		// move to css
		.text(function(d) {
//			return options.all_data.gene_data[ +d.name ].gene_oid ||

			return d.name;
		});
    vis.selectAll('.leafnode').append('circle');
    vis.selectAll('.rootnode').append('circle');
    //vis.selectAll('g.innernode').append('text').text( function(d) { return d.depth; });

    // Draw branch lengths
    vis.selectAll('.innernode')
      .append("text")
		.classed('branchLengths', true)
        .attr("dx", -6)
        .attr("dy", -6)
        .attr("text-anchor", 'end')		// move to css
        .attr('font-size', '10px')		// move to css
        .attr('fill', '#ccc')			// move to css
        .text(function(d) {
        	return d.length;
        });

	  vis.selectAll('line')
          .data(yscale.ticks(10))
        .enter()
        	.append('line')
        	.classed('distTicks', true)
          .attr('y1', 0)
          .attr('y2', h)
          .attr('x1', yscale)
          .attr('x2', yscale)
          .attr("stroke", "#ddd");			// move to css

      vis.selectAll("text.rule")
          .data(yscale.ticks(10))
        .enter().append("text")
        	.classed('rule distTicks', true)
          .attr("x", yscale)
          .attr("y", 0)
          .attr("dy", -3)
          .attr("text-anchor", "middle")	// move to css
          .attr('font-size', '10px')		// move to css
          .attr('fill', '#ccc')				// move to css
          .text(function(d) { return Math.round(d*100) / 100; });


	// if active, draw heatmap
    if (options.heatmap) {
		// Build heatmap
		var //h_data = options.heatmap.data
		c
		, cols = options.heatmap.cols
		, rows = vis.selectAll('.leafnode')
		, zScale_data = {}
		, i = 0
		;

		for ( c in cols ) {
//		cols.forEach( function(c){
			zScale_data[ c ] = d3.scale.quantile()
				.domain( d3.extent(
					Object.keys( options.all_data.gene_data ),
					function(d){
						return cols[c].fn( options.all_data.gene_data[d] );
					})
				)
				.range( d3.range(9) );
//		});
		}
//		cols.forEach( function(c,i){
		for ( c in cols ) {
			rows
				.append("rect")
			//	.attr("class", "heatmap")  // not working right now
				.attr("y", (rowHeight/2)-rowHeight)
				.attr("x", function(d){
					return (rightPaneEdge - d.y) + i*rowHeight; })    // d.y --> d.x!
				.attr("width", rowHeight-1)
				.attr("height", rowHeight-1)
				.attr("class", function(d) {
					return 'q' + zScale_data[c]( cols[c].fn( options.all_data.gene_data[d.name] ) ) + '-9';
				});
			rows
				.append("text")
				.attr("width", 10)
				.attr("y", (rowHeight/2)-rowHeight + (rowHeight/2) + 2)
				.attr("x", function(d) { return (rightPaneEdge - d.y) + (i*rowHeight) + (rowHeight/2); })    // d.y --> d.x!
				.attr("text-anchor", "middle")									// move to css
				.attr('font-family', 'Helvetica Neue, Helvetica, sans-serif')	// move to css
				.attr('font-size', '10px')										// move to css
				.attr('fill', 'black')											// move to css
				.text(function(d){
					return cols[c].fn( options.all_data.gene_data[d.name] )
				});
//		});
			i++;
		}

	}




//  CONTROL PANEL FUNCTIONALITY
//=====================================================================

	var vis_node = d3.select( 'svg' )
		, vnp = vis_node.node().parentNode
		, vnpp = vnp.parentNode
		;
	vis_node.classed('show_leafnode_labels', true);
    // Draw tree distance ruler (only if treeType = Phylogram!)
    vis_node.classed('show_dist_rule', options.showDistRuler);

	d3.select("#o_treeType")
   	 .on("change", function() {
   	 	var v = d3.select(this).property('value'),
   	 		yscale = updateTree(vis, w, h, v, tree, nodes, diagonal);

   	 	if ("phylogram" === v) {
			d3.select("#o_showDistRuler").property("disabled", false);
   	 	} else if ("cladogram" === v) {
	 		d3.select("#o_showDistRuler").property("disabled", true);
        }
   	 })
   	 .selectAll("option")
   	 .property("selected", function(d) {
   	 	if (this.value === options.treeType){
   	 		return true;
   	 	}
   	 });


	d3.select("#treeWidthLabel").text(options.treeWidth);

	d3.select("#o_treeWidth")
	  .attr("value", options.treeWidth)
      .on("input", function() {
      	d3.select("#treeWidthLabel").text(this.value);
      	d3.select("#o_treeWidth").property("value", this.value);
      	tree.size([h, o_treeWidth.value]);
   	  });

    d3.select("#o_leafHeight")
      .on("input", function() {
      	d3.select("#leafHeightLabel").text(this.value);
      	d3.select("#o_leafHeight").property("value", this.value);
  	  });

    d3.select("#o_showLeafLabels")
      .on("change", function(){
      	vis_node.classed('show_leafnode_labels', this.checked );
      });

	d3.select("#o_showDistRuler")
		.property('checked', function() {
			return options.showDistRuler ? true : false;
		})
		.property('disabled', function(){
			if ( d3.select("#o_treeType").property('value')==="phylogram" ) {
				return false;
   	 		} else if (d3.select("#o_treeType").property('value')==="cladogram") {
	 			return true;
        	}
		})
     	.on("change", function() {
			vis_node.classed('show_distTicks', this.checked);
// 			if (id_distTicks.active) {
// 				vis.selectAll(".distTicks").style("opacity", 0);
// 				id_distTicks.active = false;
// 			} else {
// 				vis.selectAll(".distTicks").style("opacity", 1);
// 				id_distTicks.active = true;
// 			}
	    });

   d3.select("#o_showDistLabels")
     .on("change", function() {
		vis_node.classed('show_branchLengths', this.checked);
//         var active = id_branchLengths.active ? false : true,
//           newOpacity = active ? 0 : 1;
//           vis.selectAll(".branchLengths").style("opacity", newOpacity);
//           id_branchLengths.active = active;
     });

    return {tree: tree, vis: vis};
  };
}());
