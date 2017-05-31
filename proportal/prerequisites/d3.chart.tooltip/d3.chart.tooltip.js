/*! d3.chart.tooltip - v0.1.0
 *  License: MIT Expat
 *  Author: Irene Ros
 *  Date: 2013-06-20
 */
/* global d3 */
d3.chart("TooltipMixinChart", {
  initialize: function(options) {
    options = options || {};

    var _errors = {
      noText : "You need to call .text on your tooltip mixin " +
                  "and provide it a rendering function!"
    };

    // Options must contain a layer onto which the tooltips will be added.
    this.tooltippedLayer = options.layer;
    this.tooltippedSelectionType = options.type;

    if ( options.text ) {
    	this.text( options.text );
    }

    this.point = options.layer.base.node().createSVGPoint();
	this.svgBounds = {};

    // The base should be the body!
    var tooltipBase = this.base
      .append("div")
      .classed("tooltip", true);

    this.layer("tooltips", tooltipBase, {
      dataBind: function() {

        // we only want to bind one data element to it
        // so the original data doesn't even matter
        // but we do need to create one element for it.
        return this.selectAll("div")
          .data([true]);
      },

      insert: function() {
        return this.append("div")
        	.classed('d3-tip js_hide', true)
        	;
      },

      events : {
        enter : function() {
          var chart = this.chart();
          var tooltip = this;

          // find all the elements that we are listening to
          // based on the selection type
          chart.tooltippedLayer.base
            .selectAll(chart.tooltippedSelectionType)

          .on("mouseover.tooltip", function(d, i) {

			tooltip.classed('js_hide',false);
			var pos = chart.get_position( this );

            // position the tooltip in the right position
            // and set its content to whatever the result of
            // the text function that was provided is.
            tooltip.style({
              left: (d3.event.pageX + 20)+"px",
              top: (d3.event.pageY - 20)+"px",
              position: "absolute",
              "z-index": 1001
            }).html(function(){
              if (typeof chart._textFn === "undefined") {
                throw new Error(_errors.noText);
              }
              return chart._textFn(d,i,tooltip);
            });

          })

          // when moving the tooltip, re-render its position
          // and update the text in case it's position dependent.
          .on("mousemove.tooltip", function(d, i) {

			tooltip.classed('js_hide',false);
			var pos = chart.get_position( this );
            tooltip.style({
				left: (d3.event.pageX + 20)+"px",
				top:  (d3.event.pageY - 20)+"px"
            }).html(function(){
              if (typeof chart._textFn === "undefined") {
                throw new Error(_errors.noText);
              }
              return chart._textFn(d,i,tooltip);
            });

          })

          // when exiting the tooltip, just set its contents
          // to nothing.
          .on("mouseout.tooltip", function() {
				tooltip.classed('js_hide',true);
          });

        }
      }
    });
  },

	get_position: function( d ) {

		var el   = d || d3.event.target;

		while (undefined === typeof el.getScreenCTM && undefined === el.parentNode) {
			el = el.parentNode;
		}

      var bbox       = {},
          matrix     = el.getScreenCTM(),
          tbbox      = el.getBBox(),
          width      = tbbox.width,
          height     = tbbox.height,
          x          = tbbox.x,
          y          = tbbox.y
        , point = this.point
		, page_x = (window.pageXOffset !== undefined)
		  ? window.pageXOffset
		  : (document.documentElement || document.body.parentNode || document.body).scrollLeft
		, page_y = (window.pageYOffset !== undefined)
		  ? window.pageYOffset
		  : (document.documentElement || document.body.parentNode || document.body).scrollTop
		  ;

      point.x = x
      point.y = y
      bbox.nw = point.matrixTransform(matrix)
      point.x += width
      bbox.ne = point.matrixTransform(matrix)
      point.y += height
      bbox.se = point.matrixTransform(matrix)
      point.x -= width
      bbox.sw = point.matrixTransform(matrix)
      point.y -= height / 2
      bbox.w  = point.matrixTransform(matrix)
      point.x += width
      bbox.e = point.matrixTransform(matrix)
      point.x -= width / 2
      point.y -= height / 2
      bbox.n = point.matrixTransform(matrix)
      point.y += height
      bbox.s = point.matrixTransform(matrix)

		point.x = d3.mouse(el)[0];
		point.y = d3.mouse(el)[1];
		bbox.mouse = point.matrixTransform(matrix);

		point.x = d3.event.pageX;
		point.y = d3.event.pageY;
		bbox.page = point.matrixTransform(matrix);

		point.x = x + width / 2
		point.y = y + height / 2
		bbox.center = point.matrixTransform(matrix);
			bbox;
	},

  // the setter for the function that will render the
  // contents of the tooltip. It must be called before a chart
  // .draw is called.
  text: function(d) {
    if (arguments.length === 0) { return this._textFn; }
    this._textFn = d3.functor(d);
    return this;
  }
});
