# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "turbolinks:load", ->
  container = $("#pano-container")
  if container.length > 0
    pano = new pano2vrPlayer("pano-container")
    skin = new pano2vrSkin(pano, "/static_resources/pano2vr_skin/")
    pano.readConfigUrlAsync(container.data("pano-config-path"))
