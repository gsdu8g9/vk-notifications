module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    mince: {
      main: {
        options: {
          include: [
            "javascripts",
            "bower_components/angular",
            "stylesheets"
          ],
          engines: {
            Coffee: {}
          }
        },
        files: [
          {
            src: ["javascripts/app.coffee"],
            dest: "public/javascripts/app.js"
          },
          {
            src: ["stylesheets/styles.scss"],
            dest: "public/stylesheets/styles.css"
          },
          {
            src: ["stylesheets/font-awesome.scss"],
            dest: "public/stylesheets/font-awesome.css"
          }
        ]
      }
    }
  });

  grunt.loadNpmTasks('grunt-mincer');

  grunt.registerTask('default', ['mince']);
};
