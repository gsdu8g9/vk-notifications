module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    mince: {
      main: {
        options: {
          include: [
            "javascripts",
            "bower_components/jquery/dist",
            "bower_components/angular",
            "bower_components/angular-i18n",
            "bower_components/angular-sanitize",
            "bower_components/components-font-awesome/css",
            "bower_components/normalize.css",
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
            src: ["javascripts/app.js"],
            dest: "public/javascripts/app.js"
          },
          {
            src: ["javascripts/background-app.js"],
            dest: "public/javascripts/background-app.js"
          },
          {
            src: ["stylesheets/styles.scss"],
            dest: "public/stylesheets/styles.css"
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
          'public/popup.html': 'views/popup.slim',
          'public/background.html': 'views/background.slim'
        }
      }
    },
    clean: ['public'],
    copy: {
      manifest: {
        src: 'resources/manifest.json',
        dest: 'public/manifest.json'
      },
      assets: {
        src: 'assets/*',
        dest: 'public/'
      },
      font_awesome_fonts: {
        expand: true,
        cwd: 'bower_components/components-font-awesome/fonts',
        src: '*',
        dest: 'public/fonts'
      }
    },
    karma: {
      unit: {
        configFile: 'karma.conf.js'
      }
    }
  });

  grunt.loadNpmTasks('grunt-mincer');
  grunt.loadNpmTasks('grunt-slim');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-karma');

  grunt.registerTask('default', ['mince', 'slim']);
  grunt.registerTask('test', ['mince', 'karma']);
  grunt.registerTask('build', ['clean', 'default', 'copy']);
};
