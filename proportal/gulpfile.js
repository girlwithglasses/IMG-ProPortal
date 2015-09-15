/* jshint node: true */
"use strict";

var gulp = require( "gulp" ),
	/** @type {Object} Loader of Gulp plugins from `package.json` */
	p = require( "gulp-load-plugins" )(),
	source = 'src/',
	ppcss  = 'proportal.css',
	ppsass = 'proportal.scss',
	ppjs   = 'proportal.js',
	target = 'public/',
	/** @type {Array} JS source files to concatenate and uglify */
	uglifySrc = [

	],
	/** @type {Object of Array} CSS source files to concatenate and minify */
	cssminSrc = {
		development: [
			/** Normalize */
			source + "bower/normalize.css/normalize.css",
			/** Theme style */
			target + "css/" + ppcss
		],
		production: [
			/** Normalize */
			source + "bower/normalize.css/normalize.css",
			/** Theme style */
			target + "css/" + ppcss
		]
	},
	/** @type {String} Used inside task for set the mode to 'development' or 'production' */
	env = (function() {
		/** @type {String} Default value of env */
		var env = "development";

		/** Test if there was a different value from CLI to env
			Example: gulp styles --env=production
			When ES6 will be default. `find` will replace `some`  */
		process.argv.some(function( key ) {
			var matches = key.match( /^\-{2}env\=([A-Za-z]+)$/ );

			if ( matches && matches.length === 2 ) {
				env = matches[1];
				return true;
			}
		});
		return env;
	})(),
	onError = function(err) {
		console.log(err);
	};

/** Clean */
gulp.task( "clean", require( "del" ).bind( null, [ ".tmp", "dist" ] ) );

/** Copy */

gulp.task( "copy", function() {
	return gulp.src([
//			source + '*.{php,png,css}',
//			source + 'modules/*.php',
//			source + 'img/**/*.{jpg,png,svg,gif,webp,ico}',
//			source + 'fonts/*.{woff,woff2,ttf,otf,eot,svg}',
//			source + 'languages/*.{po,mo,pot}'
		], {
			base: source
		})
		.pipe( gulp.dest( target ) );
});

/** CSS Preprocessors */
gulp.task("libsass", function () {
	return gulp.src( source + "css/sass/" + ppsass )
		.pipe( p.plumber({
            errorHandler: onError
        }))
		.pipe( p.sass({ "errLogToConsole": true }) )
		.pipe( p.autoprefixer( "last 2 version" ) )
//		.pipe( p.pixrem( 16, { atrules: true } ) )
		.pipe( gulp.dest( target + 'css/') );
});

/** STYLES */
gulp.task( "styles", [ "libsass" ], function() {
	console.log( "`styles` task run in `" + env + "` environment" );
	var stream = gulp.src( cssminSrc[ env ] )
		.pipe( p.plumber({
            errorHandler: onError
        }))
		.pipe( p.concat( ppcss ))
		.pipe( p.autoprefixer( "last 2 version" ) )
		.pipe( p.pixrem( 16, { atrules: true }) );

	if ( env === "production" ) {
	//	minifier
		stream = stream.pipe( p.csso() );
	}

	return stream.on( "error", function( e ) {
		console.error( e );
	})
	.pipe( gulp.dest( target + 'css/' ) );
});

/** JSHint */
gulp.task( "jshint", function () {
	/** Test all `js` files exclude those in the `lib` folder */
	return gulp.src( source + "js/{!(lib)/*.js,*.js}" )
		.pipe( p.plumber({
            errorHandler: onError
        }))
        .pipe( p.jshint() )
		.pipe( p.jshint.reporter( "jshint-stylish" ) )
		.pipe( p.jshint.reporter( "fail" ) );
});

/** Uglify */
gulp.task( "uglify", function() {
	return gulp.src( uglifySrc )
		.pipe( p.concat( "scripts.min.js" ) )
		.pipe( p.uglify() )
	//	.pipe( gulp.dest( source + "js/" ) )
		.pipe( gulp.dest( target + "js/" ) );
});

/* compile templates */
gulp.task( "dustc", function() {
	console.log( "`dustc` task run in `" + env + "` environment" );

	return gulp.src( source + "js/tmpl/*.dust" )
		.pipe( p.plumber({ errorHandler: onError }))
		.pipe( p.dust({ name: function(f) { return f.relative; } }) )
		.pipe( p.concat( target + "js/dist/tmpl.js") );
});

/** `env` to 'production' */
gulp.task( "envProduction", function() {
	env = "production";
});

/** Livereload */
gulp.task( "watch", [
//	"template",
	"styles",
//	"jshint"
	], function() {
	var server = p.livereload();

	/** Watch for livereoad */
	gulp.watch([
//		source + "js/**/*.js",
//		source + "*.pm",
		source + "*.css"
	])
	.on( "change", function( file ) {
		console.log( file.path );
		server.changed( file.path );
	});

	/** Watch for autoprefix */
	gulp.watch( [
//		source + "css/*.css",
		source + "css/sass/**/*.scss"
	], [ "styles" ] );

	/** Watch for JSHint */
//	gulp.watch( source +  "js/{!(lib)/*.js,*.js}", ["jshint"] );

});

/** Build */
gulp.task( "build", [
	"envProduction",
	"clean",
	"template",
	"styles",
	"jshint",
//	"copy",
	"uglify"
], function () {
	console.log("Build is finished");
});
