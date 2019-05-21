var gulp = require('gulp');
    bower = require('gulp-bower');
    sass = require('gulp-sass');
    less = require('gulp-less');
    path = require('path');
    minifyCss = require('gulp-minify-css'); 

var config = {
     stylePath: './css',
     bowerDir: './vendor' 
}



gulp.task('less', function () {
  gulp.src('./css/*.less')
    .pipe(less({
        paths: [ path.join(__dirname, 'less', 'includes') ]
    }))
    .pipe(gulp.dest('./css/'));
});

gulp.task('sass', function () {
    gulp.src('./css/*.scss')
        .pipe(sass({
            paths: [ path.join(__dirname, 'less', 'includes') ]    
        }))
        .pipe(gulp.dest('./css'));
});



gulp.task('icons', function() { 
    return gulp.src(config.bowerDir + '/fontawesome/fonts/**.*') 
        .pipe(gulp.dest('./public/fonts')); 
});

gulp.task('bower', function() { 
    return bower()
         .pipe(gulp.dest(config.bowerDir)) 
});

gulp.task('minify-css', function() {
  return gulp.src('css/*.css')
    .pipe(minifyCss({compatibility: 'ie8'}))
    .pipe(gulp.dest('./css'));
});



 gulp.task('watchs', function() {
     gulp.watch(config.stylePath + '/*.scss', ['sass']); 
});

gulp.task('watchl', function() {
     gulp.watch(config.stylePath + '/*.less', ['less']); 
 /*    gulp.watch(config.stylePath + '/*.css', ['minify-css']); */
});

//   gulp.task('default', ['watchl', 'minify-css']);