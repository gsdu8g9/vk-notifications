module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    mince: {
      main: {
        options: {
          include: [
            "javascripts",
            "bower_components/angular",
            "bower_components/angular-sanitize",
            "bower_components/emoji/lib",
            "stylesheets"
          ],
          enable: ['autoprefixer'],
          engines: {
            Coffee: {},
            Autoprefixer: ['last 5 Chrome versions']
          }
        },
        files: [
          {
            src: ["javascripts/application.js"],
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
    },
    slim: {
      dist: {
        options: {
          pretty: true
        },
        files: {
          'public/options.html': 'views/options.slim',
          'public/popup.html': 'views/popup.slim'
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-mincer');
  grunt.loadNpmTasks('grunt-slim');

  grunt.registerTask('default', ['mince', 'slim']);
};
