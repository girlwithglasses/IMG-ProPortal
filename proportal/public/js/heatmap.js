if (!d3) { 
  throw "d3 wasn't included!"
 };

(function() {
  heatmap = {}    // Declares 'heatmap' namespace to use in index.html
  

	// Builds a row containing a label and 1..N rectangles where N=length of p 
	// This is called in the statement above.
	//--------------------------------------------------------------------------
	function buildRow (row, options){
		console.log(row);

		row.append("text")
			.text(function(d) { return d['Locus Tag']; })
			.attr("x", 0)
			.attr("dy", "1em") 
			.attr("dx", '-0.8em')
			.attr("text-anchor", "end");

// 		for (var j = 0; j<p.length; j++){

// 		d3.select(this).append("rect")
// 			.attr("width", sqLen)
// 			.attr("height", sqLen)
// 			.attr("x", x + j*(sqLen+sqSpace))
// 			.attr("y", i*(sqLen+sqSpace))
// 			.style("fill", function(d) { return  propColors[j](d[p[j]]) });
// 		}
	}
		
	// Build the heatmap.  Call this from index.html
	//   selector = <div class=#heatmap>
	//--------------------------------------------------------------------------
			
 	heatmap.build = function(selector, options) {
	  options = options || {}

      var w = options.width || d3.select(selector).style('width') || d3.select(selector).attr('width'),
          h = options.height || d3.select(selector).style('height') || d3.select(selector).attr('height');
        
      // Append a svg element if not already present?
      var vis = options.vis || d3.select(selector).append("svg:svg")
        .attr("width", w)
        .attr("height", h)
        .append("svg:g").attr("transform", "translate(20, 20)");	// moves svg:g down and right 20
		
	  var p = options.p;		

// 		// Step 1: Define a single color scale for all properties in p.
// 		// 		We will then make a separate scale for each p.
// 		//------------------------------------------------------
	
		var propColors = [];
		for (var j=0; j<p.length; j++){
			thisP = imgData.map(function(o) { return o[p[j]] } );
			var maxVal = Math.max.apply(Math, thisP); 
			var minVal = Math.min.apply(Math, thisP); 

			var color = d3.scale.linear()
			  .domain([minVal, maxVal])
			  .range(["white", "blue"]);

			propColors.push(color); 
		} 

	
// 		// Need to build the Property labels at the top of the columns first.

		vis.selectAll("g.row")
			.data(imgData)
		  .enter().append("g")
		  	.attr("class", "row")

		var rows = d3.selectAll("g.row");

		rows.append("text")
			.text(function(d) { return d['Locus Tag']; })
			.attr("x", 100)
			.attr("y", function(d,i){ return i * (options.sqLen + options.sqSpace)})
			.attr("dy", "1em")
			.attr("dx", '-0.8em')
			.attr("text-anchor", "end");			

		for (var j = 0; j<p.length; j++){
			rows.append("rect")
				.attr("width", options.sqLen)
				.attr("height", options.sqLen)
				.attr("x", 100 + j*(options.sqLen + options.sqSpace))
				.attr("y", function(d,i) {return i*(options.sqLen + options.sqSpace)} )
				.style("fill", function(d) { return  propColors[j](d[p[j]]) });
		}




		console.log(rows)
//		buildRow(row, options)	
	}
	
	
})();