/**
 * The select menu is a simple widget designed to filter a dimension by selecting an option from
 * an HTML `<select/>` menu. The menu can be optionally turned into a multiselect.
 * @class selectMenu
 * @memberof dc
 * @mixes dc.baseMixin
 * @example
 * // create a select menu under #select-container using the default global chart group
 * var select = dc.selectMenu('#select-container')
 *                .dimension(states)
 *                .group(stateGroup);
 * // the option text can be set via the title() function
 * // by default the option text is '`key`: `value`'
 * select.title(function (d){
 *     return 'STATE: ' + d.key;
 * })
 * @param {String|node|d3.selection|dc.compositeChart} parent - Any valid
 * [d3 single selector](https://github.com/mbostock/d3/wiki/Selections#selecting-elements) specifying
 * a dom block element such as a div; or a dom element or d3 selection.
 * @param {String} [chartGroup] - The name of the chart group this widget should be placed in.
 * Interaction with the widget will only trigger events and redraws within its group.
 * @returns {selectMenu}
 **/
dc.cboxMenu = function (parent, chartGroup) {
    var GROUP_CSS_CLASS = 'dc-select-group';
    var ITEM_CSS_CLASS = 'dc-select-item';

    var _chart = dc.baseMixin({});

    var _select;
    var _promptText = 'Select all';
    var _multiple = false;
    var _cntrl_type = 'radio';
    var _promptValue = null;
		// generate a random number to use as an ID
    var _randVal = Math.floor( Math.random() * (100000) ) + 1;
    var _order = function (a, b) {
        return _chart.keyAccessor()(a) > _chart.keyAccessor()(b) ?
             1 : _chart.keyAccessor()(b) > _chart.keyAccessor()(a) ?
            -1 : 0;
    };

    var _filterDisplayed = function (d) {
        return _chart.valueAccessor()(d) > 0;
    };

    _chart.data(function (group) {
        return group.all().filter(_filterDisplayed);
    });

    _chart._doRender = function () {
        _chart.select('ul').remove();
        _select = _chart.root()
        	.append('ul')
            .classed(GROUP_CSS_CLASS, true);

		var enter_sel = _select
			.selectAll('li.' + ITEM_CSS_CLASS)
			.data(_chart.group().all(), function (d) { return _chart.keyAccessor()(d); });

		enter_sel.enter()
		.append('li')
			.classed(ITEM_CSS_CLASS, true)
		.append('input')
			.attr('type', _cntrl_type )
			.attr('value', function (d) { return _chart.keyAccessor()(d); })
			.attr('name', 'domain_'+_randVal)
			.attr('id', function (d,i) { return 'input_'+ _randVal +'_'+i });
		enter_sel.append('label')
			.attr('for', function (d,i) { return 'input_'+ _randVal +'_'+i })
			.text( _chart.title() )
			;

		if ( _multiple ) {
			_select
			.append('li')
			.append('input')
			.attr('type','reset')
			.text( _promptText )
			.on('click', onChange);
			;
		}
		else {
			// 'all' option
			var li = _select
				.append('li');
			li.append('input')
				.attr('type', _cntrl_type )
				.attr('value', _promptValue )
				.attr('name', 'domain_'+_randVal)
				.attr('id', function (d,i) { return 'input_'+ _randVal +'_all' })
				.property('checked',true);
			li.append('label')
				.attr('for', function (d,i) { return 'input_'+ _randVal +'_all' })
				.text( _promptText );
		}
        _select.on('change', onChange);
        _chart._doRedraw();
        return _chart;
    };

    _chart._doRedraw = function () {
//        setAttributes();
        renderOptions();
        // select the option(s) corresponding to current filter(s)
        if (_chart.hasFilter() && _multiple) {
//             _select.select('input[value=""]')
//             	.property('checked', false);
            _select.selectAll('input')
//                 .property('selected', function (d) {
                 .property('checked', function (d) {
                    return d && _chart.filters().indexOf(String(_chart.keyAccessor()(d))) >= 0;
                });
        } else if (_chart.hasFilter()) {
            _select.select('input[value="' + _chart.filter() + '"]')
            	.property('checked', true );
//         } else {
//             _select.select('input[value=""]')
//             	.property('checked', true);
        }
        return _chart;
    };

    function renderOptions() {
		var options = _select
		.selectAll('li.' + ITEM_CSS_CLASS)
		.data(_chart.data(), function (d) { return _chart.keyAccessor()(d); });

		console.log( _chart.data() );

// 		options.enter()
// 			.append('li')
// 				.classed(ITEM_CSS_CLASS, true);
// 		options.enter()
// 			.append('input')
// 				.attr('type', _cntrl_type )
// 				.attr('value', function (d) { return _chart.keyAccessor()(d); })
// 				.attr('id', function (d,i) { return 'input_'+ _randVal +'_'+i });
// 		options.enter()
// 			.append('label')
// 				.attr('for', function (d,i) { return 'input_'+ _randVal +'_'+i })
// 				;

//      update labels, input abledness
		options
			.classed('disabled', false )
			.selectAll('label').text( _chart.title())
//			.selectAll('input').property('disabled', false)
			;

		options.exit()
			.classed('disabled', true)
			.select('label').text( _chart.title())
//			.select('input').property('disabled', true)
		//	.remove()
        	;
		_select
			.selectAll('li.' + ITEM_CSS_CLASS)
			.sort(_order);

//        _select.on('change', onChange);
        return options;
    }

    function onChange (d, i) {
		var values
		, target = d3.select( d3.event.target )
		, options;
		if ( ! target.datum() ) {
			values = _promptValue || null;
		}
        else {
			options = d3.select(this).selectAll('input')
			.filter(function(o){
				if ( o ) {
					return this.checked;
				}
			});
			values = options[0].map(function (option) {
				return option.value;
			});
			// console.log(values);
			// check if only prompt option is selected
			if (!_multiple && values.length === 1) {
				values = values[0];
			}
		}
        _chart.onChange(values);
    }

    _chart.onChange = function (val) {
        if (val && _multiple) {
            _chart.replaceFilter([val]);
        } else if (val) {
            _chart.replaceFilter(val);
        } else {
            _chart.filterAll();
        }
        dc.events.trigger(function () {
            _chart.redrawGroup();
        });
    };

//     function setAttributes () {
//         if (_multiple) {
//             _select.attr('multiple', true);
//         } else {
//             _select.attr('multiple', null);
//         }
//     }

    /**
     * Get or set the function that controls the ordering of option tags in the
     * select menu. By default options are ordered by the group key in ascending
     * order.
     * @name order
     * @memberof dc.selectMenu
     * @instance
     * @param {Function} [order]
     * @example
     * // order by the group's value
     * chart.order(function (a,b) {
     *     return a.value > b.value ? 1 : b.value > a.value ? -1 : 0;
     * });
     **/
    _chart.order = function (order) {
        if (!arguments.length) {
            return _order;
        }
        _order = order;
        return _chart;
    };

    /**
     * Get or set the text displayed in the options used to prompt selection.
     * @name promptText
     * @memberof dc.selectMenu
     * @instance
     * @param {String} [promptText='Select all']
     * @example
     * chart.promptText('All states');
     **/
    _chart.promptText = function (_) {
        if (!arguments.length) {
            return _promptText;
        }
        _promptText = _;
        return _chart;
    };

    /**
     * Get or set the function that filters option tags prior to display. By default options
     * with a value of < 1 are not displayed.
     * @name filterDisplayed
     * @memberof dc.selectMenu
     * @instance
     * @param {function} [filterDisplayed]
     * @example
     * // display all options override the `filterDisplayed` function:
     * chart.filterDisplayed(function () {
     *     return true;
     * });
     **/
    _chart.filterDisplayed = function (filterDisplayed) {
        if (!arguments.length) {
            return _filterDisplayed;
        }
        _filterDisplayed = filterDisplayed;
        return _chart;
    };

    /**
     * Controls the type of select menu. Setting it to true converts the underlying
     * HTML tag into a multiple select.
     * @name multiple
     * @memberof dc.selectMenu
     * @instance
     * @param {boolean} [multiple=false]
     * @example
     * chart.multiple(true);
     **/
    _chart.multiple = function (multiple) {
        if (!arguments.length) {
            return _multiple;
        }
        _multiple = multiple;
        if ( _multiple) {
        	_cntrl_type = 'checkbox';
        }
        else {
        	_cntrl_type = 'radio';
        }

        return _chart;
    };

    /**
     * Controls the default value to be used for
     * [dimension.filter](https://github.com/crossfilter/crossfilter/wiki/API-Reference#dimension_filter)
     * when only the prompt value is selected. If `null` (the default), no filtering will occur when
     * just the prompt is selected.
     * @name promptValue
     * @memberof dc.selectMenu
     * @instance
     * @param {?*} [promptValue=null]
     **/
    _chart.promptValue = function (promptValue) {
        if (!arguments.length) {
            return _promptValue;
        }
        _promptValue = promptValue;

        return _chart;
    };

    return _chart.anchor(parent, chartGroup);
};
