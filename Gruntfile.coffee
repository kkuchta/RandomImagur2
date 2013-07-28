module.exports = (grunt) ->

  # Project configuration.
  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json'),
    haml:
      compile:
        files:
          'out/index.html' : 'src/index.haml'
    watch:
      scripts:
        files: 'src/*.haml'
        tasks: 'haml'
        options:
          livereload: true
    copy:
      files:
        expand: true,
        cwd: 'src'
        src: ['**/*.js','**/*.css'],
        dest: 'out/'
  )

  grunt.loadNpmTasks( 'grunt-contrib-watch' )
  grunt.loadNpmTasks( 'grunt-contrib-copy' )
  grunt.loadNpmTasks( 'grunt-haml' )

  # Default task(s).
  grunt.registerTask 'default', ['haml','copy']
