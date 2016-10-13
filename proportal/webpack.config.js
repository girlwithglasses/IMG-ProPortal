/* jshint laxcomma: true */
// http://www.jonathan-petitcolas.com/2015/05/15/howto-setup-webpack-on-es6-react-application-with-sass.html
// https://github.com/petehunt/webpack-howto

'use strict';

var ExtractTextPlugin = require('extract-text-webpack-plugin')
, webpack = require('webpack')
, code_directory = '/Users/gwg/code/'
;

// use live reloading in development:
function getEntrySources(sources) {
	if (process.env.NODE_ENV !== 'production') {
		sources.push('webpack-dev-server/client?http://localhost:8080');
	}
	return sources;
}

/* in module.exports:

	helloWorld: getEntrySources([
		'./js/helloworld.js'
	])

*/

module.exports = {

	// This file says Webpack to take ./js/helloworld as an input and to process it into a public/js/helloWorld.js file.
	entry: {
//		helloWorld: __dirname + '/src/js/helloworld'	// source file -- contains require('./file1')
		scroller: [ code_directory + 'd3.chart.img/example/text.js']
//		page2: ["./app/js/main2.js", "topojson"],
	},

	output: {
		path: __dirname + 'public/js/',
		filename: '[name].js' // output of compiling the scripts
	},

	externals: {
		d3: 'd3'
	},

	// ...
	module: {
		loaders: [
			// ES6 module compilation
			{
				test: /\.js$/,
				loaders: ['babel'],
				exclude: /node_modules/
			}
			// SASS compilation ==> css, then saved to proportal.css
			// need to add autoprefixer, pixrem, minifier?
// 			{
// 				test: /\.scss$/,
// 				loader: ExtractTextPlugin.extract('css!sass')
// 			}
		]
	},
	plugins: [
		new ExtractTextPlugin('public/css/proportal.css', {
			allChunks: true
		}),

	  // This plugin makes a module available as variable in every module
	  new webpack.ProvidePlugin({
		d3: "d3",
	  })
	],

	resolve: {
		// require('file') instead of require('file.coffee')
		extensions: [ '', '.js', '.json' ],
		alias: {
			'npm': __dirname + '/node_modules/',
			'code': code_directory,
			'd3': code_directory + 'd3/'
		},
		modulesDirectories: [ code_directory ]
	}
};
