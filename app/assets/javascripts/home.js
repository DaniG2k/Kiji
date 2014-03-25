/* Place all the behaviors and hooks related to the matching controller here.
* All this logic will automatically be available in application.js.
* You can use CoffeeScript in this file: http://coffeescript.org/
*/
$(document).ready(function(){
  $("ol.rounded-list li").click(function(){
    $(this).find("div.bounce-summary").toggle("slide", {
    	duration: 700,
    	easing: 'easeOutBounce',
    	direction: 'up'
    });
  });
});