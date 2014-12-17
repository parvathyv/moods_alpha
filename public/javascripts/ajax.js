$('.largebutton').click(function(event) {
  event.preventDefault(); 

  $.ajax({
  url: '/moods',
  method: 'POST',
  data: $('form').serialize()

  });
});