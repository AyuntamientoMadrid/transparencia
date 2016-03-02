// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require app
//= require jquery
//= require jquery_ujs
//= require foundation
//= require init-foundation
//= require program-accomplishment
//= require turbolinks
//= require trix
//= require linkable
//= require form_helpers
//= require location_changer

var initialize_modules = function() {
  App.LocationChanger.initialize();
}

$(function(){
  Turbolinks.enableProgressBar()

  $(document).ready(initialize_modules);
  $(document).on('page:load', initialize_modules);
  $(document).on('ajax:complete', initialize_modules);
});
