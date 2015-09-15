var AniPlotter = (function() {
  var my = {};

  my.plot = function(svg_id, pt_type, source, finished_cb) { // source: {url,data}
    var svg_dom = document.getElementById(svg_id);
    while(svg_dom.firstChild) {
      svg_dom.removeChild(svg_dom.firstChild);
    }

    var plotData = function(svg_id, data) {
      var svg_element = document.getElementById(svg_id);
      var margin = {top: 40, right: 60, bottom: 40, left: 40},
          width = svg_element.width.baseVal.value - margin.left - margin.right,
          height = svg_element.height.baseVal.value - margin.top - margin.bottom;

      // Scales and axes. Note the inverted domain for the y-scale: bigger is up!
      var x = d3.scale.linear().range([0, width]),
          y = d3.scale.linear().range([height, 0]),
          //xAxis = d3.svg.axis().scale(x).tickSize(-height).tickSubdivide(true),
          xAxis = d3.svg.axis().scale(x).tickSubdivide(true),
          yAxis = d3.svg.axis().scale(y).ticks(4).orient("right");

      //per species hue
      var hue = d3.scale.linear().domain([0, data.length-1]).range([0, (data.length-1) / data.length]);

      // Compute the minimum and maximum date, and the maximum price.
      var extents_ani = [];
      var extents_af = [];
      data.map(function(species) {
        var i_extents_ani = d3.extent(species.samples, function(sample) { return sample.final_ani; });
        var i_extents_af = d3.extent(species.samples, function(sample) { return sample.final_af; });
        i_extents_ani.map(function(val) { extents_ani.push(val); });
        i_extents_af.map(function(val) { extents_af.push(val); });
      });
      x.domain(d3.extent(extents_ani));
      y.domain([0.0, 1.0]);//d3.extent(extents_af));

      // Define the div for the tooltip
      var tooltip_div = d3.select("body").append("div")
        .attr("class", "tooltip")
        .style("opacity", 0);

      // Add an SVG element with the desired dimensions and margin.
      var svg = d3.select('#'+svg_id)
        .append("g")
          .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

      // Add the clip path.
      svg.append("clipPath")
          .attr("id", "clip")
        .append("rect")
          .attr("width", width)
          .attr("height", height);

      // Add the x-axis.
      svg.append("g")
          .attr("class", "x axis")
          .attr("transform", "translate(0," + height + ")")
          .call(xAxis);
      svg.append("text")      // text label for the x axis
          .attr("x", width/2 )
          .attr("y",  height+margin.bottom )
          .style("text-anchor", "middle")
          .text("Final ANI");

      // Add the y-axis.
      svg.append("g")
          .attr("class", "y axis")
          .attr("transform", "translate(" + width + ",0)")
          .call(yAxis);
      svg.append("text")
          .attr("dy", "1em")
          .style("text-anchor", "middle")
          .text("Final AF")
          .attr("y", 0 - margin.left)
          .attr("x", 0 - (height / 2))
          .attr("transform", "translate("+(width+margin.left+margin.right-30)+",0) rotate(-90)");

      // Add the legend.
      var legend = svg.append("g")
          .attr("class", "legend")
          //.attr("transform", "translate("+(width-40)+"," + 200 + ")")
          .selectAll("text")
          .data(data)
          .enter();
      legend
          .append("rect")
          .attr("x", 0)
          .attr("y", function(s, i) { return i*20 - 10; } )
          .attr("width", 10)
          .attr("height", 10)
          .attr("style", function(s,i) {
            var rgb = d3.hsl(360.0*hue(i), 1.0, 0.5).rgb().toString();
            return "fill:"+rgb+";stroke:black;stroke-width:1;fill-opacity:1.0;stroke-opacity:1.0";
          });
      legend
          .append("text")      // text label for each species
          .attr("x", 15 )
          .attr("y", function(species, i) { return i*20; } )
          .text(function(species) { return species.species; });

      data.map(function(species, i) {
        var rgb = d3.hsl(360.0*hue(i), 1.0, 0.5).rgb().toString();
        var species = svg.selectAll('species_'+i).data(species.samples);
        species.enter().append('circle');
        species
          .attr('r', 5)
          .attr('fill', rgb)
          .style('opacity', 0.3)
          .attr('cx', function(d) { return x(d.final_ani); })
          .attr('cy', function(d) { return y(d.final_af); })
          .on("mouseover", function(d) {
            tooltip_div.transition()
              .duration(200)
              .style("opacity", .9);
            tooltip_div.html("Final ANI: "+d.final_ani+"<br/>Final AF: "+d.final_af)
              .style("left", (d3.event.pageX) + "px")
              .style("top", (d3.event.pageY - 28) + "px");
          })
          .on("mouseout", function(d) {
            tooltip_div.transition()
              .duration(500)
              .style("opacity", 0);
          });
        species.exit().remove();
      });

      if(finished_cb) {
        finished_cb();
      }
    };

    if( source.url !== undefined ) {
      d3.json(source.url, function(err, data) {
        if(!err) {
          plotData(svg_id, data);
        } else {
          console.log(err);
        }
      });
    } else {
      plotData(svg_id, source.data);
    }

  };

  return my;
}());

