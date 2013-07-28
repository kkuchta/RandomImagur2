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
        files: 'src/*'
        tasks: 'default'
        options:
          livereload: true
    copy:
      files:
        expand: true,
        cwd: 'src'
        src: ['**/*.js','**/*.css'],
        dest: 'out/'
    coffee:
      files:
        expand: true,
        cwd: 'src'
        src: ['**/*.coffee'],
        ext: '.js'
        dest: 'out/'
  )

  grunt.loadNpmTasks( 'grunt-contrib-watch' )
  grunt.loadNpmTasks( 'grunt-contrib-copy' )
  grunt.loadNpmTasks( 'grunt-haml' )
  grunt.loadNpmTasks( 'grunt-contrib-coffee' );

  # Default task(s).
  grunt.registerTask 'default', ['haml','copy','coffee']
